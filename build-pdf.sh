#!/bin/bash

SRC_DIR=$1
BUILD_DIR=$2

cd $SRC_DIR/contents/topics
for TOPIC in *.md
do
  PDF="$BUILD_DIR/topics/$(basename $TOPIC | sed 's/\.md$/.pdf/')"
  echo "Creating $PDF from $TOPIC..."
  pandoc --smart -s $TOPIC --latex-engine=xelatex -o $PDF
done
