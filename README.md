# matomo-h2o
Mruby script to run [Matomo](https://matomo.org/) web analytics under the H2O webserver

This script is mostly an adaptation of the relevant sections of [matomo-nginx](https://github.com/matomo-org/matomo-nginx), the Nginx configuration for running Matomo.

## Download mruby script file
Download ``matomo-h2o.rb`` to your server, e.g. using ``wget https://raw.githubusercontent.com/utrenkner/matomo-h2o/main/matomo-h2o.rb``.

## Configuring H2O
This assumes you already have a fully configured [H2O](https://github.com/h2o/h2o) webserver running.

If you want to run Matomo in a separate directory, add a path segment similar to this:
```
    paths:
      "/matomo":
        mruby.handler-file: /path/to/matomo-h2o.rb
        file.dir: "/path/to/the/matomo-sources" 
        file.index: [ 'index.html', 'index.php' ]
```
## Always test your h2o.conf before reloading/restarting H2O
``h2o -t -c /path/to/h2o.conf``
If everything looks good, reload or restart H2O the way you normally do, e.g. on FreeBSD using ``service h2o reload``.
