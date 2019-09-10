# Makefile to build Internet Drafts from markdown using mmarc

DRAFT = draft-kinamdar-dispatch-sip-auto-peer
VERSION = 00

all: $(DRAFT)-$(VERSION).txt $(DRAFT)-$(VERSION).html 

diff: $(DRAFT).diff.html

clean:
	-rm -f $(DRAFT)-$(VERSION).{txt,html,xml,pdf} $(DRAFT).diff.html  model.md

.PHONY: all clean diff

.PRECIOUS: %.xml

model.md: model.yang
	echo "~~~" > model.md
	cat model.yang >> model.md
	echo "~~~"  >> model.md

%.html: %.xml
	xml2rfc --html $^ -o $@

%.txt: %.xml
	xml2rfc --text $^ -o $@

$(DRAFT)-$(VERSION).xml: $(DRAFT).md  model.md 
	mmark -xml2 -page $(DRAFT).md $@

$(DRAFT).diff.html: $(DRAFT)-$(VERSION).txt $(DRAFT)-old.txt 
	htmlwdiff   $(DRAFT)-old.txt   $(DRAFT)-$(VERSION).txt >   $(DRAFT).diff.html

