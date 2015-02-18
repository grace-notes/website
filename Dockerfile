FROM octohost/nodejs

RUN DEBIAN_FRONTEND=noninteractive apt-get update
RUN DEBIAN_FRONTEND=noninteractive apt-get -y install software-properties-common

RUN DEBIAN_FRONTEND=noninteractive apt-get -y install pandoc
RUN DEBIAN_FRONTEND=noninteractive apt-get -y install texlive-xetex 
RUN DEBIAN_FRONTEND=noninteractive apt-get -y install texlive-fonts-recommended
RUN DEBIAN_FRONTEND=noninteractive apt-get -y install texlive-latex-extra

RUN DEBIAN_FRONTEND=noninteractive apt-get -y install ruby
RUN gem install sass

RUN DEBIAN_FRONTEND=noninteractive add-apt-repository -y ppa:nginx/stable
RUN DEBIAN_FRONTEND=noninteractive apt-get update
RUN DEBIAN_FRONTEND=noninteractive apt-get -y install nginx

RUN npm install wintersmith -g

RUN mkdir /app
WORKDIR /app

ADD deploy/default /etc/nginx/sites-available/default
ADD deploy/nginx.conf /etc/nginx/nginx.conf

ADD . /app

RUN npm install

RUN cp -r pandoc ~/.pandoc

EXPOSE 80

# VOLUMES_FROM
CMD wintersmith build -o /srv/www && /app/build-pdf.sh /app /srv/www & nginx
