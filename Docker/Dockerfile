# boot2docker init
# boot2docker up
# docker build -t jamilevans/ubuntu-node-ocr .
# docker run -p 49160:8080 --privileged -d jamilevans/ubuntu-node-ocr

FROM	ubuntu
RUN	apt-get update && apt-get install -y ghostscript imagemagick enscript curl tesseract-ocr dos2unix
RUN     curl -sL https://deb.nodesource.com/setup | bash -
RUN	apt-get install -y nodejs
COPY	src/ /tmp
RUN	cd /tmp; npm install
# RUN chmod 777 /src
EXPOSE	8080
CMD	["node", "/tmp/index.js"]
