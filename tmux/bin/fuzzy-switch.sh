#!/usr/bin/env bash
die() {
  printf "\n[tmux-fuzzy] %s\n" "$1" >&2
  # keep popup visible if we're in a popup
  if [ -n "${TMUX:-}" ]; then
    printf "Press ENTER to close..."
    read -r _ || true
  fi
  exit 1
}

list_projects() {
  tmuxinator list 2>/dev/null \
    | sed '1{/tmuxinator projects:/d;}' \
    | tr -s '[:space:]' '\n' \
    | grep -E '^[[:alnum:]_.:-]+$' \
    || true
}

# unique + sorted
items="$(list_projects | sort -u)"
[ -n "$items" ] || die "No tmuxinator projects found."

sel="$(
  printf '%s\n' "$items" | fzf \
    --prompt='Project > ' \
    --height=100% --layout=reverse \
    --print-query --expect=enter \
    --bind 'tab:down,btab:up'  \
    --cycle
)" || exit 0

key="$(printf '%s\n' "$sel" | sed -n '1p')"
query="$(printf '%s\n' "$sel" | sed -n '2p' | sed 's/^[[:space:]]*//;s/[[:space:]]*$//')"
choice="$(printf '%s\n' "$sel" | sed -n '3p')"

project="${choice:-$query}"
[ -n "$project" ] || exit 0

if [ "$project" = "vrm-deploy" ] && tmux has-session -t vrm-deploy 2>/dev/null; then
  current_session=$(tmux display-message -p '#S' 2>/dev/null)
  if [ "$current_session" = "vrm-deploy" ]; then
    tmux rename-session -t vrm-deploy vrm-deploy-old
    tmuxinator start vrm-deploy
    tmux kill-session -t vrm-deploy-old 2>/dev/null
    exit 0
  else
    tmux kill-session -t vrm-deploy 2>/dev/null
  fi
fi

tmuxinator start "$project"
exit 0

