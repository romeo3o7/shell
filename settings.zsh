stg() {
    case $1 in
	c)   nv ~/projects/c/;;
    sway) 	nv ~/.config/sway/config;;
    nvim) 	nv ~/.config/nvim/init.lua;;
    zsh)  	nv ~/.zshrc;;
    alias) 	nv ~/.config/zsh/zsh_alias;;
    fun) 	nv ~/projects/shell;;
    todo) 	nv ~/temp/todo.txt;;
	temp) 	if [ -f ~/temp/temp.txt ] && rm ~/temp/temp.txt; nv temp/temp.txt;;
	firefox)nv ~/.config/mozilla/firefox/4hton2hq.default-release/user.js;;
	*)		cat ~/temp/stgError.txt;;
    esac
}
