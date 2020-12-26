FROM ruby:2.5

WORKDIR /usr/src/app

COPY Gemfile Gemfile.lock ./

RUN gem install bundler
RUN bundle install

COPY . .
