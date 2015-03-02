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

EXPOSE 80

# VOLUMES_FROM
CMD nginx & wintersmith build -v -c config.nopdf.json -o /srv/www/ && wintersmith build -v -o /srv/www
