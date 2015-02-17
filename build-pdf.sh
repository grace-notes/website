#!/bin/bash

cd contents/topics
for TOPIC in *.md
do
  PDF="../../build/topics/$(basename $TOPIC | sed 's/\.md$/.pdf/')"
  if [ ! -f $PDF ]; then
    echo "Creating pdf from $TOPIC..."
    pandoc -s $TOPIC --latex-engine=xelatex -o $PDF
  fi
done
