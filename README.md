# hyprland-wrapperskipper
A script to help move between Hyprland workspaces more efficiently. As a decade plus Awesome WM user, this is intended as a compromise between the efficiency of Hyprland's dynamic workspaces, while allowing me to cap the number of workspaces to maintain my sanity. It does the following:
- If the input argument is 'next', it moves to the next occupied workspace, wrapping to the first if necessary.
- If the input argument is 'prev', it moves to the previous occupied workspace, wrapping to the last if necessary.
- If the input argument is 'new', it finds the next available empty workspace
- Optionally, if a second argument 'with_window' is provided, it also moves the currently focused window to the target workspace.

Keybinding example snippet:
```
bind = $mainMod, N, exec, ~/.config/hypr/scripts/wrapperskipper.sh new
bind = $mainMod SHIFT, N, exec, ~/.config/hypr/scripts/wrapperskipper.sh new with_window
bind = $mainMod, 9, exec, ~/.config/hypr/scripts/wrapperskipper.sh prev
bind = $mainMod, 0, exec, ~/.config/hypr/scripts/wrapperskipper.sh next
bind = $mainMod SHIFT, 9, exec, ~/.config/hypr/scripts/wrapperskipper.sh prev with_window
bind = $mainMod SHIFT, 0, exec, ~/.config/hypr/scripts/wrapperskipper.sh next with_window
```
