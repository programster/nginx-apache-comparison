# Please do not manually call this file!
# This script is run by the docker container when it is "run"

# Set permissions (just in case using volumes).
chown root:www-data -R /var/www
chmod 750 -R /var/www/my-site

# Run the apache process in the background
/usr/sbin/apache2 -D APACHE_PROCESS &

service apache2 restart

DIR=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )

# Start the cron service in the foreground
# We dont run apache in the FG, so that we can restart apache without container
# exiting.
cron -f
