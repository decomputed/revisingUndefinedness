#!/bin/sh

clean:
	rm -rf presentation.*
	rm -rf *.mtc*
	rm -rf tese.log tese.maf tese.aux tese.pdf tese.toc tese.bbl tese.blg
	rm -rf Chap?/*.aux
	rm -rf *.backup

pdf:
	pdflatex -interaction=nonstopmode tese.tex
	bibtex tese
	pdflatex -interaction=nonstopmode tese.tex
	pdflatex -interaction=nonstopmode tese.tex
