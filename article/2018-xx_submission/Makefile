#!/usr/bin/make -f

NAME = gsaponaro-tcds2018language

# latexdiff
OPTIONS = --flatten
OLDTEX = ../2017-11_submission/gsaponaro-tcds2017language.tex
NEWTEX = ${NAME}.tex
DIFFNAME = gsaponaro-diff

pdf:
	pdflatex $(NAME) # --shell-escape option needed by epstopdf
	biber $(NAME)
	pdflatex $(NAME)
	pdflatex $(NAME)
	pdflatex $(NAME)

clean:
	rm -f *.aux *.bbl *.bcf *.blg *.brf *.dvi *.log *.out ${NAME}.pdf *.run.xml

diff:
	latexdiff $(OPTIONS) $(OLDTEX) $(NEWTEX) > $(DIFFNAME).tex
	pdflatex $(DIFFNAME)
	biber $(DIFFNAME)
	pdflatex $(DIFFNAME)
	pdflatex $(DIFFNAME)
	pdflatex $(DIFFNAME)

diffclean:
	rm -f $(DIFFNAME).*
