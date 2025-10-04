function mx() {
    PROJECT_DIR=${1:-.}
    SAFE_INPUT=$(printf '%s\n' "$PROJECT_DIR" | sed 's/[][\.^$*+?{}|()]/\\&/g')
    ALL_PROJECTS=$(get_mux_sessions)
    IS_VALID_PROJECT=$(echo $ALL_PROJECTS | grep -o "[[:<:]]$SAFE_INPUT\w*" | head -1)
    if [[ $IS_VALID_PROJECT != "" ]]; then
        tmuxinator start "$IS_VALID_PROJECT"
        return 1
    fi

    if [ -d "$PROJECT_DIR" ]; then
    else
        echo "Directory does not exist: $PROJECT_DIR"
        return 1
    fi

    WHOLE_PATH=$(realpath "$PROJECT_DIR")
    SESSION_NAME=${2:-$(basename $WHOLE_PATH)}
    # check if file doesn't exist yet in the tmuxinator config directory
    TMUXINATOR_CONFIG=~/.config/tmuxinator/$SESSION_NAME.yml
    if [[ -f $TMUXINATOR_CONFIG ]]; then
    else
        cp ~/.config/tmuxinator/template.yml.temp $TMUXINATOR_CONFIG
        # replace variables in placeholder config with real values - PROJECT_NAME, PROJECT_ROOT
        sed -i '' "s|{{\$PROJECT_NAME}}|$SESSION_NAME|g" $TMUXINATOR_CONFIG
        sed -i '' "s|{{\$PROJECT_ROOT}}|$WHOLE_PATH|g" "$TMUXINATOR_CONFIG"
    fi

    tmuxinator start $SESSION_NAME

}

function get_mux_sessions() {
    tmuxinator list | grep -v tmuxinator | tr ' ' '\n' | grep -v '^$'
}

function _mx_autocomplete() {
    local -a projects files dirs
    local expl

    # Get tmuxinator projects
    projects=(${(f)"$(get_mux_sessions)"})

    # Get files and directories with proper completion
    _alternative \
        'projects:tmuxinator projects:compadd -a projects' \
        'files:files:_files'
}

# Register the completion function for zsh
if [[ -n ${ZSH_VERSION-} ]]; then
    compdef _mx_autocomplete mx
else
    # Fallback for bash
    complete -f -F _mx_autocomplete -o default mx
fi
