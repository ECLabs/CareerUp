#!/bin/bash

# Title: CareerUp OCR Exporter
# Author: Jamil Evans, Evans & Chambers Technology 11/16/2014
# This script takes a PDF filename as input parameter (do not provide file extension), 
# conducts OCR on it and outputs a text searchable PDF to the filesystem.  
# Note: This script expects that the script and the source files are in the current 
# directory.  The output file is formatted as [input file prefix].final.pdf

SOURCE_PDF=$1.pdf 
PREFIX=$1
CWD=$2 # current working directory

cd $CWD

echo '########## Processing' $SOURCE_PDF ' ##############'
echo "Your command line contains $# arguments"
echo "First argument is ($1)"
echo "Second argument is ($2)"

cd $CWD

# Use ImageMagick to convert to high resolution, reduce blur, and make monochrome 
# Also split into separate PNG files
convert -density 600 -blur 1x2 -monochrome $SOURCE_PDF $PREFIX%d.png

# Run Tesseract OCR on each png page. Exports as *.txt files
for i in $PREFIX*.png ; do tesseract $i $PREFIX+$i;  done;

# Merge all *.txt files
cat $PREFIX*.txt > $PREFIX.joined.txt

# Convert text file into PostScript file 
enscript -p $PREFIX.joined.ps $PREFIX.joined.txt

# Use ghostscript to merge the text file with the original pdf.  Results
# in a text-searchable PDF.  Tried ImageMagick for this but the result
# was not text searchable.
gs -sDEVICE=pdfwrite -dNOPAUSE -dBATCH -dSAFER -sOutputFile=$PREFIX.final.pdf $PREFIX.joined.ps $SOURCE_PDF

# cleanup temporary files (disabling to handle multiple threads)
# rm *.txt *.ps *.png
