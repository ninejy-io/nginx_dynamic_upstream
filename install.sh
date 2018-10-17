#!/bin/bash


RESTY_VERSION="1.13.6.2"
RESTY_LUAROCKS_VERSION="2.4.4"
RESTY_OPENSSL_VERSION="1.1.0i"
RESTY_PCRE_VERSION="8.42"
RESTY_J="1"
RESTY_CONFIG_OPTIONS="\
    --with-file-aio \
    --with-http_addition_module \
    --with-http_auth_request_module \
    --with-http_dav_module \
    --with-http_flv_module \
    --with-http_geoip_module=dynamic \
    --with-http_gunzip_module \
    --with-http_gzip_static_module \
    --with-http_image_filter_module=dynamic \
    --with-http_mp4_module \
    --with-http_random_index_module \
    --with-http_realip_module \
    --with-http_secure_link_module \
    --with-http_slice_module \
    --with-http_ssl_module \
    --with-http_stub_status_module \
    --with-http_sub_module \
    --with-http_v2_module \
    --with-http_xslt_module=dynamic \
    --with-ipv6 \
    --with-mail \
    --with-mail_ssl_module \
    --with-md5-asm \
    --with-pcre-jit \
    --with-sha1-asm \
    --with-stream \
    --with-stream_ssl_module \
    --with-threads \
    "
RESTY_CONFIG_OPTIONS_MORE="--add-module=/tmp/nginx-upsync-module-2.1.0/"

resty_version="${RESTY_VERSION}"
resty_luarocks_version="${RESTY_LUAROCKS_VERSION}"
resty_openssl_version="${RESTY_OPENSSL_VERSION}"
resty_pcre_version="${RESTY_PCRE_VERSION}"
resty_config_options="${RESTY_CONFIG_OPTIONS}"
resty_config_options_more="${RESTY_CONFIG_OPTIONS_MORE}"

# These are not intended to be user-specified
_RESTY_CONFIG_DEPS="--with-openssl=/tmp/openssl-${RESTY_OPENSSL_VERSION} --with-pcre=/tmp/pcre-${RESTY_PCRE_VERSION}"


# 1) Install apt dependencies
# 2) Download and untar OpenSSL, PCRE, and OpenResty
# 3) Build OpenResty

DEBIAN_FRONTEND=noninteractive apt-get update \
    && DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends \
        build-essential \
        ca-certificates \
        curl \
        gettext-base \
        libgd-dev \
        libgeoip-dev \
        libncurses5-dev \
        libperl-dev \
        libreadline-dev \
        libxslt1-dev \
        make \
        perl \
        unzip \
        zlib1g-dev \
        wget

# Install docker-ce
curl -fsSL https://get.docker.com | bash -s docker --mirror Aliyun

cd /tmp
curl -fSL https://www.openssl.org/source/openssl-${RESTY_OPENSSL_VERSION}.tar.gz -o openssl-${RESTY_OPENSSL_VERSION}.tar.gz
tar xzf openssl-${RESTY_OPENSSL_VERSION}.tar.gz
curl -fSL https://ftp.pcre.org/pub/pcre/pcre-${RESTY_PCRE_VERSION}.tar.gz -o pcre-${RESTY_PCRE_VERSION}.tar.gz
tar xzf pcre-${RESTY_PCRE_VERSION}.tar.gz
curl -fSL https://openresty.org/download/openresty-${RESTY_VERSION}.tar.gz -o openresty-${RESTY_VERSION}.tar.gz
tar xzf openresty-${RESTY_VERSION}.tar.gz
wget https://github.com/weibocom/nginx-upsync-module/archive/v2.1.0.tar.gz -O nginx-upsync-module-2.1.0.tar.gz
tar xzf nginx-upsync-module-2.1.0.tar.gz
cd /tmp/openresty-${RESTY_VERSION}
./configure -j${RESTY_J} ${_RESTY_CONFIG_DEPS} ${RESTY_CONFIG_OPTIONS} ${RESTY_CONFIG_OPTIONS_MORE}
make -j${RESTY_J}
make -j${RESTY_J} install
curl -fSL https://github.com/luarocks/luarocks/archive/${RESTY_LUAROCKS_VERSION}.tar.gz -o luarocks-${RESTY_LUAROCKS_VERSION}.tar.gz
tar xzf luarocks-${RESTY_LUAROCKS_VERSION}.tar.gz
cd luarocks-${RESTY_LUAROCKS_VERSION}
./configure \
    --prefix=/usr/local/openresty/luajit \
    --with-lua=/usr/local/openresty/luajit \
    --lua-suffix=jit-2.1.0-beta3 \
    --with-lua-include=/usr/local/openresty/luajit/include/luajit-2.1
make build && make install
