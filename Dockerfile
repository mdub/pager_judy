FROM ruby:2.5-alpine

RUN { echo 'install: --no-document'; echo 'update: --no-document'; } >> /etc/gemrc

MAINTAINER Mike Williams <mdub@dogbiscuit.org>

RUN apk --no-cache add \
    ca-certificates

WORKDIR /app

COPY Gemfile /app/Gemfile
COPY pager_judy.gemspec /app/pager_judy.gemspec
COPY lib/pager_judy/version.rb /app/lib/pager_judy/version.rb
COPY Gemfile.lock /app/Gemfile.lock
RUN bundle install --without development test

COPY CHANGES.md /app/
COPY README.md /app/
COPY exe /app/exe
COPY lib /app/lib

WORKDIR /cwd

ENTRYPOINT ["/app/exe/pagerjudy"]
