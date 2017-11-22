FROM ubuntu:16.04

# Update the system
RUN apt-get update
RUN apt-get dist-upgrade -y

# Install the necessary packages.
RUN apt-get install apache2 php7.0 libapache2-mod-php7.0  -y

# Enable the php mod we just installed
RUN a2enmod php7.0

# expose port 80 and 443 (ssl) for the web requests
EXPOSE 80


###### Update the php INI settings #########

# Remove any possible memory limit.
RUN sed -i 's;memory_limit = .*;memory_limit = -1;' /etc/php/7.0/apache2/php.ini

# Display errors if there are any
RUN sed -i 's;display_errors = .*;display_errors = On;' /etc/php/7.0/apache2/php.ini


####### END of updating php INI ########
########################################

# Manually set the apache environment variables in order to get apache to work immediately.
ENV APACHE_RUN_USER www-data
ENV APACHE_RUN_GROUP www-data
ENV APACHE_LOG_DIR /var/log/apache2

# It appears that the new apache requires these env vars as well
ENV APACHE_LOCK_DIR /var/lock/apache2
ENV APACHE_PID_FILE /var/run/apache2/apache2.pid

# Set up url rewrite ability
RUN a2enmod rewrite

# Install the cron service
RUN apt-get install cron -y


# Add our websites files to the default apache directory (/var/www)
ADD project /var/www/my-site/project
ADD apache/.htaccess /var/www/my-site/project/.
ADD apache/startup.sh /root/startup.sh

# Update our apache sites available with the config we created
ADD apache/apache-config.conf /etc/apache2/sites-enabled/000-default.conf

# Make the uploads folder writeable
RUN chown root:www-data -R /var/www
RUN chmod 750 -R /var/www/my-site

# Execute the containers startup script which will start many processes/services
# The startup file was already added when we added "project"
CMD ["/bin/bash", "/root/startup.sh"]
