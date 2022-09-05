FROM ruby:2.7.2

RUN apt-get update && apt-get install -y nodejs yarn postgresql-client

RUN mkdir /app
WORKDIR /app
COPY ./apps/rails-demo/Gemfile Gemfile.lock ./
RUN gem install bundler
RUN bundle install
COPY ./apps/rails-demo/. .

RUN rake assets:precompile

EXPOSE 3000
CMD ["rails", "server", "-b", "0.0.0.0"]
