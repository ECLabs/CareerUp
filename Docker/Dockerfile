FROM	ubuntu
RUN	apt-get update && apt-get install -y ghostscript imagemagick enscript curl tesseract-ocr
RUN     curl -sL https://deb.nodesource.com/setup | bash -
RUN	apt-get install -y nodejs
COPY	src/ /src
RUN	cd /src; npm install
EXPOSE	8080
CMD	["node", "/src/index.js"]
