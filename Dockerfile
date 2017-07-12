FROM ruby:2.4-alpine@sha256:0cc71e565669c2bfd76a42a8c2ee481e13a038c007ba65322b0e98c7b4736169

MAINTAINER Group Delivery Engineering <gde@rea-group.com>

RUN apk --no-cache add \
    ca-certificates \
    diffutils \
    openssh-client

RUN { echo 'install: --no-document'; echo 'update: --no-document'; } >> /etc/gemrc

WORKDIR /app

COPY Gemfile /app/Gemfile
COPY Gemfile.lock /app/Gemfile.lock
RUN bundle install

COPY bin /app/bin
COPY lib /app/lib
COPY defaults.yml /app/
COPY README.md /app/
COPY CHANGES.md /app/
COPY version.txt /app/

WORKDIR /cwd
ENTRYPOINT ["/app/bin/pager_duty_ctl"]
