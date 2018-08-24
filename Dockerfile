FROM ruby:2.4

ENV INSTALL_PATH /app

EXPOSE 80

RUN mkdir -p $INSTALL_PATH
WORKDIR $INSTALL_PATH

COPY Gemfile* $INSTALL_PATH/
RUN bundle install --with=production
COPY . .

CMD $INSTALL_PATH/start_rails.sh
