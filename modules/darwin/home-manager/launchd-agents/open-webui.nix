{ config, pkgs, lib, user, ... }:

with lib;
let
  homeDir = config.home.homeDirectory;
  notifyService = "${homeDir}/.nix-profile/bin/notify-service";
in
{
  launchd.agents.open-webui = {
    enable = true;
    config = {
      EnvironmentVariables = {
        PATH = "${homeDir}/.nix-profile/bin:/etc/profiles/per-user/${user}/bin:/run/current-system/sw/bin:/nix/var/nix/profiles/default/bin:/usr/bin:/bin:/usr/sbin:/sbin";
      };
      ProgramArguments = [
        "${pkgs.bash}/bin/bash"
        "-c"
        ''
          log_file="/tmp/open-webui-debug.log"
          sleep_time=15
          colima_retries=3
          colima_attempt=1
          docker_retries=3
          docker_attempt=1

          echo "$(date) - Starting Open WebUI..." >> "$log_file"

          while [ "$colima_attempt" -le "$colima_retries" ]; do
            colima_output="$(${pkgs.colima}/bin/colima status 2>&1)"
            echo "$(date) - Colima status output: $colima_output" >> "$log_file"
            if echo "$colima_output" | grep -q "colima is not running"; then
              if [ "$colima_attempt" -lt "$colima_retries" ]; then
                sleep "$sleep_time"
                colima_attempt=$((colima_attempt + 1))
                continue
              else
                echo "$(date) - Colima failed to start after $colima_retries attempts." >> "$log_file"
                ${notifyService} "Open WebUI" "Colima is not running. Open WebUI cannot start."
                exit 0
              fi
            else
              echo "$(date) - Colima is running, proceeding to start Open WebUI." >> "$log_file"
              break
            fi
          done

          while [ "$docker_attempt" -le "$docker_retries" ]; do
            echo "$(date) - Checking running Docker containers (Attempt $docker_attempt)..." | tee -a "$log_file"
            docker_ps_output="$(${pkgs.docker}/bin/docker ps --format '{{.Names}}' 2>&1)"
            echo "$(date) - docker ps output: $docker_ps_output" >> "$log_file"
            if echo "$docker_ps_output" | grep -q "^open-webui$"; then
              echo "$(date) - Open WebUI is already running, exiting." >> "$log_file"
              exit 0
            fi

            echo "$(date) - Checking all Docker containers..." >> "$log_file"
            docker_ps_a_output="$(${pkgs.docker}/bin/docker ps -a --format '{{.Names}}' 2>&1)"
            echo "$(date) - docker ps -a output: $docker_ps_a_output" >> "$log_file"
            if echo "$docker_ps_a_output" | grep -q "^open-webui$"; then
              echo "$(date) - Open WebUI container exists but is stopped. Restarting it..." | tee -a "$log_file"
              ${pkgs.docker}/bin/docker start open-webui >> "$log_file" 2>&1
              exit 0
            fi

            echo "$(date) - Attempting to start Open WebUI container (try $docker_attempt)..." | tee -a "$log_file"
            output="$(${pkgs.docker}/bin/docker run -d -p 3000:8080 --add-host=host.docker.internal:host-gateway -v open-webui:/app/backend/data --name open-webui --restart always ghcr.io/open-webui/open-webui:main 2>&1)"
            docker_exit_code=$?

            echo "$(date) - Docker run output: $output" >> "$log_file"
            echo "$(date) - Docker exit code: $docker_exit_code" >> "$log_file"
            if [[ "$output" =~ ^[0-9a-f]{64}$ ]]; then
              ${notifyService} "Open WebUI" "Started successfully."
              exit 0
            else
              if [ "$docker_attempt" -lt "$docker_retries" ]; then
                sleep "$sleep_time"
                docker_attempt=$((docker_attempt + 1))
                continue
              else
                echo "$(date) - Open WebUI failed to start after $docker_retries attempts." >> "$log_file"
                ${notifyService} "Open WebUI" "Docker failed to start Open WebUI after $docker_retries attempts.\nError: $output"
                exit 0
              fi
            fi
          done
        ''
      ];
      RunAtLoad = true;
      ProcessType = "Interactive";
      KeepAlive = {
        Crashed = true;
      };
    };
  };
}
