FROM debian:stretch
#FROM tozd/runit

EXPOSE 25/tcp 465/tcp 587/tcp

#ENV MAILNAME mail.example.com
#ENV MY_NETWORKS 172.17.0.0/16 127.0.0.0/8
#ENV MY_DESTINATION localhost.localdomain, localhost
#ENV ROOT_ALIAS admin@example.com

# /etc/aliases should be available at postfix installation.
#COPY ./etc/aliases /etc/aliases

RUN apt-get update -q -q && \
 apt-get --yes --no-install-recommends install supervisor rsyslog && \
 echo postfix postfix/main_mailer_type string "'Internet Site'" | debconf-set-selections && \
 echo postfix postfix/mynetworks string "127.0.0.0/8" | debconf-set-selections && \
 echo postfix postfix/mailname string lb2.niemeczek.at | debconf-set-selections && \
 apt-get --yes install postfix postfix-mysql && \
 sed -i 's,/var/log/mail,/var/log/postfix/mail,g' /etc/rsyslog.conf

COPY supervisord.conf /etc/supervisor/conf.d/supervisord.conf
COPY postfix-wrapper.sh /usr/local/bin/postfix-wrapper.sh
RUN chmod +x /usr/local/bin/postfix-wrapper.sh

#VOLUME /etc/postfix/
#VOLUME /var/log/postfix/
#VOLUME /var/spool/postfix/

#ENTRYPOINT /etc/init.d/postfix start
#ENTRYPOINT ["/usr/bin/supervisord"]
#CMD ["-c /etc/supervisor/"]
CMD /usr/bin/supervisord -c /etc/supervisor/supervisord.conf
#CMD /usr/local/bin/postfix-wrapper.sh
#CMD /usr/sbin/rsyslogd -n
