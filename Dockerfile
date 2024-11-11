FROM php:8-apache

RUN apt-get update && apt-get install -y libicu-dev zip unzip git && docker-php-ext-install intl mysqli

COPY --from=composer /usr/bin/composer /usr/bin/composer

