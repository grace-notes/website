FROM octohost/wintersmith-nginx

RUN apt-get update

RUN apt-get install -y pandoc texlive-xetex texlive-fonts-recommended texlive-latex-extra texlive-fonts-extra

RUN apt-get install -y rubygems
RUN gem install sass

WORKDIR /srv/www

ADD . /srv/www/

RUN cp -r /srv/www/pandoc ~/.pandoc
RUN /srv/www/build-pdf.sh
RUN npm install
RUN wintersmith build

EXPOSE 80

CMD nginx

