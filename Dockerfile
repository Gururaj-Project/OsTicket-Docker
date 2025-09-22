FROM php:8.1-apache-bullseye

# Install dependencies required for building PHP extensions
RUN apt-get update && apt-get install -y \
    libpng-dev \
    libjpeg-dev \
    libfreetype6-dev \
    libonig-dev \
    libzip-dev \
    libicu-dev \
    libxml2-dev \
    libcurl4-openssl-dev \
    libc-client2007e-dev \
    libkrb5-dev \
    unzip \
    git \
    curl \
 && docker-php-ext-configure gd --with-freetype --with-jpeg \
 && docker-php-ext-configure imap --with-kerberos --with-imap-ssl \
 && docker-php-ext-install \
        gd \
        mysqli \
        mbstring \
        zip \
        intl \
        xml \
        curl \
        imap \
        fileinfo \
        pdo \
        pdo_mysql \
 && pecl install apcu \
 && docker-php-ext-enable apcu opcache \
 && apt-get clean && rm -rf /var/lib/apt/lists/*

RUN a2enmod rewrite

WORKDIR /var/www/html

HEALTHCHECK --interval=30s --timeout=10s --start-period=10s --retries=3 \
  CMD curl -f http://localhost/scp/login.php || exit 1
