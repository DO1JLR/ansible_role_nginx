Nginx Webserver
===============

Ansible role to configure the `nginx` webserver and manage TLS certificates
by the help of the `acmetool` LE client. This role is designed to work together
with the `acmetool` role.


Variables
---------

* `nginx__dhparam_size` (Default 2048):
  The DH parameters bit length.

* `nginx_sites` (Default `{}`):
  The virtual hosts configurations for this webserver.

* `nginx__disable_acmetool` (Default `False`):
  Optionally disable acme support within this role.


Note: If you do not intent to use `acmetool` or LE at all, it is possible to disable
      support for it. However, in that case *all* TLS certificates and private keys
      loaded by the nginx configuration must be present on the destination host *before*
      running this role. Additionally you need to provide own replacement templates
      for `files/nginx/sites-available/*j2` (see point 3 in the next section).


Files
-----

Note: Path segments `<host_files>` when resolved by the `hf`/`hfg` lookup plugins always
      include full `hf`/`hfg` functionality, for example also search the `group_files`
      directory as apropriate. (See also note on dependencies below.)


* Main `nginx` configuration file template `nginx/nginx.conf`
  Lookup path:
    - `<playbook_dir> / files / <host_files> / <inventory_hostname> / nginx / nginx.conf`  [via `hf` lookup]
    - `<playbook_dir> / files / nginx / nginx.conf`  [via `hf` lookup]
    - `<role_dir> / files / nginx / nginx.conf`  [default role fallback]


* Global (default and vhost independent) configuration snippets
  Lookup path:
    - `<playbook_dir> / files / <host_files> / <inventory_hostname> / nginx / snippets / <snippetname>_global.snippet.conf`  [via `hfg` lookup]
    - `<playbook_dir> / files / nginx / snippets / <snippetname>_global.snippet.conf`  [via `hfg` lookup]
    - `<role_dir> / files / nginx / snippets / <snippetname>_global.snippet.conf`  [default role fallback]
  Note: The `<snippetname>` may not contain a `_`.


* Main configuration file for each virtual host (usually contains corresponding nginx `server` block)
  Lookup path (tls):
    - `<playbook_dir> / files / nginx / sites / <vhostname>_tls.conf`
    - `<role_dir> / files / nginx / sites-available / vhost_tls.conf.j2`  [default role fallback]
  Lookup path (http):
    - `<playbook_dir> / files / nginx / sites / <vhostname>_http.conf`  [via `first_found` lookup]
    - `<role_dir> / files / nginx / sites-available / vhost_http_redirect.conf.j2`  [default role fallback]


* Per virtual host templated snippets
  Lookup path:
    - `<playbook_dir> / files / <host_files> / <inventory_hostname> / nginx / snippets / _<snippetname>_site.snippet.conf`  [via `hfg` lookup]
    - `<playbook_dir> / files / nginx / snippets / _<snippetname>_site.snippet.conf`  [via `hfg` lookup]
    - `<role_dir> / files / nginx / snippets / _<snippetname>_site.snippet.conf`  [default role fallback]
  Note 1: The file name is expanded on the server per each virtual host to `<vhostname>_<snippetname>_site.snippet.conf`.
  Note 2: The `<snippetname>` may not contain a `_`.


* Per virtual host custom individual snippet files
  Lookup path:
    - `<playbook_dir> / files / <host_files> / <inventory_hostname> / nginx / snippets / <vhostname>_<snippetname>_site.snippet.conf`  [via `hfg` lookup]
    - `<playbook_dir> / files / nginx / snippets / <vhostname>_<snippetname>_site.snippet.conf`  [via `hfg` lookup]
    - `<role_dir> / files / nginx / snippets / <vhostname>_<snippetname>_site.snippet.conf`  [default role fallback]
  Note 1: In general, content of such snippets could be merged with main vhost configuration file.
  Note 2: The `<snippetname>` may not contain a `_`.


* Per virtual host basic auth file
  Lookup path:
    - unimplemented

* Per virtual host robots file
  Lookup path:
    - unimplemented


Example
-------

Configuration of the virtual hosts in the `host_vars` of the webserver:

```
nginx_sites:
  - name: 'example.org'
    altnames:                              Optional, for acmetool
      - 'www.example.org'
      - 'ftp.example.org'
    robots: 'robots_allow_all.txt'         Optional, unimplemented
    htaccess: 'htpasswd.example.org'       Optional, unimplemented
    webroot:                               Optional, for use with 'webhost' role
       path                                Optional, for use with 'webhost' role
       user                                Optional, for use with 'webhost' role
       group                               Optional, for use with 'webhost' role
       mode                                Optional, for use with 'webhost' role
```

Alternatively, put this data into a suitable `group_vars` file.


Dependencies
------------

This role depends on the `host_file` (`hf`) and `host_files_glob` (`hfg`) lookup plugins.


References
----------

* [Nginx documentation](https://nginx.org/en/docs/)

* [acmetool](https://github.com/hlandau/acmetool)
* [acmetool user's guide](https://hlandau.github.io/acmetool/userguide)
