#!/bin/sh

cd src
python3 generate_resume.py
pdflatex resume.tex

if [ ! -d "../out" ]; then
    mkdir ../out
fi

mv *.pdf *.aux *.log *.out *.tex ../out

cd ..

cp ./out/resume.pdf ./$OUT_NAME.pdf