#!/bin/bash
alias gs="git status"

alias gc="git commit"

unalias gcm 2>/dev/null
alias gcm="git commit -m"

alias gps="git push"

alias gpl="git pull"

unalias ga 2>/dev/null
alias ga="git add"

alias gch="git checkout"

function gas() {
    git add --all 
    git status
}

alias det="docker exec -it"

function gchtime() {
    git commit --amend --no-edit --date=${VARIABLE:-"now"}
}

unalias gbd 2>/dev/null
function gbd() {
    git branch --merged >/tmp/merged-branches && vim /tmp/merged-branches && xargs git branch -d </tmp/merged-branches
}

function grlcs() {
    git reset --soft HEAD^
    git restore -S .
}

alias grlc="git reset --soft HEAD^"

function python() {
    python3 $1 $2 $3 $4 $5 $6 $7 $8 $9
}

function pip() {
    pip3 $1 $2 $3 $4 $5 $6 $7 $8 $9
}

function vim() {
  nvim  $1 $2 $3 $4 $5 $6 $7 $8 $9
}

function v() {
  nvim  $1 $2 $3 $4 $5 $6 $7 $8 $9
}

function dcu() {
  od
  docker-compose up --build $1 $2 $3 $4 $5 $6 $7 $8 $9 
}

function dcud () {
  od
  docker-compose up -d --build $1 $2 $3 $4 $5 $6 $7 $8 $9 
}

function od() {
  PROCESS=docker
  number=$(ps aux | grep -v grep | grep -ci $PROCESS)

  if [ $number -lt 2 ]
  then
    open --background /Applications/Docker.app
    echo "Openning Docker..."
    while [ $(ps aux | grep -v grep | grep -ci $PROCESS) -lt 2 ]
    do
      sleep 1
    done
    sleep 3
  fi
}

function rutvrm () {
  docker-compose exec -T mysql mysql --host=mysql --password=deadbeef --database=vrm_testing < tests/resources/db/schema.sql
  docker-compose exec -T mysql mysql --host=mysql --password=deadbeef --database=vrm_testing < tests/resources/db/seed.sql
}

alias yas="yarn serve"

alias yai="yarn install"

function kfpa() {
  kubectl port-forward -n acceptance svc/victron-mysql-master 3306:3306
}


function kfp() {
  #!/bin/bash
  function pause(){
    echo "$*"
    read
  }

  kubectl port-forward --namespace production svc/mysql-shared 3307:3306 &
  kubectl port-forward --namespace acceptance svc/mysql-shared 3308:3306 &
  kubectl port-forward --namespace dev svc/mysql-shared 3309:3306 &
  sleep 2
  pause 'Press [Enter] key to stop the port forwards...'
  pkill -9 kubectl
}

function cmpl() {
  file=$1
  result=${file%%.*}
  gcc -ggdb -o $result $file
}

function cmple() {
  file=$1
  result=${file%%.*}
  gcc -ggdb -o $result $file
  ./$result
}

function ccd() {
  pwd | pbcopy
}

alias tat="tmux attach -t"

alias t="tmux"

alias tls="tmux ls"

function ip() {
  dig +short myip.opendns.com @resolver1.opendns.com
}

private function get_ip_sha1_hash() {
  if [[ -z $1 ]];
  then
    echo "Include string"
  else
    input_string=$1;
  fi;


  hash=$(echo -n "$input_string" | shasum -a 1 | awk '{print $1}')

  echo $hash
}

function delratelimit() {
  ssh vrm "redis-cli -n 5 KEYS ratelimit_$(get_ip_sha1_hash $(ip))_* | xargs redis-cli -n 5 DEL" && ssh vrm "redis-cli -n 4 KEYS ratelimit_$(get_ip_sha1_hash $(ip))_* | xargs redis-cli -n 4 DEL"
}

function gollum() {
  /opt/homebrew/lib/ruby/gems/3.2.0/bin/gollum
}

function dbar() {
  od
  name=$1
  docker build -t name .
  docker run $1
}


function cmr() {
  if [[ "$*" == "--draft" ]]
  then
    draft="--draft"
  else
    draft=""
  fi

  if [[ $1 =~ .*",".* ]]; then 
    reviewers=$1;
  else
    echo "Needs at least two reviewers, only assigned"
    return
  fi;

  current_branch=$(git branch --show-current)
  if [[ $current_branch == "master" ]] || [[  $current_branch == "beta" ]] || [[ $current_branch == "acceptance" ]] || [[ $current_branch == "main" ]] || [[ $current_branch == "release" ]] ;
    then echo "Checkout a feature branch" && return;
  fi;

    # Check if 'main' branch exists in the remote repository
  current_project=$(basename $(pwd))

  if [[ ! -z $2 ]]; then
    target_branch=$2
  elif [[ $current_project =~ "vrm-(front|api)" ]]; then
    target_branch="release"
  else
    target_branch="master"
  fi

  glab mr create -a oliver --reviewer=$reviewers --target-branch=$target_branch -t "Merge branch: '$(git branch --show-current)' into $target_branch" $draft
}


function branchname() {
  if [[ -z $1 ]];
  then
    echo "No issue number supplied"
  fi;
  project=$(basename $(pwd))
  issue_project=$(echo $project | sed 's/api/front/')
  id=$1
  if [[ -z $2 ]];
  then
    >&2 echo "No branch supplied, using issue title"
    url="https://gitlab.elnino.tech/elnino/snooze/$issue_project/-/issues/$id"
    title=$(glab issue view $url);
    title=$(echo $title | sed -n '1 p' | sed 's/title://' | sed 's/^[[:space:]] *//g' | sed -e 's/ /-/g' | sed -e 's/\[//g' | sed -e 's/\]//g' )
  fi;

  if [[ ! -z $2 ]];
  then 
    branchname="$2"
  else
    branchname="$issue_project#$id-$title"
  fi;
  echo $branchname
}


function gbi() {
  current_branch=$(git branch --show-current)
  if [[ $current_branch != "master" ]];
    then echo "Checkout master" && return;
  fi;
  if [[ -z $1 ]];
  then
    echo "No issue number supplied"
    return 1
  fi;

  newbranch=$(branchname $1 $2)
  git switch -c $newbranch
}


unalias gl 2>/dev/null
alias gl="glab"

alias glci="glab ci view"

# get snippets from elnino gitlab
function gitlab_snippets() {
    SPACES=$(printf '%*s' 50)
    if [ -z ${GITLAB_TOKEN+x} ]; then
        echo "GITLAB_TOKEN is not set."; 
    else
        if [ -n "$1" ]; then
            update_snippet $1;
            return;
        fi
        SNIPPETS=$(curl --silent --header "PRIVATE-TOKEN: ${GITLAB_TOKEN}" \
            --url "https://gitlab.elnino.tech/api/v4/snippets")


        echo " -------------------------------------------------- "
        echo "| ID:     | Snippet name                           |"
        echo "|---------|----------------------------------------|"
        echo "$SNIPPETS" | tr -d '\n' | jq -r --arg spaces "$SPACES" '.[] |
                                  [("| " + (.id | tostring) + "       ")[0:9], .title] |
                                  join(" | ") |
                                  if length > 50 then .[0:47] + "..." else . + $spaces end |
                                  .[0:50] + " |"
                                  '
        echo " -------------------------------------------------- "
    fi
}

function update_snippet() {
    if [ -z "$1" ]; then
        echo "Error: Missing snippet id";
    else
        # URL="https://gitlab.elnino.tech/api/v4/snippets/$1/raw"
        URL="https://gitlab.elnino.tech/api/v4/snippets/$1"
        # echo $URL
        INFO=$(curl --silent --header "PRIVATE-TOKEN: ${GITLAB_TOKEN}" \
            --url $URL)

        FILENAME=$(jq -r '.file_name' <<< $INFO)
        FILEPATH="/tmp/$FILENAME"

        curl --silent --header "PRIVATE-TOKEN: ${GITLAB_TOKEN}" \
            --url "${URL}/raw" > $FILEPATH

        TITLE=$(jq -r '.title' <<< $INFO)
        DESC=$(jq -r '.description' <<< $INFO)
        VISIBILITY=$(jq -r '.visibility' <<< $INFO)
        nvim $FILEPATH
        CONTENT=$(cat $FILEPATH)
        JSON=$(jq -cn --arg content "$CONTENT" --arg title "$TITLE" --arg desc "$DESC" --arg filename "$FILENAME" --arg visibility "$VISIBILITY" '{title: $title, action: "update", file_name: $filename, visibility: $visibility, description: $desc, content: $content}')
        response_code=$(curl -s -o /dev/null --request PUT $URL -w "%{http_code}" \
         --header 'Content-Type: application/json' \
         --header "PRIVATE-TOKEN: ${GITLAB_TOKEN}" \
         --data "$JSON")
        if [ "$response_code" != "200" ]; then
            echo "Error: Something went wrong, response code $response_code. Your changes have been saved to '$FILENAME'"
            cp $FILEPATH $FILENAME
        fi
    fi

}

alias gls="gitlab_snippets"


function learning_time() {
  # ANSI color codes
  RED='\033[0;31m'
  GREEN='\033[0;32m'
  CYAN='\033[0;36m'
  NC='\033[0m' # No Color

  USER_ID=300883
  LEARNING_ID=21758966
  INFO=$(curl --silent -u $PAYMO_TOKEN:f \
    -H 'Accept: application/json' \
    --url "https://app.paymoapp.com/api/entries?where=user_id=$USER_ID")
  LEARNING_TIME=$(jq "[.entries[] | select(.task_id==$LEARNING_ID) | .duration] | add" <<< "$INFO")
  TOTAL_TIME=$(jq "[.entries[] | .duration] | add" <<< "$INFO")
  # check if user added a parameter
  # if so, use it as total time in hours
  if [ -n "$1" ]; then
    TOTAL_TIME=$(echo "scale=2; $1 * 3600" | bc)
  fi
  PERCENTAGE_LEARNING=$(echo "scale=2; 100 * $LEARNING_TIME / $TOTAL_TIME" | bc)
  LEARNING_TIME=$(echo "scale=2; $LEARNING_TIME / 3600" | bc)
  TOTAL_TIME=$(echo "scale=2; $TOTAL_TIME / 3600" | bc)
  TOTAL_LEARNING_TIME=$(echo "scale=2; $TOTAL_TIME * 0.1" | bc)
  LEARNING_DIFF=$(echo "scale=2; $TOTAL_LEARNING_TIME - $LEARNING_TIME" | bc)

  echo -e "Total time spent: ${CYAN}$TOTAL_TIME hours${NC}"
  echo -e "Total learning time should be: ${CYAN}$TOTAL_LEARNING_TIME hours${NC}"
  echo -e "Total learning time spent: ${CYAN}$LEARNING_TIME hours${NC}"
  if (( $(echo "$PERCENTAGE_LEARNING > 10" | bc -l) )); then
    echo -e "Percentage of time spent learning: ${RED}${PERCENTAGE_LEARNING}%${NC}"
  else
    echo -e "Percentage of time spent learning: ${GREEN}${PERCENTAGE_LEARNING}%${NC}"
  fi
  
  if (( $(echo "$LEARNING_DIFF > 0" | bc -l) )); then
    echo -e "Total learning time missing: ${GREEN}$LEARNING_DIFF hours${NC}"
  else
    echo -e "Total extra learning time: ${RED}${LEARNING_DIFF#-} hours${NC}"
  fi
}
