#############################################################
#
# nginx
#
#############################################################

NGINX_VERSION = 1.4.6
NGINX_SOURCE = nginx-$(NGINX_VERSION).tar.gz
NGINX_SITE = http://nginx.org/download/
NGINX_LICENSE = BSD-2c
NGINX_LICENSE_FILES = LICENSE
NGINX_URL = http://nginx.org/
NGINX_PACKAGE_LINKING = Standalone Application
NGINX_DEPENDENCIES = pcre zlib logrotate openssl libatomic_ops

define NGINX_CONFIGURE_CMDS
	export $(TARGET_CONFIGURE_OPTS); \
        cd $(@D); \
	./configure \
        --crossbuild=Linux:$(BR2_TOOLCHAIN_EXTERNAL_PREFIX) \
        --prefix="/usr" \
        --sbin-path="sbin/nginx" \
        --conf-path="/etc/nginx/nginx.conf" \
        --error-log-path="$(BR2_PACKAGE_NGINX_LOGS_DIR)/error.log" \
        --http-log-path="$(BR2_PACKAGE_NGINX_LOGS_DIR)/access.log" \
        --pid-path="/var/run/nginx.pid" \
        --lock-path="/var/run/nginx.lock" \
	--with-libatomic \
        --with-http_ssl_module \
        --http-client-body-temp-path="/tmp/nginx/client-body-temp" \
        --http-proxy-temp-path="/tmp/nginx/proxy-temp" \
        --http-fastcgi-temp-path="/tmp/nginx/fastcgi-temp" \
        --http-uwsgi-temp-path="/tmp/nginx/uwsgi-temp" \
        --http-scgi-temp-path="/tmp/nginx/scgi-temp"
endef

define NGINX_BUILD_CMDS
	cd $(@D); make -j$(PARALLEL_JOBS)
endef

define NGINX_INSTALL_TARGET_CMDS
	cd $(@D); DESTDIR=$(TARGET_DIR) make install
        [ -f $(TARGET_DIR)/etc/init.d/S50nginx ] || \
                $(INSTALL) -D -m 755 package/nginx/S50nginx \
                        $(TARGET_DIR)/etc/init.d/S50nginx
	rm -fr $(TARGET_DIR)/etc/nginx/nginx.conf
        [ -f $(TARGET_DIR)/etc/nginx/nginx.conf ] || \
                $(INSTALL) -D -m 755 package/nginx/nginx.conf \
                        $(TARGET_DIR)/etc/nginx/nginx.conf
        # install ssl certificates
        mkdir -p $(TARGET_DIR)/etc/nginx/ssl
        openssl genrsa -out $(TARGET_DIR)/etc/nginx/ssl/experiencecontroller.key 1024
        openssl req -new -subj "/C=US/ST= /L= /O= /CN= " -key $(TARGET_DIR)/etc/nginx/ssl/experiencecontroller.key  -out $(@D)/experiencecontroller.csr
        openssl x509 -req -days 3650 -in $(@D)/experiencecontroller.csr -signkey $(TARGET_DIR)/etc/nginx/ssl/experiencecontroller.key -out $(TARGET_DIR)/etc/nginx/ssl/experiencecontroller.crt

	# install logrotate rule
	cp package/nginx/nginxLog.conf $(TARGET_DIR)/etc/logrotate.d/
endef

$(eval $(generic-package))
