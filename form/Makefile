# $Id$

RSYNC=$(HOME)/cvswork/public_html/rsync.pl

default:

# Rsync to http://etk.sakura.ne.jp/
rsync:
	$(RSYNC) etk:www/jsik2010/form/data/ ./data/

zip: clean
	-mkdir -p jsik/kenkyu/2009/
	sed -e 's/\(href="\)http:\/\/wwwsoc.nii.ac.jp\/jsik\//\1..\/..\//g' index.html > ./jsik/kenkyu/2009/index.html
	cp -p program.pdf style.css ./jsik/kenkyu/2009/
	cp -p kenkyu.html ./jsik/
	cp -p top.html ./jsik/index.html
	zip -9r jsik.zip ./jsik/
	-rm -rf ./jsik/

clean:
	-rm -rf jsik jsik.zip
