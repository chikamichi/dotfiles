# ~/.oh-my-zsh/custom/autosuggestions-settings.zsh
# @see https://github.com/zsh-users/zsh-autosuggestions/blob/fedc22e9bbd046867860e772d7d6787f5dae9d4c/src/widgets.zsh

#zle -N autosuggest-accept _zsh_autosuggest_widget_accept

bindkey '^ ' autosuggest-accept
# bindkey '^[^@' autosuggest-partial-accept
bindkey '^[^@' forward-word
