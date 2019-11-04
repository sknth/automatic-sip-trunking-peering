# Makefile to build Internet Drafts from markdown using mmarc

DRAFT = draft-kinamdar-dispatch-sip-auto-peer
VERSION = 01

all: $(DRAFT)-$(VERSION).txt $(DRAFT)-$(VERSION).html 

diff: $(DRAFT).diff.html

clean:
	-rm -f $(DRAFT)-$(VERSION).{txt,html,xml,pdf} $(DRAFT).diff.html   ietf-sip-auto-peering.tree

.PHONY: all clean diff

.PRECIOUS: %.xml ietf-sip-auto-peering.tree

lint: ietf-sip-auto-peering.yang Makefile 
	pyang --ietf --max-line-length 69 ietf-sip-auto-peering.yang

ietf-sip-auto-peering.tree: ietf-sip-auto-peering.yang Makefile 
	- pyang -f tree ietf-sip-auto-peering.yang -o ietf-sip-auto-peering.tree

%.html: %.xml
	xml2rfc --html $^ -o $@

%.txt: %.xml
	xml2rfc --text $^ -o $@

$(DRAFT)-$(VERSION).xml: $(DRAFT).md   ietf-sip-auto-peering.tree ietf-sip-auto-peering.yang
	mmark -xml2 -page $(DRAFT).md $@

$(DRAFT).diff.html: $(DRAFT)-$(VERSION).txt $(DRAFT)-old.txt 
	htmlwdiff   $(DRAFT)-old.txt   $(DRAFT)-$(VERSION).txt >   $(DRAFT).diff.html

