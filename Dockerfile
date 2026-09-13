# Use official Apache HTTP Server image
FROM httpd:2.4

# Set the maintainer label
LABEL name="httpd-svn" \
      description="Apache httpd with Subversion with https enabled" \
      maintainer="rolf.mueller.au@gmail.com" \
      version="1.6"

# Install Subversion and mod_dav_svn
RUN apt-get update && \
    apt-get install -y libapache2-mod-svn subversion && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# Copy your custom HTML file into the web root
COPY index.html /usr/local/apache2/htdocs/index.html

# Let's use our custom Apache configuration,
# which includes optional inclusion of
# my-httpd-ssl.conf for SSL configuration
# my-repositories.conf for repository-specific configuration
COPY my-httpd.conf /usr/local/apache2/conf/httpd.conf

# Create a Subversion repository and set up authentication
RUN mkdir -p /var/svn && \
    mkdir -p /etc/svn && \
    mkdir -p /var/log/svn && \
    chown -R www-data:www-data /var/svn /etc/svn /var/log/svn && \
    chmod -R 755 /var/svn /etc/svn /var/log/svn

# Declare volumes for persistent data
# "/var/svn" mounted to the subversion repositories
# "/etc/svn" mounted to the configuration (http and ssl)
# "/var/log/svn" mounted to store logs
VOLUME ["/var/svn", "/etc/svn", "/var/log/svn"]

# Let's use 9090 instead of 443, as 443 is already occupied by the host's Apache server
# EXPOSE 80 443
EXPOSE 9090

# Set working directory
WORKDIR /usr/local/apache2

# Start Apache in foreground
CMD ["httpd-foreground"]