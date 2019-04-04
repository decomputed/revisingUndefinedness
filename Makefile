# xelatex ./tese.tex; bibtex tese; xelatex ./tese.tex;xelatex ./tese.tex;
.PHONY: clean

CC = docker run --rm -v `pwd`:/sources decomputed/docker-latex:latest xelatex
RESUME_DIR = resume
RESUME_SRCS = $(shell find $(RESUME_DIR) -name '*.tex')

tese.pdf: tese.tex $(RESUME_SRCS)
	$(CC) $<

clean:
	@rm -rf presentation.*
	@rm -rf *.mtc*
	@rm -rf tese.log tese.maf tese.aux tese.pdf tese.toc tese.bbl tese.blg
	@rm -rf Chap?/*.aux
	@rm -rf *.backup
	@rm -rf *.pdf
	@rm -rf *.log
	@rm -rf *.out
	@rm -rf *.aux



