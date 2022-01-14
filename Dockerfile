FROM ruby:3.1.0-slim-buster AS base

ARG RAILS_ENV=development \
  USER_ID=1000

ENV RAILS_ENV=$RAILS_ENV \
  BUNDLER_VERSION=2.3.3

RUN groupadd --gid $USER_ID nonroot \
  && useradd --uid $USER_ID --gid nonroot --shell /bin/bash --create-home nonroot --home-dir /app

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
COPY --chown=nonroot:nonroot . .
RUN if [ "${RAILS_ENV}" == "production" ]; then \
  SECRET_KEY_BASE=dummyvalue rails assets:precompile; fi

EXPOSE 3000

USER nonroot

CMD ["rails", "server", "-b", "0.0.0.0"]
