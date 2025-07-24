{ ... }:

{
  # System-level LaunchD services configuration
  launchd.user.agents.raycast.serviceConfig = {
    Disabled = false;
    ProgramArguments = [ "/Applications/Raycast.app/Contents/Library/LoginItems/RaycastLauncher.app/Contents/MacOS/RaycastLauncher" ];
    RunAtLoad = true;
  };
}
