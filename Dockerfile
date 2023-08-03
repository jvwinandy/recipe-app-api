FROM python:3.9-alpine3.13
LABEL manteiner="jvwinandy.com"

ENV PYTHONUNBUFFERED 1

COPY ./requirements.txt /tmp/requirements.txt
COPY ./requirements.dev.txt /tmp/requirements.dev.txt
COPY ./app /app
WORKDIR /app
EXPOSE 8000

ARG DEV=false

RUN apk update && apk add postgresql-dev gcc python3-dev musl-dev

RUN python -m venv /py &&  \
    /py/bin/pip install --upgrade pip &&  \
    /py/bin/pip install -r /tmp/requirements.txt &&  \
    if [ "$DEV" = "true" ]; then /py/bin/pip install -r /tmp/requirements.dev.txt; fi &&  \
    rm -rf /tmp &&  \
    adduser --disabled-password --no-create-home django-user

RUN ls ../home
ENV PATH="/py/bin:$PATH"

USER django-user