This tool is useful for testing the differences betwen Nginx and Apache by having the same PHP based website being served up by both webservers. I have been using this tool to demonstrate/test the handling of large bursts of incoming requests.

# Optimizing Nginx for your core count
The Nginx configuration has been optimized for a dual core server. If you want to test against a larger core count, then please adjust the nginx/php-fpm-pool.conf file so that `pm.max_children` is set to your number of cores x 2.

## Instructions
Clone the repository.
```
git clone https://github.com/programster/nginx-apache-comparison.git
```

Navigate to within the folder and build the images by executing the build script I created for you.
```
bash build.sh
```

When that has finished, deploy your nginx and apache webservers by executing the deploy script.
```
bash deploy.sh
```

Now you can [stress test the different webservers using the Apache Bench tool](http://blog.programster.org/stress-testing-apache-server). Remember that nginx responds on port `8080` and Apache responds on port `8000`.

E.g.

```
# Apache - burst of 100 requests
ab -n 100 -c 100 http://nginx-testing.programster.org:8000/

# Nginx - burst of 100 requests
ab -n 100 -c 100 http://nginx-testing.programster.org:8000/
```

It is also worth noting that after testing the Apache webserver, a lot of memory will be left over still being utilized so I re-deploy (by executing `bash deploy.sh`) before running the tests on Nginx.
