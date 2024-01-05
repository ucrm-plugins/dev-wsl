ARG UCRM_VERSION
FROM ubnt/unms-crm:${UCRM_VERSION}
MAINTAINER Ryan Spaeth <rspaeth@spaethtech.com>

ARG XDEBUG_VERSION=3.2.1

# We over-specify PHPIZE_DEPS to ensure we have the correct dependencies and to remove any warnings from our IDE.
ENV PHPIZE_DEPS=${PHPIZE_DEPS:-"autoconf dpkg-dev dpkg file g++ gcc libc-dev make pkgconf re2c"}

# We include some logic to prevent warnings, as this may be a re-build and Xdebug may already be installed.
RUN cd /etc/nginx/available-servers ; \
    sed -i '/        include xdebug_params;/d' ucrm.conf ; \
    sed -i 's|\$document_root;|\$document_root;\n        include xdebug_params;|g' ucrm.conf ; \
    if ! pecl list | grep xdebug >/dev/null 2>&1; then apk add --update --no-cache linux-headers $PHPIZE_DEPS; fi ; \
    if ! pecl list | grep xdebug >/dev/null 2>&1; then pecl install xdebug-$XDEBUG_VERSION; fi ; \
    if ! php -m    | grep xdebug >/dev/null 2>&1; then docker-php-ext-enable xdebug; fi

# Install Composer
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

# Copy over any custom Xdebug settings.
COPY ./xdebug.ini /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini
COPY ./xdebug_params /etc/nginx/xdebug_params

RUN apk add nano
