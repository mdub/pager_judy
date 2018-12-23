FROM ruby:2.5-alpine

RUN { echo 'install: --no-document'; echo 'update: --no-document'; } >> /etc/gemrc

MAINTAINER Mike Williams <mdub@dogbiscuit.org>

RUN apk --no-cache add \
    ca-certificates

WORKDIR /app

COPY Gemfile /app/Gemfile
COPY Gemfile.lock /app/Gemfile.lock
RUN bundle install --without development test

COPY bin /app/bin
COPY lib /app/lib
COPY README.md /app/

WORKDIR /cwd

ENTRYPOINT ["/app/bin/pagerjudy"]
