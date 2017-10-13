#!/usr/bin/make -f

NAME = gsaponaro-tcds2017language

# we could add running make in figures/ I have not done it yet because I don't know if you
# have the required tools installed. Giampiero

pdf:
	pdflatex $(NAME) # --shell-escape option needed by epstopdf
	biber $(NAME)
	pdflatex $(NAME)
	pdflatex $(NAME)
	pdflatex $(NAME)

clean:
	rm -f *.aux *.bbl *.bcf *.blg *.brf *.dvi *.log *.out *.pdf *.run.xml
