nginx-docker
============
Based on official nginx Docker image and h5bp, with templating and custom intialization script support.

Rationale
---------
I wanted an [nginx](http://nginx.org/) image that met the following criteria:

* Extends the [official nginx image](https://github.com/docker-library/docs/tree/master/nginx).
* Supports a configuration file template that is evaluated from environment variables, as described in [this blog post](http://blog.tryolabs.com/2015/03/26/configurable-docker-containers-for-multiple-environments/).
* Its base configuration stems from best practices outlined in [h5bp](https://github.com/h5bp/server-configs-nginx).
* Can run arbitrary scripts at startup easily.

Thus, **nginx-docker** was born.

How it works
------------
Nginx config files are generated from [Jinja2](http://jinja.pocoo.org/docs/dev/) templates. The values of the variables are resolved from the environment variables (ie. those used by Docker and those passed by `docker run`).

This is what happens when the container runs:

1. Whatever is in the `/templates` directory is copied to `/etc/nginx`.
2. All files of the form `<FILENAME>.j2` (the extension of Jinja2 templates) inside `/etc/nginx` are found (recursively) and evaluated, leaving them as `<FILENAME>`. For example, `/etc/nginx/sites-enabled/mysite.com.j2` would be stored as `/etc/nginx/sites-enabled/mysite.com`.
3. All `.sh` scripts present in `/docker-entrypoint-init.d` (if any) are executed.
4. Finally, nginx starts.

How to use this image
---------------------
Before you get started, make sure you understand how the [official nginx image](https://github.com/docker-library/docs/tree/master/nginx) works, since this one is an extension.

### Using docker run
You may run a container from this image with:

```
docker run --name some-nginx dekked/nginx-docker
```

If you are not providing custom template files, the default ones for *example.com* site (based on [h5bp](https://github.com/h5bp/server-configs-nginx)) are going to be used. See the [templates](https://github.com/dekked/nginx-docker/tree/master/templates) directory.

If you wish to run with your own templates or scripts, you can do so as follows:

```
docker run --name some-nginx -v "<YOUR_TEMPLATES_DIR>:/templates" -v "<YOUR_INIT_SCRIPTS_DIR>:/docker-entrypoint-init.d" dekked/nginx-docker
```

The default templates don't include any variables, but they can be easily added. For example, if your nginx site conf is like:

```
server {
  listen 80;
  server_name {{ NGINX_CONF_SERVER_NAME }};  # different on dev and prod

  # ...
}
```

Then you could run like `docker run --name some-nginx -v "<PATH>/your-site.j2:/templates/sites-enabled/yoursite.com.j2" -e "NGINX_CONF_SERVER_NAME=yoursite.com" -it dekked/nginx-docker`.

### Using Docker-Compose
With [Docker-Compose](https://docs.docker.com/compose/), a service may be defined like this:

```yml
nginx:
  image: dekked/nginx-docker
  ports:
    - "80:80"
  volumes:
    - <YOUR_TEMPLATES_DIR>/:/templates
    - <YOUR_INIT_SCRIPTS_DIR>:/docker-entrypoint-init.d
  env:
    MY_ENV_VAR: value
  env_file:
    - <PATH>/nginx.env
  # ...
```

Contributing
------------
You are invited to contribute new features, fixes, or updates, large or small; I am always thrilled to receive pull requests, and do my best to process them as fast as I can.

Authors
-------
* Alan Descoins - alan@tryolabs.com
