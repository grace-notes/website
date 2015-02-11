FROM octohost/wintersmith-nginx

RUN apt-get update

WORKDIR /srv/www

ADD . /srv/www/

RUN apt-get install -y pandoc
RUN npm install

RUN apt-get install -y rubygems
RUN gem install sass

RUN wintersmith build

EXPOSE 80

CMD nginx

