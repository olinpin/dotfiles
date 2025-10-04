function mx() {
    PROJECT_DIR=$1
    if [[ -z "$PROJECT_DIR" ]]; then
        echo "Usage: mx <project_directory> [SESSION_NAME]"
        return 1
    fi

    ALL_PROJECTS=$(get_mux_sessions)
    IS_VALID_PROJECT=$(echo $ALL_PROJECTS | grep -o "\b$PROJECT_DIR\w*" | head -1)
    if [[ $IS_VALID_PROJECT != "" ]]; then
        echo $IS_VALID_PROJECT
        tmuxinator start "$IS_VALID_PROJECT"
        return 1
    fi

    SESSION_NAME=${2:-$(basename $(realpath "$PROJECT_DIR"))}
    WHOLE_PATH=$(realpath "$PROJECT_DIR")
    if [[ $WHOLE_PATH == "*No such file or directory*" ]]; then
        echo "Directory does not exist: $PROJECT_DIR"
        return 1
    fi

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
    ALL_PROJECTS=$(tmuxinator list | grep -v tmuxinator)
    echo $ALL_PROJECTS
}

function _mx_autocomplete() {
    local cur
    cur="${COMP_WORDS[COMP_CWORD]}"
    local projects="$(get_mux_sessions)"
    COMPREPLY=()
    while IFS= read -r line; do
      COMPREPLY+=("$line")
    done < <(
      { compgen -W "$projects" -- "$cur"; compgen -f -- "$cur"; } | sort -u
    )
}

complete -f -F _mx_autocomplete -o default mx
