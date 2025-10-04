function mux() {
    project_dir=$1
    if [[ -z "$project_dir" ]]; then
        echo "Usage: mux <project_directory> [session_name]"
        return 1
    fi
    session_name=${2:-$(basename $(realpath "$project_dir"))}
    whole_path=$(realpath "$project_dir")
    if [[ $whole_path == "*No such file or directory*" ]]; then
        echo "Directory does not exist: $project_dir"
        return 1
    fi

    # check if file doesn't exist yet in the tmuxinator config directory
    tmuxinator_config=~/.config/tmuxinator/$session_name.yml
    if [[ -f $tmuxinator_config ]]; then
        echo "File already exists"
    else
        cp ~/.config/tmuxinator/template.yml.temp $tmuxinator_config
        # replace variables in placeholder config with real values - PROJECT_NAME, PROJECT_ROOT
        sed -i '' "s|{{\$PROJECT_NAME}}|$session_name|g" $tmuxinator_config
        sed -i '' "s|{{\$PROJECT_ROOT}}|$whole_path|g" "$tmuxinator_config"
    fi

    tmuxinator start $session_name

}
complete -o default mux
