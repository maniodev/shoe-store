FROM ruby:2.7.1
RUN apt-get update -qq && apt-get install -y build-essential libpq-dev \
    && apt-get install apt-transport-https \
    && curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add - \
    && echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list \
    && apt-get update && apt-get install -y yarn

WORKDIR /code

COPY Gemfile /code/Gemfile
COPY Gemfile.lock /code/Gemfile.lock
COPY package*.json /code/

RUN bundle install -j 20
RUN yarn install

COPY . /code/

CMD ["rails", "server", "-b", "0.0.0.0"]

