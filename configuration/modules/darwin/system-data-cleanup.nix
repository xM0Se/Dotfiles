{
  lib,
  config,
  pkgs,
  ...
}: {
  options = {
    custom.system-data-cleanup.enable =
      lib.mkEnableOption "system-data-cleanup, Revmoves all system data of macos every 7days during system rebuild";
  };

  config = lib.mkIf config.custom.system-data-cleanup.enable {
    system.activationScripts.postActivation = {
      text = ''
        CLEANUP_LOG_DIR="/var/log/nix/system-data-cleanup"

        CLEANUP_LOG_TIMESTAMP="$CLEANUP_LOG_DIR/last-run.timestamp"
        CLEANUP_LOG_HISTORY="$CLEANUP_LOG_DIR/history.log"
        CLEANUP_LOG_LATEST="$CLEANUP_LOG_DIR/latest.log"

        MOLE_EXEC_PATH="${pkgs.custom.mole}/bin/mole"

        MOLE_CONFIG_DIR="/var/lib/mole"
        MOLE_CONFIG_WHITELIST="$MOLE_CONFIG_DIR/whitelist"

        CURRENT_HUMAN_DATE=$(date "+%Y-%m-%d %H:%M:%S")

        if [ "$EUID" -ne 0 ]; then
          echo "[$CURRENT_HUMAN_DATE] [ERROR] System data cleanup failed: Insufficient sudo privileges." >> "$CLEANUP_LOG_HISTORY"
          echo "Error: System data cleanup failed. Please run this script using sudo."
          exit 1
        fi

        mkdir -p "$CLEANUP_LOG_DIR"
        mkdir -p "$MOLE_CONFIG_DIR"

        if [ ! -f "$CLEANUP_LOG_TIMESTAMP" ]; then
          echo "0" > "$CLEANUP_LOG_TIMESTAMP"

          touch "$MOLE_CONFIG_WHITELIST"
          grep -qxF "/nix/store/" "$MOLE_CONFIG_WHITELIST" || echo "/nix/store/" >> "$MOLE_CONFIG_WHITELIST"
          grep -qxF "/nix/var/nix/gcroots/" "$MOLE_CONFIG_WHITELIST" || echo "/nix/var/nix/gcroots/" >> "$MOLE_CONFIG_WHITELIST"
        fi

        CURRENT_EPOCH=$(date +%s)
        LAST_RUN_EPOCH=$(cat "$CLEANUP_LOG_TIMESTAMP")

        DAYS_PASSED=$(( (CURRENT_EPOCH - LAST_RUN_EPOCH) / 86400 ))

        if [ "$DAYS_PASSED" -lt 0 ]; then
          DAYS_PASSED=$(( DAYS_PASSED + 365 ))
        fi

        if [ "$DAYS_PASSED" -ge 7 ]; then

          echo "Starting system data cleanup..."

          if sudo "$MOLE_EXEC_PATH" clean 2>/dev/null | tee -a "$CLEANUP_LOG_LATEST" | grep "Tracked cleanup:" > /tmp/freespace.txt 2>&1; then
            FREE_SPACE_CHANGE=$(cat /tmp/freespace.txt)
            CLEANED_FREE_SPACE=$(echo "$FREE_SPACE_CHANGE" | awk -F': ' '{print $2}' | awk '{print $1}')

            echo "[$CURRENT_HUMAN_DATE] [INFO] System data cleanup completed successfully. Space removed: $CLEANED_FREE_SPACE." >> $CLEANUP_LOG_HISTORY
            echo "System data cleanup completed successfully Removed: $CLEANED_FREE_SPACE"

            echo "$CURRENT_EPOCH" > "$CLEANUP_LOG_TIMESTAMP"

            rm -f /tmp/freespace.txt
            rm -f $CLEANUP_LOG_LATEST
          else
            echo "[$CURRENT_HUMAN_DATE] [ERROR] System data cleanup failed." >> "$CLEANUP_LOG_HISTORY"
            echo "Error: System data cleanup failed. Check '$CLEANUP_LOG_LATEST' for details." >&2

            rm -f /tmp/freespace.txt
          fi

        else
          echo "Skipping system data removal. Only $DAYS_PASSED days have passed since the last run (minimum is 7)."
          echo "[$CURRENT_HUMAN_DATE] [INFO] Skipping system data cleanup. Days passed: $DAYS_PASSED." >> "$CLEANUP_LOG_HISTORY"
        fi
      '';
    };
  };
}
