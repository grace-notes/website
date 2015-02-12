FROM octohost/wintersmith-nginx

RUN apt-get update

RUN apt-get install -y pandoc
RUN npm install

RUN apt-get install -y rubygems
RUN gem install sass

WORKDIR /srv/www

ADD . /srv/www/

RUN wintersmith build

EXPOSE 80

CMD nginx

