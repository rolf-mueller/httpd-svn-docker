# httpd-svn-docker
A simple docker project, which allows for hosting subversion repositories

## Introduction
The aim of this project is to provide a docker image which uses optional httpd.conf includes to allow for hosting subversion repositories in a flexible way.
This docker image does not create the configuration files. One must create them first and copy them into the mounted configuration folder.

## Building the image

The image stamps the Apache httpd version and build timestamp into `index.html` so the running server's vulnerability status can be tracked at a glance. Pass the build date explicitly so it reflects the actual build time (otherwise Docker layer caching may reuse a stale value):

```
docker build --build-arg BUILD_DATE=$(date -u +"%Y-%m-%dT%H:%M:%SZ") -t httpd-svn .
```

On Windows PowerShell:

```
docker build --build-arg BUILD_DATE=$(Get-Date -AsUTC -Format "yyyy-MM-ddTHH:mm:ssZ") -t httpd-svn .
```

## Configuration

The configuration is being stored in the mounted volume /etc/svn.

We need the following files:

| Filename | Requirement | Description |
| ----------- | ----------- | ----------- | 
| *my-listen.conf* | required | specifies the listen port |
| *my-server-details.conf* | optional | specifies the server-name and server admin's e-mail |
| *my-svn-repositories.conf* | optional | specifies the subversion repositories |
| *my-httpd-ssl.conf* | optional | specifies configuration relating to secure communication |

## Example configurations

### my-server-details.conf

This file is optional and holds the server details like the server name and the server administrators e-mail.

```
ServerAdmin name@domain.com
ServerName domain.com
```

### my-listen.conf

This file is mandatory and holds the ip address and port, which apache will listen on.

```
Listen 12.34.56.78:80
```

Instead of the port, we can also provide the port only.
```
Listen 80
```

### my-svn-repositories.conf

This configuration file is optional and holds all the configurations for one (or multiple repositories).

```
<Location /svn/personal>
   DAV svn
   SVNParentPath /var/svn/personal
   SVNListParentPath On
   AuthType Basic
   AuthName "Subversion Repositories - Personal"
   AuthUserFile /etc/svn/dav_svn_personal.passwd
   Require valid-user
</Location>

<Location /svn/business>
   DAV svn
   SVNParentPath /var/svn/business
   SVNListParentPath On
   AuthType Basic
   AuthName "Subversion Repositories - Business"
   AuthUserFile /etc/svn/dav_svn_business.passwd
   Require valid-user
</Location>

```
These configuration also allows for multiple repositories underneath the location specified above. Under /var/svn/personal, we can have multiple different repositories like finance, documents, contracts etc.

### my-httpd-ssl.conf

This file holds the configuration which enables secure communication (ssl). The server key and server certificates are located in this directory. 

```
<VirtualHost _default_:9090>
    DocumentRoot "/usr/local/apache2/htdocs"
    ServerName your.domain.name:port

    SSLEngine on
    SSLCertificateFile "/etc/svn/server.crt"
    SSLCertificateKeyFile "/etc/svn/server.key"

    <Directory "/usr/local/apache2/htdocs">
        Options Indexes FollowSymLinks
        AllowOverride None
        Require all granted
    </Directory>

    ErrorLog "/var/log/svn/error_log.log"
    TransferLog "/var/log/svn/access_log.log"
</VirtualHost>
```
## Publishing

This repository is being published on docker hub:
https://hub.docker.com/repository/docker/rolfmuellerau/httpd-svn-server/general


