# autocomplete

: ${CMR_USER_CACHE:="$HOME/.cache/cmr_users"}

cmr_update_users() {
  local cache="$CMR_USER_CACHE"
  local dir="${cache:h}"   # directory part

  mkdir -p -- "$dir"

  echo "Updating cmr user cache in $cache..." >&2

  # Fetch ALL active users (using --paginate for multiple pages)
  glab api "users?state=active&per_page=100" --paginate \
    | jq -r '.[].username' \
    | sort -u > "$cache"

  local count
  count=$(wc -l < "$cache" | tr -d ' ')
  echo "Stored $count usernames in $cache" >&2
}


_cmr() {
  emulate -L zsh
  setopt extended_glob

  local -a opts
  opts=('--draft')

  # Option completion
  if [[ $words[CURRENT] == -* ]]; then
    _describe 'options' opts
    return
  fi

  # Cache path
  : ${CMR_USER_CACHE:="$HOME/.cache/cmr_users"}

  # If cache missing → auto-update once
  if [[ ! -r "$CMR_USER_CACHE" ]]; then
    # Show a short message only once per shell session
    print -r -- "cmr: user cache missing, updating..." >&2
    cmr_update_users
  fi

  # Load cached users
  local -a users
  users=("${(@f)$(< "$CMR_USER_CACHE")}")

  # Full current "word" at cursor
  local cur=$words[CURRENT]

  # Split into prefix (before last comma) + fragment after last comma
  local prefix last
  prefix="${cur%,*}"
  last="${cur##*,}"

  # Tell zsh what is fixed vs typed fragment
  if [[ "$prefix" != "$cur" ]]; then
    IPREFIX="${prefix},"
    PREFIX="$last"
  else
    IPREFIX=""
    PREFIX="$cur"
  fi

  # Substring filter locally
  if [[ -n "$last" ]]; then
    local -a filtered
    local u
    for u in "${users[@]}"; do
      [[ $u == *${last}* ]] && filtered+="$u"
    done
    users=("${filtered[@]}")
  fi

  (( ${#users} == 0 )) && return 0

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
