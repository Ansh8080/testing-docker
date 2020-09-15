#!/bin/bash
# Apply database migrations
echo "Apply database migrations"
python manage.py migrate
#restart cron service
/etc/init.d/cron restart
# Start server
echo "Starting server"
#celery flower -A proj --broker=amqp://guest:guest@10.0.0.4:5672/
celery flower -A proj --broker=amqp://guest:guest@10.0.0.36:5672/
# uwsgi --ini /code/uwsgi.ini
# Start supervisor
/usr/bin/supervisord
