#!/bin/bash
#
# exit code
# 1: arg miss
# 2: unknown error when execute ipfs command

# utils

getListIPNS(){
	echo 'k51qzi5uqu5dimnxanwi9mp3gwip087mf8b6xkg4lw6r8dwndy5les50ydqe9m'
}

getConfigDir(){
	echo ~/.config/ipfs-tool
}

# subcommands
update(){
	ipfs cat /ipns/$(getListIPNS) > $(getConfigDir)/list
	# show diff
}

upgrade(){
	echo upgrade
}

list(){
	cat $(getConfigDir)/list
}

get(){
	# now can only get file, directory is not support yet
	if [[ -z $1 ]]; then
		echo 'ipfs get <file name>'
		exit 1
	fi
	ipfs get $(grep $(getConfigDir)/list -e $1 | cut -d' ' -f2) -o $1
}

upload(){
	if [[ -z $1 ]]; then
		echo 'ipfs upload <file> [file path]'
		exit 1
	fi
	file=$1
	filepath=${2:-$file}
	cid=$(ipfs add -Q $file)

	if grep $(getConfigDir)/list -e $filepath 2>&1 > /dev/null; then
		# found
		sed -i "s/$filepath .*/$filepath $cid/" $(getConfigDir)/list
	else
		# not found
		echo $filepath $cid >> $(getConfigDir)/list
	fi

	listCid=$(ipfs add -Q $(getConfigDir)/list)
	if ipfs name publish --key=$(getListIPNS) /ipfs/$listCid 2>&1 > /dev/null; then
		echo finish
	else
		echo error
		exit 2
	fi
}

help(){
	echo "A cli tool to simplify ipfs"
	echo 
	echo "usage:"
	echo "    ifps-tool.sh [option] [subcmd]"
	echo 
	echo "options:"
	echo "    --help  -h  print this"
	echo 
	echo "sumcmds:"
	echo "    update                      update list"
	echo "    upgrade                     upgrade all files"
	echo "    ls                          cat list"
	echo "    get <file path>             download specific file to cwd"
	echo "    upload <file> [file path]   upload file to ipfs"
	echo "    help                        print this"
}

# init
mkdir -p $(getConfigDir)

case $1 in
	update)
		update
		;;
	upgrade)
		upgrade
		;;
	ls)
		list
		;;
	get)
		get $2
		;;
	upload)
		upload $2 $3
		;;
	help|-h|--help|*)
		help
		;;
esac
