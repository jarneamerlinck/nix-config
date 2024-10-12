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
	CONTAINER=`docker ps | rg -v CONTAINER | awk '-F ' ' {print $NF}' | fzf`
	if [ ! -z $CONTAINER ]
	then
		docker exec -it $CONTAINER bash
	fi
}

function fzf-docker-live-log() {
	CONTAINER=`docker ps | rg -v CONTAINER | awk '-F ' ' {print $NF}' | fzf`
	if [ ! -z $CONTAINER ]
	then
		docker logs -f $CONTAINER
	fi
}


function fzf-docker-full-log() {
	CONTAINER=`docker ps | rg -v CONTAINER | awk '-F ' ' {print $NF}' | fzf`
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
		git log --oneline  |  fzf  --multi  --no-sort  --cycle  \
			--preview='echo {}' \
			--preview-window down:10% \
			--layout='reverse-list' \
			--color bg:#222222,preview-bg:#333333 \
	) && git  show  "$selected_commit"
}
function fzf-ssh() {
	local selected_host
	selected_host=$(\
			sed -n -e 's/Host[[:space:]]*//p' ~/.ssh/config \
			| cut -d ' ' -f 1 \
			| grep -v '^$' \
			|  fzf  --multi  --no-sort  --cycle \
			--preview='echo {}' \
			--preview-window down:10% \
			--layout='reverse-list' \
			--color bg:#222222,preview-bg:#333333\

	) && ssh  "$selected_host"
}

function fzf-git-files-updated(){
	git log --pretty=format: --name-only --diff-filter=A | sort -u | while read -r file; do echo "$(git log -n 1 --format="%h" -- "$file") $file"; done |fzf

}
