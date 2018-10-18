## nginx dynamic upstream
### OS 'Ubuntu 16.04'

#### mkdir -p /etc/nginx/conf.d/upstream.d/

#### git clone https://github.com/jy90/nginx_dynamic_upstream.git /tmp/

#### cd /tmp/nginx_dynamic_upstream/ && bash install.sh && bash consul.sh

#### cp -f ./nginx_dynamic_upstream/nginx/nginx.conf /usr/local/openresty/nginx/conf/nginx.conf

#### cp ./nginx_dynamic_upstream/nginx/conf.d/default-server.conf /etc/nginx/conf.d/

#### export PATH=$PATH:/usr/local/openresty/luajit/bin:/usr/local/openresty/nginx/sbin:/usr/local/openresty/bin

#### /usr/local/openresty/nginx/sbin/nginx
