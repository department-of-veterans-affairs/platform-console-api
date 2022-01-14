FROM ruby:3.1.0-slim-buster AS base

ENV RAILS_ENV=$RAILS_ENV \
  BUNDLER_VERSION=2.3.3

WORKDIR /app

RUN apt-get update && apt-get install -y build-essential libpq-dev git wget \
  && rm -rf /var/cache/apt/archives/* /var/lib/apt/lists/* /tmp/* /var/tmp/*

# Download VA Certs
RUN wget -q -r -np -nH -nd -a .cer -P /usr/local/share/ca-certificates http://aia.pki.va.gov/PKI/AIA/VA/ \
  && for f in /usr/local/share/ca-certificates/*.cer; do openssl x509 -inform der -in $f -out $f.crt; done \
  && update-ca-certificates \
  && rm .cer

RUN gem install bundler:${BUNDLER_VERSION} --no-document

COPY Gemfile Gemfile.lock ./
RUN bundle install
COPY . .

EXPOSE 3000

CMD ["rails", "server", "-b", "0.0.0.0"]
