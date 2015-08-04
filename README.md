nginx-docker
============
Based on official nginx Docker image and h5bp, with templating and custom intialization script support.

Rationale
---------
I wanted an [nginx](http://nginx.org/) image that met the following criteria:
* Extends the [official nginx image](https://github.com/nginxinc/docker-nginx).
* Supports a configuration file template that is evaluated from environment variables, as described in [this blog post](http://blog.tryolabs.com/2015/03/26/configurable-docker-containers-for-multiple-environments/).
* Its base configuration stems from best practices outlined in [h5bp](https://github.com/h5bp/server-configs-nginx).
* Can run arbitrary scripts at startup easily.

Thus, **nginx-docker** was born.
