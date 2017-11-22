FROM ubuntu:16.04

# Update the system
RUN apt-get update
RUN apt-get dist-upgrade -y

# Install the necessary packages.
RUN apt-get install nginx php-fpm vim php7.0 \
php7.0-cli php7.0-mysql php7.0-curl php7.0-mcrypt php7.0-mbstring \
php7.0-bcmath libxslt1.1 php-xml php7.0-xml -y

# increase security by configuring php-fpm to only execute exact matches for files, 
# rather than executing the closest matching file.
ENV SEARCH=";cgi.fix_pathinfo=.*"
ENV REPLACE="cgi.fix_pathinfo=1"
ENV FILEPATH="/etc/php/7.0/fpm/php.ini"
RUN sed -i "s|$SEARCH|$REPLACE|" $FILEPATH


# expose port 80 for web requests.
EXPOSE 80



####### END of updating php INI ########
########################################


# Install the cron service (will be our containers fg process)
RUN apt-get install cron -y


# Add our websites files to the default apache directory (/var/www)
ADD project /var/www/my-site/project

# Add the startup script to the container.
ADD nginx/startup.sh /root/startup.sh

# Replace the nginx base configuration file (set default settings etc).
ADD nginx/nginx.conf /etc/nginx/nginx.conf

# Update our nginx sites available with the config we created
ADD nginx/nginx-site-config.conf /etc/nginx/sites-available/default

# Replace the php-fpm pool config so that we listen on TCP port 9000 instead of using a local
# unix socket. Also set dynamic or static pool with number or processes.
# https://serverfault.com/questions/884468/nginx-with-php-fpm-resource-temporarily-unavailable-502-error/884477#884477
ADD nginx/php-fpm-pool.conf /etc/php/7.0/fpm/pool.d/www.conf

# Make the uploads folder writeable
RUN chown root:www-data -R /var/www
RUN chmod 750 -R /var/www/my-site

# Execute the containers startup script which will start many processes/services
# The startup file was already added when we added "project"
CMD ["/bin/bash", "/root/startup.sh"]
