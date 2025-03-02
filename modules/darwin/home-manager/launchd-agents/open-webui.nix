{ config, pkgs, lib, ... }:

with lib;
let
  scripts = import ../scripts { inherit pkgs; }; # Import scripts module
in
{
  launchd.agents.open-webui = {
    enable = true;
    config = {
      ProgramArguments = [
        "${pkgs.bash}/bin/bash"
        "-c"
        ''
          colima_retries=2
          colima_attempt=1

          # Retry checking Colima status up to 2 times (every 10 seconds)
          while [ "$colima_attempt" -le "$colima_retries" ]; do
            colima_output="$(${pkgs.colima}/bin/colima status 2>&1)"
            if echo "$colima_output" | grep -q "colima is not running"; then
              if [ "$colima_attempt" -lt "$colima_retries" ]; then
                ${scripts.notifyServiceScript}/bin/notify-service "Open WebUI" "Colima is not running. Retrying in 10 seconds... (Attempt $colima_attempt/$colima_retries)"
                sleep 10
                colima_attempt=$((colima_attempt + 1))
                continue
              else
                ${scripts.notifyServiceScript}/bin/notify-service "Open WebUI" "Colima is not running after $colima_retries attempts. Open WebUI cannot start."
                exit 1  # Stop further retries
              fi
            else
              break  # Colima is running, proceed with launching Open WebUI
            fi
          done

          docker_retries=2
          docker_attempt=1

          # Retry Docker command up to 2 times (every 10 seconds) if it fails
          while [ "$docker_attempt" -le "$docker_retries" ]; do
            output="$(${pkgs.docker}/bin/docker run -d -p 3000:8080 --add-host=host.docker.internal:host-gateway -v open-webui:/app/backend/data --name open-webui --restart always ghcr.io/open-webui/open-webui:main 2>&1)"
            err="$?"

            if [ "$err" -eq 0 ]; then
              ${scripts.notifyServiceScript}/bin/notify-service "Open WebUI" "Started successfully."
              exit 0
            else
              if [ "$docker_attempt" -lt "$docker_retries" ]; then
                ${scripts.notifyServiceScript}/bin/notify-service "Open WebUI" "Docker failed to start Open WebUI. Retrying in 10 seconds... (Attempt $docker_attempt/$docker_retries)\nError: $output"
                sleep 10
                docker_attempt=$((docker_attempt + 1))
                continue
              else
                ${scripts.notifyServiceScript}/bin/notify-service "Open WebUI" "Docker failed to start Open WebUI after $docker_retries attempts.\nError: $output"
                exit 1  # Stop retrying
              fi
            fi
          done
        ''
      ];
      RunAtLoad = true;   # Start on login
      ProcessType = "Background";
      KeepAlive = false;  # Do not restart if it fails
    };
  };
}
