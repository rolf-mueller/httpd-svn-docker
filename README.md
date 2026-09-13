# httpd-svn-docker
A simple docker project, which allows for hosting subversion repositories

## Introduction
The aim of this project is to provide a docker image which uses optional httpd.conf includes to allow for hosting subversion repositories in a flexible way.
This docker image does not create the configuration files. One must create them first and copy them into the mounted configuration folder.

## Configuration

The configuration is being stored in the mounted volume /etc/svn.

We need the following files:
- *my-listen.conf* this file is required and must have the listen port included
- *my-server-details.conf* this file is optional and hols the server-name and server admin's e-mail
- *my-svn-repositories.conf* this file is optional and holds the configuration for all subversion repositories
- *my-httpd-ssl.conf* this file is optional and holds the ssl related information such as the domain name and the location of the certificates and keys

## Example configurations

### my-httpd-ssl.conf

This file holds the configuration which enables secure communication (ssl). The server key and server certificates are located in this directory. 

```
<VirtualHost _default_:9090>
    DocumentRoot "/usr/local/apache2/htdocs"
    ServerName youd.domain.name:port

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
