FROM rails:5.0.0.1

ADD Gemfile .

RUN bundle install

RUN gem install bigdecimal

EXPOSE 3000

