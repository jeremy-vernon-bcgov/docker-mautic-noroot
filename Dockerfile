FROM php:7.3-apache
#Taken from the docker-mautic 3x release.
# Install PHP extensions
RUN apt-get update && apt-get install --no-install-recommends -y \
    ca-certificates \
    build-essential  \
    software-properties-common \
    cron \
    git \
    htop \
    wget \
    dos2unix \
    curl \
    libcurl4-gnutls-dev \
    sudo \
    libc-client-dev \
    libkrb5-dev \
    libmcrypt-dev \
    libssl-dev \
    libxml2-dev \
    libzip-dev \
    libjpeg-dev \
    libmagickwand-dev \
    libpng-dev \
    libgif-dev \
    libtiff-dev \
    libz-dev \
    libpq-dev \
    imagemagick \
    graphicsmagick \
    libwebp-dev \
    libjpeg62-turbo-dev \
    libxpm-dev \
    libaprutil1-dev \
    libicu-dev \
    libfreetype6-dev \
    unzip \
    nano \
    zip \
    mariadb-client \
    && apt-get purge -y --auto-remove -o APT::AutoRemove::RecommendsImportant=false \
    && rm -rf /var/lib/apt/lists/* \
    && rm /etc/cron.daily/*

RUN docker-php-ext-configure imap --with-kerberos --with-imap-ssl && \
    docker-php-ext-install imap && \
    docker-php-ext-enable imap

RUN docker-php-ext-configure gd --with-freetype-dir=/usr/lib --with-png-dir=/usr/lib --with-jpeg-dir=/usr/lib \
    && docker-php-ext-install  gd \
    && docker-php-ext-configure opcache --enable-opcache \
    && docker-php-ext-install intl mbstring mysqli curl pdo_mysql zip opcache bcmath gd \
    && docker-php-ext-enable intl mbstring mysqli curl pdo_mysql zip opcache bcmath gd

# Install composer
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/bin --filename=composer

# Define Mautic version and expected SHA1 signature
ENV MAUTIC_VERSION 3.2.5
ENV MAUTIC_SHA1 f57071c500fcedd2a64c0e7b94f0354cfa54d0aa
# By default enable cron jobs
ENV MAUTIC_RUN_CRON_JOBS true
# Setting PHP properties
ENV PHP_INI_DATE_TIMEZONE='UTC' \
    PHP_MEMORY_LIMIT=512M \
    PHP_MAX_UPLOAD=512M \
    PHP_MAX_EXECUTION_TIME=300

COPY mautic/ /var/www/html

# Copy init scripts and custom .htaccess
COPY 000-default.conf /etc/apache2/sites-enabled/000-default.conf
COPY ports.conf /etc/apache2/ports.conf
COPY php.ini /usr/local/etc/php/php.ini
COPY local.php /var/www/html/app/config/local.php
COPY mautic.crontab /etc/cron.d/mautic
COPY make-local-config.php /make-local-config.php
COPY docker-entrypoint.sh /entrypoint.sh
# Enable Apache Rewrite Module
RUN a2enmod rewrite

#Non SU ports
EXPOSE 8080

# Mod it all to be writable
RUN chown -R :0 /var/www
RUN chown -R :0 /usr/local/etc/php
RUN chmod -R g+rwX /usr/local/etc/php
RUN chmod -R g+rwX /var/www

# Apply necessary permissions
RUN ["chmod", "+x", "/entrypoint.sh"]
ENTRYPOINT ["/entrypoint.sh"]

CMD ["apache2-foreground"]

