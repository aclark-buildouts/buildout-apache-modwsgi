[buildout]
allow-hosts = *.python.org
extensions = buildout.bootstrap
parts = 
    apache
    apache-config
    app
    mod-wsgi
    supervisor

[apache]
recipe = hexagonit.recipe.cmmi
url = http://apache.ziply.com//httpd/httpd-2.2.21.tar.gz
configure-options = 
    --enable-mods-shared="all"
    --enable-so
    --enable-proxy
    --enable-proxy-connect
    --enable-proxy-ftp
    --enable-proxy-http
    --enable-proxy-scgi
    --enable-proxy-ajp
    --enable-proxy-balancer
    --enable-ssl

[app]
recipe = collective.recipe.template
url = http://pythonpackages.com/buildout/apache/conf/app.wsgi.in
output = ${buildout:directory}/app.wsgi
hello_world = Hello World!

[apache-config]
# Requires c.r.template 1.9 or higher
recipe = collective.recipe.template
url = http://pythonpackages.com/buildout/apache/conf/httpd.conf.in
output = ${buildout:directory}/httpd.conf
app = ${app:output}
listen = 8080

[mod-wsgi]
recipe = hexagonit.recipe.cmmi
url = http://modwsgi.googlecode.com/files/mod_wsgi-3.3.tar.gz
configure-options = --with-apxs=${buildout:parts-directory}/apache/bin/apxs --with-python=${buildout:executable}

[supervisor]
recipe = collective.recipe.supervisor
programs = 0 apache ${apache:location}/bin/httpd [ -c "ErrorLog /dev/stdout" -DFOREGROUND -f ${buildout:directory}/httpd.conf ]

