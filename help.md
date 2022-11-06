# 安裝
1. 將 ipfs-tool.sh 放到 $PATH
2. 將 ipns（由管理者提供）放到 `~/.config/ipfs-tool/ipns`（文字檔）
3. 執行 `ipfs-tool add` 將最新的文件清單抓下來

# 管理者
1. 產生 key `ipfs key gen`
2. 用 `ipfs-tool ipns` 取得公鑰（ipns）
3. 可以直接修改提供的 ipfs-tool.sh，這樣一般使用者就不用去找 ipns

# 新增檔案
`ipfs-tool add <file> [file path]`  
`<file>` 是你要新增的檔案，`[file path]` 是你的檔案在 list 中的名字，如果不設定的話預設是和 `<file>` 一樣  
這個指令會順便更新 list

# 下載
`ipfs-tool get <file>`  
建議下載前先用 `ipfs-tool add` 更新 list


# 指令
## `ipfs-tool add`
1. ipfs cat $listCID > localList
2. show diff

## `ipfs-tool upgrade`
1. for i in localList
2. if i != i in downloaded list
3. ipfs get i

## `ipfs-tool ls`
1. cat localList

##  `ipfs-tool get <file path>`
1. get CID from list
2. get file

## `ipfs-tool add <file> [file path]`
1. ipfs add file
2. add list
3. add ipns to list

## config 
* store at `${XDG_CONFIG_HOME:=$HOME/.config}`
* data 
	* local list
	* downloaded list
	* listCID
	* local file path(used by `ipfs-tool upgrade`)
	* key for add ipns
