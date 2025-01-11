FROM drpsychick/texlive-pdflatex:latest

WORKDIR /usr/local/resume

RUN apk add --no-cache python3 py3-pip

CMD sh compile_resume.sh
