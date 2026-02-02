# NVM lazy loading (speeds up shell startup significantly)
export NVM_DIR="$HOME/.nvm"
nvm() {
  unset -f nvm node npm npx
  [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
  nvm "$@"
}
node() { nvm; unset -f node; node "$@"; }
npm() { nvm; unset -f npm; npm "$@"; }
npx() { nvm; unset -f npx; npx "$@"; }
