# $Id$

zip: clean
	-mkdir -p 2010
	sed -e 's/\(href="\)http:\/\/wwwsoc.nii.ac.jp\/jsik\//\1..\/..\//g' index.html > ./2010/index.html
	cp -p 2010program.pdf default.css ./2010/
	zip -9r jsik2010.zip ./2010/

clean:
	-rm -rf 2010 jsik2010.zip
