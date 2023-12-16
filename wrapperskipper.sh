#!/usr/bin/env bash

# This script is designed for workspace navigation in Hyprland. It requires the jq package
# It is intended help to efficiently navigate workspaces, while setting a limit on the number of workspaces in use.
# - If the input argument is 'next', it moves to the next occupied workspace, wrapping to the first if necessary.
# - If the input argument is 'prev', it moves to the previous occupied workspace, wrapping to the last if necessary.
# - If the input argument is 'new', it finds the next available empty workspace
# - Optionally, if a second argument 'with_window' is provided, it also moves the currently focused window to the target workspace.
# Note: Ensure the 'max_workspaces' variable is set to the maximum number of workspaces for wrapping behavior.

# Set a maximum workspace number for wrapping back to 1:
max_workspaces=7

# Get the current workspace ID
current_workspace=$(hyprctl activeworkspace -j | jq '.id')

# Get a sorted list of workspaces with their window counts
occupied_workspaces=$(hyprctl workspaces -j | jq -c '.[] | select(.windows > 0) | .id' | sort -n)

# Convert occupied workspaces to an array
occupied_workspace_array=($occupied_workspaces)

# Determine the target workspace based on the argument
if [ "$1" = "next" ]; then
  # Find the next occupied workspace or wrap around
  found=false
  for workspace in "${occupied_workspace_array[@]}"; do
    if [[ $workspace -gt $current_workspace ]]; then
      target_workspace=$workspace
      found=true
      break
    fi
  done
  if [[ $found = false ]]; then
    target_workspace=${occupied_workspace_array[0]}
  fi
elif [ "$1" = "prev" ]; then
  # Find the previous occupied workspace or wrap around
  for ((i=${#occupied_workspace_array[@]}-1; i>=0; i--)); do
    if [[ ${occupied_workspace_array[i]} -lt $current_workspace ]]; then
      target_workspace=${occupied_workspace_array[i]}
      break
    fi
  done
  if [[ -z $target_workspace ]]; then
    target_workspace=${occupied_workspace_array[-1]}
  fi
elif [ "$1" = "new" ]; then
  # Find the next empty workspace, considering wrapping
  target_workspace=$current_workspace
  while [[ " ${occupied_workspace_array[*]} " =~ " ${target_workspace} " ]] || [[ $target_workspace -eq 0 ]]; do
    target_workspace=$(( (target_workspace % max_workspaces) + 1 ))
  done
else
  echo "Invalid argument. Use 'next', 'prev', or 'new'."
  exit 1
fi

# If the second argument is "with_window", move the focused window to the target workspace
if [ "$2" = "with_window" ]; then
  hyprctl dispatch movetoworkspace "$target_workspace"
fi

# Switch to the target workspace
hyprctl dispatch workspace "$target_workspace"
