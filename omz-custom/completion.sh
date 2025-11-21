# autocomplete

_cmr() {
  emulate -L zsh
  setopt extended_glob

  local -a opts
  opts=('--draft')

  # Complete options
  if [[ $words[CURRENT] == -* ]]; then
    _describe 'options' opts
    return
  fi

  # Full current "word" at cursor (may contain commas)
  local cur=$words[CURRENT]

  # Split into prefix (before last comma) and fragment being typed (after last comma)
  local prefix last
  prefix="${cur%,*}"
  last="${cur##*,}"
  local last_len=${#last}

  # Tell zsh: "this part is fixed, don't match on it"
  if [[ "$prefix" != "$cur" ]]; then
    IPREFIX="${prefix},"
    PREFIX="$last"
  else
    IPREFIX=""
    PREFIX="$cur"
  fi

  # Build GitLab query
  local query="users?state=active&per_page=100"

  # Only use &search= when fragment has 3+ chars
  if (( last_len >= 3 )); then
    query="${query}&search=${last}"
  fi

  # Fetch usernames
  local -a users
  users=("${(@f)$(glab api "$query" 2>/dev/null | jq -r '.[].username')}")

  # If 1–2 chars, filter locally on the full list
  if (( last_len > 0 && last_len < 3 )); then
    local -a filtered
    local u
    for u in "${users[@]}"; do
      # substring match; change to == ${last}* for prefix-only
      [[ $u == *${last}* ]] && filtered+="$u"
    done
    users=("${filtered[@]}")
  fi

  # Now just offer the usernames; zsh will prepend $IPREFIX automatically
  compadd -Q -- "${users[@]}"
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
