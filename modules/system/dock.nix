{ ... }:

{
  # Shared dock settings - behavior and appearance
  system.defaults.dock = {
    autohide = true;  # hide dock
    autohide-delay = 0.00;  # delay before dock shows
    autohide-time-modifier = 0.50;  # speed of dock animation when showing/hiding
    show-recents = false;
    launchanim = true;
    orientation = "bottom";
    tilesize = 48;
    wvous-bl-corner = 4; # hot corner that shows desktop when hovering mouse over bottom left corner
    mouse-over-hilite-stack = true; # highlight effect that follows the mouse in a Dock stack
    # persistent-apps configured per-host
  };
}
