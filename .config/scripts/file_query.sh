#!/bin/zsh

ARG=$1

ROOT=~blog/content
cd ~blog/content
FILES=($(find . -name '*.md' | fzf --filter=''$ARG''))

ITEMS='{"items": ['
FIRST='1'
for f in $FILES
do
  if [[ "$FIRST" == "0" ]] then
    ITEMS="$ITEMS,"
  fi
  f=$(echo "$f" | sed 's/^.\///g')
  TITLE=$(echo "$f" | sed 's/index\.md//g')

  # see https://www.alfredapp.com/help/workflows/inputs/script-filter/json/
  ITEM=$(echo '{
        "type": "file",
        "title": "'$TITLE'",
        "arg": "'$ROOT'/'$f'",
        "autocomplete": "'$f'"
      }')
  ITEMS="${ITEMS} ${ITEM}"
  FIRST="0"
done
ITEMS="${ITEMS} ]}"

echo $ITEMS
