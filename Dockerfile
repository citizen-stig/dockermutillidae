FROM tutum/lamp:latest
MAINTAINER Nikolay Golub <nikolay.v.golub@gmail.com>

ENV DEBIAN_FRONTEND noninteractive

# Preparation
RUN rm -fr /app/*
RUN apt-get install -yqq wget unzip

# Deploy Nutillidae
RUN wget -O /mutillidae.zip http://sourceforge.net/projects/mutillidae/files/latest/download
RUN unzip /mutillidae.zip
RUN rm -rf /app/*
RUN cp -r /mutillidae/* /app

# Configure and clean up
RUN rm -rf /mutillidae
RUN sed -i 's/DirectoryIndex index.html.*/DirectoryIndex index.php index.html index.cgi index.pl index.xhtml index.htm/g' /etc/apache2/mods-enabled/dir.conf
RUN sed -i 's/static public \$mMySQLDatabaseUsername =.*/static public \$mMySQLDatabaseUsername = "admin";/g' /app/classes/MySQLHandler.php
RUN echo "sed -i 's/static public \$mMySQLDatabasePassword =.*/static public \$mMySQLDatabasePassword = \\\"'\$PASS'\\\";/g' /app/classes/MySQLHandler.php" >> /create_mysql_admin_user.sh
RUN echo 'session.save_path = "/tmp"' >> /etc/php5/apache2/php.ini 

EXPOSE 80 3306
CMD ["/run.sh"]
