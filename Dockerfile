FROM ruby:3.1.2
WORKDIR /app
COPY Gemfile* ./
RUN gem install bundler -v 2.3.14
RUN bundle install
COPY . .
EXPOSE 3000
CMD ["rails", "server", "-b", "0.0.0.0"]