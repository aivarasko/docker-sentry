FROM sentry

USER root
ADD conf/sentry.conf.py /etc/
ADD conf/sentry.conf.py /home/user/.sentry/
RUN chown user:user /home/user/.sentry/sentry.conf.py
RUN mkdir /data/

RUN pip install sentry-slack

VOLUME /data/
VOLUME /home/user/
