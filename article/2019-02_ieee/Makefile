#!/usr/bin/make -f

NAME = gsaponaro-tcds2019

pdf:
	pdflatex $(NAME) # --shell-escape option needed by epstopdf
	biber $(NAME)
	pdflatex $(NAME)
	pdflatex $(NAME)
	pdflatex $(NAME)

clean:
	rm -f *.aux *.bbl *.bcf *.blg *.brf *.dvi *.log *.out ${NAME}.pdf *.run.xml
