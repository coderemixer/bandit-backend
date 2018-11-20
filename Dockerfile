FROM ruby:2.5
RUN apt-get update -qq && apt-get install -y build-essential libpq-dev postgresql-client
RUN mkdir /bandit
WORKDIR /bandit
COPY Gemfile /bandit/Gemfile
COPY Gemfile.lock /bandit/Gemfile.lock
RUN bundle install
COPY . /bandit

ENTRYPOINT [ "./wait-for-postgres.sh", "bash", "./entrypoint.sh"]
