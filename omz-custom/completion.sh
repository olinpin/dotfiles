# autocomplete

_cmr() {
  local -a opts
  opts=('--draft')

  # If completing an option
  if [[ $words[CURRENT] == -* ]]; then
    _describe 'options' opts
    return
  fi

  # Extract the full argument being completed (comma-separated)
  local cur=$words[CURRENT]
  local prefix last
  prefix="${cur%,*}"
  last="${cur##*,}"

  # Build GitLab query
  local query="users?state=active&per_page=100"
  local last_len=${#last}

  # Only use &search= when there are 3 or more characters
  if (( last_len >= 3 )); then
    query="${query}&search=${last}"
  fi

  # Fetch usernames
  local -a users
  users=("${(@f)$(glab api "$query" 2>/dev/null | jq -r '.[].username')}")

  # If 1–2 chars, do local filtering over the full list
  if (( last_len > 0 && last_len < 3 )); then
    local -a filtered
    local u
    for u in "${users[@]}"; do
      # substring match; change to == ${last}* for prefix-only
      [[ $u == *${last}* ]] && filtered+="$u"
    done
    users=("${filtered[@]}")
  fi

  # Build final completion items
  local -a completions
  if [[ "$prefix" != "$cur" ]]; then
    prefix="${prefix},"
    completions=("${prefix}${^users}")
  else
    completions=("${users[@]}")
  fi

  _describe 'users' completions
}

function _tat_autocomplete() {
    local -a projects files dirs
    local expl

    # Get tmuxinator projects
    projects=(${(f)"$(tls)"})

    # Get files and directories with proper completion
    _alternative \
        'projects:tmuxinator projects:compadd -a projects' \
        'files:files:_files'
}

# Register the completion function for zsh
if [[ -n ${ZSH_VERSION-} ]]; then
    compdef _tat_autocomplete tat
    compdef _cmr cmr
else
    # Fallback for bash
    complete -f -F _tat_autocomplete -o default tat
    complete -f -F _cmr -o default tat
fi
