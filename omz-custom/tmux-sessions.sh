function tat() {
    PROJECT_DIR=${1:-.}
    SAFE_INPUT=$(printf '%s\n' "$PROJECT_DIR" | sed 's/[][\.^$*+?{}|()]/\\&/g')
    ALL_PROJECTS=$(tls)
    IS_VALID_PROJECT=$(echo $ALL_PROJECTS | grep -io "[[:<:]]$SAFE_INPUT\w*" | head -1)
    if [[ $IS_VALID_PROJECT != "" ]]; then
        if [[ "$IS_VALID_PROJECT" == "vrm-deploy" ]] && tmux has-session -t vrm-deploy 2>/dev/null; then
            current_session=$(tmux display-message -p '#S' 2>/dev/null)
            if [[ "$current_session" == "vrm-deploy" ]]; then
                tmux rename-session -t vrm-deploy vrm-deploy-old
                tmuxinator start vrm-deploy
                tmux kill-session -t vrm-deploy-old 2>/dev/null
                return 0
            else
                tmux kill-session -t vrm-deploy 2>/dev/null
            fi
        fi
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

function tls() {
    tmuxinator list | grep -v tmuxinator | tr ' ' '\n' | grep -v '^$'
}
