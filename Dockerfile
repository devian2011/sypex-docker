FROM centos:7
MAINTAINER Ilya Romanov <romanov.i.u@yandex.ru>
#Install php
RUN rpm -Uvh https://dl.fedoraproject.org/pub/epel/epel-release-latest-7.noarch.rpm
RUN rpm -Uvh https://centos7.iuscommunity.org/ius-release.rpm
RUN yum -y install php70u-cli php70u-json php70u-pear php70u-xml php70u-xmlrpc php70u-common php70u-intl php70u-mbstring php70u-mcrypt
RUN yum -y install git wget unzip
#Create application dir
RUN mkdir app
WORKDIR /app
#Download composer
RUN php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');"
RUN php -r "if (hash_file('SHA384', 'composer-setup.php') === '669656bab3166a7aff8a7506b8cb2d1c292f042046c5a994c43155c0be6190fa0355160742ab2e1c88d40d5be660b410') { echo 'Installer verified'; } else { echo 'Installer corrupt'; unlink('composer-setup.php'); } echo PHP_EOL;"
RUN php composer-setup.php
RUN php -r "unlink('composer-setup.php');"
RUN mv composer.phar /usr/bin/composer
RUN chmod +x /usr/bin/composer
#Get code
RUN git clone https://github.com/devian2011/sypex-geo-daemon.git ./
#Get db
RUN wget https://sypexgeo.net/files/SxGeoCity_utf8.zip
RUN unzip SxGeoCity_utf8.zip
RUN composer install

EXPOSE 80

CMD ["php", "/app/server.php", "--host=0.0.0.0", "--port=80"]
