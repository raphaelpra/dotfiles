# set -g fish_user_paths "/usr/local/sbin" $fish_user_paths
set -g fish_user_path /usr/local/sbin $HOME/anaconda/bin $GOPATH/bin
# set -U fish_user_paths $fish_user_paths
# set -U fish_user_paths $fish_user_paths
rvm default

test -e {$HOME}/.iterm2_shell_integration.fish ; and source {$HOME}/.iterm2_shell_integration.fish
set -g fish_user_paths "/usr/local/sbin" $fish_user_paths
