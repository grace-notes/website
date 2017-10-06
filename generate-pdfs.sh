export SHELL=$( type -p bash )
export DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"


convert() {
  source=$1
  dest=$( echo $source | sed 's@^\(.*\)/contents/\(.*\).md$@\1/build/\2.pdf@' )
  
  cd $( dirname $source )

  mkdir -p $( dirname $dest )

  pandoc \
     --from=markdown \
     --standalone \
     --latex-engine=xelatex \
     --smart \
     --output=$dest \
     --data-dir=${DIR}/pandoc \
     $source

  dest=$( echo $dest | sed 's@.pdf$@.epub@' )

  pandoc \
     --from=markdown \
     --standalone \
     --latex-engine=xelatex \
     --smart \
     --output=$dest \
     --data-dir=${DIR}/pandoc \
     $source

  return $?
}

export -f convert

FILES=$( find ${DIR}/contents/topics -name "*.md" | sort )

COUNT=$( echo "$FILES" | wc -l )

echo Converting $COUNT files to pdf and epub.

# echo "$FILES" | pv -p -s $COUNT | xargs -n 1 -P 8 -I {} bash -c 'convert {}'

parallel --no-notice --jobs 12 --bar convert ::: "$FILES"
