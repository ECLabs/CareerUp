#!/bin/bash

SOURCE_PDF=$1.pdf
PREFIX=$1

convert $SOURCE_PDF $PREFIX%d.png
for i in $PREFIX*.png ; do tesseract $i $PREFIX+$i;  done;
cat $PREFIX*.txt > $PREFIX.joined.txt
enscript -p $PREFIX.joined.ps $PREFIX.joined.txt
gs -sDEVICE=pdfwrite -dNOPAUSE -dBATCH -dSAFER -sOutputFile=$PREFIX.final.pdf $PREFIX.joined.ps $SOURCE_PDF
rm *.txt *.ps *.png
