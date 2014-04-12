#!/bin/bash
name=`echo $1 | cut -f1 -d'.'`
pandoc $1 -o $name.pdf -t beamer --latex-engine=xelatex --template=/Users/garrickaden-buie/.pandoc/templates/usf_simple.beamer --highlight-style=zenburn --variable logo=/Users/garrickaden-buie/Repos/usf-boot-camp-R/INFORMS-logo-semitransparent.png
