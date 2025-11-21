# autocomplete

# Where to cache usernames (override with $CMR_USER_CACHE if you want)
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

  # Complete options
  if [[ $words[CURRENT] == -* ]]; then
    _describe 'options' opts
    return
  fi

  # Load cached users
  : ${CMR_USER_CACHE:="$HOME/.cache/cmr_users"}
  local -a users
  if [[ -r "$CMR_USER_CACHE" ]]; then
    users=("${(@f)$(< "$CMR_USER_CACHE")}")
  else
    # No cache yet → nothing to complete
    return 0
  fi

  # Full current "word" (may contain commas)
  local cur=$words[CURRENT]

  # Split into prefix (before last comma) and fragment being typed (after last comma)
  local prefix last
  prefix="${cur%,*}"
  last="${cur##*,}"

  # Tell zsh what is fixed and what is being completed
  if [[ "$prefix" != "$cur" ]]; then
    IPREFIX="${prefix},"
    PREFIX="$last"
  else
    IPREFIX=""
    PREFIX="$cur"
  fi

  # Filter users by the fragment (substring match)
  if [[ -n "$last" ]]; then
    local -a filtered
    local u
    for u in "${users[@]}"; do
      [[ $u == *${last}* ]] && filtered+="$u"
    done
    users=("${filtered[@]}")
  fi

  (( ${#users} == 0 )) && return 0

  # Offer usernames; zsh will prefix with $IPREFIX
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
