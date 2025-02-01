#!/bin/bash

# cmark-gfm can be found at https://github.com/github/cmark-gfm
# visit https://www.gnu.org/software/bash/manual/bash.html#Shell-Parameter-Expansion
# to understand how .md file extension is replaced by .html

export STYLES=$(sass -s compressed --no-source-map  _layout.scss)

for f in *.md
do
  export TITLE=$(grep -m 1 '# ' $f)       # find first header in markdown
  TITLE=${TITLE#"# "}                     # remove prefix
  export MARKDOWN=$(cmark-gfm -e table --unsafe $f)
  envsubst '$TITLE,$STYLES,$MARKDOWN' < _layout.template > "${f%.md}.html"
  echo "$f processed"
done

