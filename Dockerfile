FROM php:7.2-fpm

# Install dependencies
RUN apt-get update \
  && apt-get install -y \
    libfreetype6-dev \ 
    libicu-dev \ 
    libjpeg62-turbo-dev \ 
    libmcrypt-dev \ 
    libpng-dev \ 
    libxslt1-dev \ 
    sendmail-bin \ 
    sendmail \ 
    sudo \ 
    zip libzip-dev \ 
    git

# Configure the gd library
#RUN docker-php-ext-configure \
#  gd --with-freetype=/usr/include/ --with-jpeg=/usr/include/

# Install required PHP extensions
RUN docker-php-ext-install \
  dom \ 
  gd \ 
  intl \ 
  pdo_mysql \ 
  xsl \ 
  zip \ 
  soap \ 
  bcmath \ 
  pcntl \ 
  sockets

# Install Xdebug (but don't enable)
RUN pecl install -o -f xdebug
RUN pecl install -o -f redis \
        &&  rm -rf /tmp/pear \
        &&  docker-php-ext-enable redis

WORKDIR /app
ENV PHP_MEMORY_LIMIT 2G
ENV PHP_ENABLE_XDEBUG false
ENV MAGENTO_ROOT /app

ENV DEBUG false
ENV UPDATE_UID_GID false

ENV UPLOAD_MAX_FILESIZE 64M
RUN curl -sS https://getcomposer.org/installer | php -- \
      --install-dir=/usr/local/bin --filename=composer --version=2.2.7
