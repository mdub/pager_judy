FROM ruby:2.4-alpine@sha256:6b85a95c42eaf84f46884c82376aa653b343a0bd81ce3350dea2c56e0b15dcd6

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
