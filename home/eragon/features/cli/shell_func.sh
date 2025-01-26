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
