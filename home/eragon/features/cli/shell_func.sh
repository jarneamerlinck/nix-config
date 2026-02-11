function sha256() {
    echo "$1 $2" | sha256sum --check
}

function unlock-keyring ()
{
    read -rsp "Password: " pass
    export $(echo -n "$pass" | gnome-keyring-daemon --replace --unlock)
    unset pass
}

function fzf-docker-exec() {
	CONTAINER=$(docker ps | rg -v CONTAINER | awk '-F ' ' {print $NF}' | fzf \
	  --multi \
	  --no-sort \
	  --preview-window down:10% \
	  --cycle \
	  --color bg:#222222,preview-bg:#333333 \
	  --layout='reverse-list' \
	  --prompt="Select host: ")
	if [ ! -z $CONTAINER ]
	then
		docker exec -it $CONTAINER sh -c 'bash || sh'
	fi
}

function fzf-docker-live-log() {
	CONTAINER=$(docker ps | rg -v CONTAINER | awk '-F ' ' {print $NF}' | fzf \
	  --multi \
	  --no-sort \
	  --preview-window down:10% \
	  --cycle \
	  --color bg:#222222,preview-bg:#333333 \
	  --layout='reverse-list' \
	  --prompt="Select host: ")
	if [ ! -z $CONTAINER ]
	then
		docker logs -f $CONTAINER
	fi
}


function fzf-docker-full-log() {
	CONTAINER=$(docker ps | rg -v CONTAINER | awk '-F ' ' {print $NF}' | fzf \
	  --multi \
	  --no-sort \
	  --preview-window down:10% \
	  --cycle \
	  --color bg:#222222,preview-bg:#333333 \
	  --layout='reverse-list' \
	  --prompt="Select host: ")
	if [ ! -z $CONTAINER ]
	then
		sudo cat $(docker inspect --format='{{.LogPath}}' $CONTAINER) | nvim -
		# nvim $(docker inspect --format='{{.LogPath}}' $CONTAINER)
		# FULL_FILE_PATH=docker inspect --format='{{.LogPath}}' $CONTAINER
		# nvim $FULL_FILE_PATH
		# docker inspect --format='{{.LogPath}}' $CONTAINER | nvim
	fi
}


function  fzf-git-log() {
	local  selected_commit
	selected_commit=$(\
		git log --oneline  |  fzf \
					 --multi \
	 				 --no-sort \
	 				 --preview-window down:10% \
	 				 --cycle \
	 				 --color bg:#222222,preview-bg:#333333 \
	 				 --layout='reverse-list' \
	 				 --prompt="Select host: " \
	) && git  show  "$selected_commit"
}




function fzf-ssh() {
  if [[ ! -f ~/.ssh/config ]]; then
    echo "No .ssh/config file found."
    return 1
  fi

  local hosts=$(grep -E '^Host ' ~/.ssh/config | grep -vE '^Host \*' | awk '{for (i=2; i<=NF; i++) print $i}')

  local selected_host=$(echo "$hosts" | fzf \
	  --preview-window down:10% \
	  --cycle \
	  --color bg:#222222,preview-bg:#333333 \
	  --layout='reverse-list' \
	  --prompt="Select host: ")

  if [[ -n "$selected_host" ]]; then
    echo "Connecting to $selected_host..."
    ssh "$selected_host"
  else
    echo "No host selected."
  fi
}

function fzf-git-files-updated(){
	git log --pretty=format: --name-only --diff-filter=A | sort -u | while read -r file; do echo "$(git log -n 1 --format="%h" -- "$file") $file"; done | fzf \
	  --preview-window down:10% \
	  --cycle \
	  --color bg:#222222,preview-bg:#333333 \
	  --layout='reverse-list' \
	  --prompt="get updated git files: "

}

function fzf-kube-namespace() {
	NAMESPACE=$(kubectl get namespaces --no-headers | awk '{print $1}' | fzf \
	  --no-sort \
	  --preview-window down:10% \
	  --cycle \
	  --color bg:#222222,preview-bg:#333333 \
	  --layout='reverse-list' \
	  --prompt="Select namespace: ")

	if [ ! -z "$NAMESPACE" ]; then
		kubectl config set-context --current --namespace="$NAMESPACE"
		echo "Switched to namespace: $NAMESPACE"
	fi
}

function fzf-kube-context() {
	CONTEXT=$(kubectl config get-contexts --no-headers | awk '{print $1}' | fzf \
	  --no-sort \
	  --preview-window down:10% \
	  --cycle \
	  --color bg:#222222,preview-bg:#333333 \
	  --layout='reverse-list' \
	  --prompt="Select context: ")

	if [ ! -z "$CONTEXT" ]; then
		kubectl config use-context "$CONTEXT"
		echo "Switched to context: $CONTEXT"
	fi
}


function fzf-hm-specialisation() {
    local SPECIALISATIONS_DIR="$HOME/.local/state/nix/profiles/home-manager/specialisation"

    if [ ! -d "$SPECIALISATIONS_DIR" ]; then
        echo "No specialisations found in $SPECIALISATIONS_DIR"
        return 1
    fi

    SPECIALISATION=$(ls -1 "$SPECIALISATIONS_DIR" \
        | fzf \
	  --no-sort \
	  --preview-window down:10% \
	  --cycle \
	  --color bg:#222222,preview-bg:#333333 \
	  --layout='reverse-list' \
	  --prompt="Select Home Manager specialisation: ")

    if [ -n "$SPECIALISATION" ]; then
        echo "Switching to specialisation: $SPECIALISATION"
        $SHELL $SPECIALISATIONS_DIR/$SPECIALISATION/activate
    fi
}


function preview_window() {
    local id=$1
    swaymsg -t get_tree | \
        jq -r '.. | objects | select(.id==${id}) | @json' | \
        head -n 10 | \
        column -t
}

# Main function
function fzf-sway-move-window() {
    # 1) Grab every window (con) with id and name
    local windows
    windows=$(swaymsg -t get_tree | \
        jq -r '.. | objects | select(.type=="con") | "\(.id)\t\(.name)"' | \
        sort -n)

    # If there are no windows bail out
    if [[ -z $windows ]]; then
        echo "No windows found" >&2
        return 1
    fi

    # 2) Pick a window
    local win
    win=$(printf '%s\n' "$windows" | \
        fzf --height=40% --reverse --no-sort \
            --preview="preview_window {+}" \
            --preview-window=down:10% \
            --color=bg:#222222,preview-bg:#333333 \
            --layout=reverse-list \
            --prompt="Select window to move: ")

    # User cancelled
    [[ -z $win ]] && return

    # Split into ID and name
    local win_id win_name
    IFS=$'\t' read -r win_id win_name <<< "$win"

    # 3) Grab workspace list
    local workspaces
    workspaces=$(swaymsg -t get_workspaces | \
        jq -r '.[] | "\(.name)"' | sort)

    # 4) Pick a workspace
    local ws
    ws=$(printf '%s\n' "$workspaces" | \
        fzf --height=30% --reverse --no-sort \
            --preview="echo -e \"Workspace: \n{+}\"" \
            --preview-window=down:10% \
            --color=bg:#222222,preview-bg:#333333 \
            --layout=reverse-list \
            --print-query \
            --prompt="Move window to workspace: ")

    [[ -z $ws ]] && return

    query=$(printf "%s" "$ws" | sed -n '1p')
    selection=$(printf "%s" "$ws" | sed -n '2p')

    # If a workspace was selected → use it
    if [[ -n "$selection" ]]; then
        ws="$selection"
    else
        # No options left; use typed query
        ws="$query"
    fi

    # 5) Move the window
    echo "Moving window $win_id ($win_name) to workspace $ws …"
    # swaymsg "move node to workspace $ws" 1>/dev/null
    swaymsg "[con_id=$win_id] move to workspace $ws"

    echo "Done."
}
