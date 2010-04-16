# $Id$

zip: clean program.pdf 2010symposium.pdf
	-mkdir -p 2010
	sed -e 's/\(href="\)http:\/\/wwwsoc.nii.ac.jp\/jsik\//\1..\/..\//g' index.html > ./2010/index.html
	sed -e 's/\(href="\)http:\/\/wwwsoc.nii.ac.jp\/jsik\//\1..\/..\//g' 2010symposium.html > ./2010/2010symposium.html
	cp -p program.pdf ./2010/2010program.pdf
	cp -p 2010symposium.pdf default.css ./2010/
	zip -9r jsik2010.zip ./2010/

program.pdf:	program.tex
	platex program
	dvipdfmx program

2010symposium.pdf:	2010symposium.tex
	platex 2010symposium
	dvipdfmx 2010symposium
clean:
	-rm -rf 2010 jsik2010.zip
