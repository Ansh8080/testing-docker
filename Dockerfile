
FROM python:3.7.1
ENV PYTHONUNBUFFERED 1
RUN apt-get update && apt-get install apt-transport-https vim -y && apt-get clean
RUN apt-get install supervisor -y
#COPY worker.conf /etc/supervisor/conf.d

#Running Cron
RUN apt-get update && apt-get install -y cron

RUN touch /var/log/crontab.log \
&& echo "* * * * * /code/manage.py manage_kiosk_notification >> /var/log/crontab.log 2>&1"  >> /etc/crontab \
&& echo "* * * * * /code/manage.py index_maxisdeviceprofile_bar >> /var/log/crontab.log 2>&1"  >> /etc/crontab \
&& echo "* * * * * /code/manage.py index_maxisdeviceprofile >> /var/log/crontab.log 2>&1"  >> /etc/crontab \
&& echo "* * * * * /code/manage.py index_action_history >> /var/log/crontab.log 2>&1"  >> /etc/crontab \
&& echo "* * * * * /code/manage.py index_device_lifecycle >> /var/log/crontab.log 2>&1"  >> /etc/crontab \
&& echo "*/15 * * * *  /code/manage.py manage_registration >> /var/log/crontab.log 2>&1" >> /etc/crontab \
&& echo "*/17 * * * * /code/manage.py manage_bar >> /var/log/crontab.log 2>&1"  >> /etc/crontab \
&& echo "*/13 * * * * /code/manage.py manage_unbar >> /var/log/crontab.log 2>&1"  >> /etc/crontab \
&& echo "0 4 * * * /code/manage.py manage_life_cycle >> /var/log/crontab.log 2>&1"  >> /etc/crontab \
&& echo "20 10 * * * /code/manage.py manage_activation >> /var/log/crontab.log 2>&1"  >> /etc/crontab \
&& echo "0 23 * * * /code/manage.py manage_bar_action_applied >> /var/log/crontab.log 2>&1"  >> /etc/crontab \
&& echo "55 22 * * * /code/manage.py index_cleanup >> /var/log/crontab.log 2>&1" >> /etc/crontab \
&& echo "0 23 * * * /code/manage.py index_maxisdeviceprofile -d=365 >> /var/log/crontab.log 2>&1"  >> /etc/crontab \
&& echo "0 23 * * * /code/manage.py index_maxisdeviceprofile_bar -d=365 >> /var/log/crontab.log 2>&1"  >> /etc/crontab \
&& echo "59 23 * * * /code/manage.py reports_email >> /var/log/crontab.log 2>&1"  >> /etc/crontab \
&& crontab /etc/crontab
# App setup
ADD . /code
WORKDIR /code

# Requirements installation
RUN pip3 install --no-cache-dir -r requirements.txt
