#!/usr/bin/make -f

NAME = gsaponaro-tcds2017language

pdf:
	pdflatex $(NAME) # --shell-escape option needed by epstopdf
	biber $(NAME)
	pdflatex $(NAME)
	pdflatex $(NAME)
	pdflatex $(NAME)

clean:
	rm -f *.aux *.bbl *.bcf *.blg *.brf *.dvi *.log *.out *.pdf *.run.xml
