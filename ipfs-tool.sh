#!/bin/bash
#
# exit code
# 1: arg miss
# 2: unknown error when execute ipfs command

# utils

getListIPNS(){
	if [[ -f "$(getConfigDir)/ipns" ]]; then 
		cat $(getConfigDir)/ipns
	else
		echo '/ipns/k51qzi5uqu5dimnxanwi9mp3gwip087mf8b6xkg4lw6r8dwndy5les50ydqe9m'
	fi
}

getConfigDir(){
	echo ~/.config/ipfs-tool
}

# subcommands
add(){
	ipfs cat $(getListIPNS) > $(getConfigDir)/list
	# show diff
}

upgrade(){
	echo this subcmd is not finished
}

list(){
	if [[ -z $1 ]]; then
		cat $(getConfigDir)/list
	else
		grep $(getConfigDir)/list -e "$1" | cut -d' ' -f2
	fi
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

ipns(){
	ipfs name publish $(echo | ipfs add -Q) | cut -d' ' -f3 | cut -d: -f1
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
	echo "    add                         add list"
	echo "    upgrade                     upgrade all files"
	echo "    ls                          cat list"
	echo "    get <file path>             download specific file to cwd"
	echo "    upload <file> [file path]   upload file to ipfs"
	echo "    help                        print this"
	echo "    ipns                        get ipns publish key(only for admin)"
	echo 
	echo "exit code:"
	echo "    0: no error"
	echo "    1: arguments missed"
	echo "    2: unknown error when execute ipfs command"
}

# init
mkdir -p $(getConfigDir)

case $1 in
	add)
		add
		;;
	upgrade)
		upgrade
		;;
	ls)
		list $2
		;;
	get)
		get $2
		;;
	upload)
		upload $2 $3
		;;
	ipns)
		ipns
		;;
	help|-h|--help|*)
		help
		;;
esac
