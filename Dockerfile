# Use the barebones version of Ruby 2.2.3.
FROM ruby:2.3.1-slim

# Optionally set a maintainer name to let people know who made this image.
MAINTAINER Nick Janetakis <nick.janetakis@gmail.com>

# Install dependencies:
# - build-essential: To ensure certain gems can be compiled
# - nodejs: Compile assets
# - libpq-dev: Communicate with postgres through the postgres gem
# - postgresql-client-9.4: In case you want to talk directly to postgres
RUN apt-get update && apt-get install -qq -y build-essential nodejs libpq-dev postgresql-client-9.4 --fix-missing --no-install-recommends

# Set an environment variable to store where the app is installed to inside
# of the Docker image.
ENV INSTALL_PATH /drkiq
RUN mkdir -p $INSTALL_PATH

# This sets the context of where commands will be ran in and is documented
# on Docker's website extensively.
WORKDIR $INSTALL_PATH

# Ensure gems are cached and only get updated when they change. This will
# drastically increase build times when your gems do not change.
COPY Gemfile Gemfile
RUN bundle install

# Copy in the application code from your work station at the current directory
# over to the working directory.
COPY . .

# Provide dummy data to Rails so it can pre-compile assets.
RUN bundle exec rake RAILS_ENV=production DATABASE_URL=postgresql://postgres:Bpa6JZD4VZKBk3ps@postgres:5432/drkiq SECRET_TOKEN=61f6a01089a43bd3fd27166c3289b1271f0fab8cd21a382734fe6b68bef4ea0fe6af7e8b4db1834edb656cf19465f2e9356fdb7f650df0754e87fbb08750d9d0 assets:precompile

# Expose a volume so that nginx will be able to read in assets in production.
VOLUME ["$INSTALL_PATH/public"]

# Install and configure nginx
RUN apt-get install -y nginx
RUN rm -rf /etc/nginx/sites-available/default
ADD nginx/nginx.conf /etc/nginx/nginx.conf
ADD nginx/.htpasswd.staging /etc/nginx/.htpasswd
ADD nginx/.admin.htpasswd /etc/nginx/.admin.htpasswd

# The default command that gets ran will be to start the Unicorn server.
# CMD bundle exec unicorn -c config/unicorn.rb
CMD ["foreman", "start"]

# CMD RAILS_ENV=production bundle exec unicorn -c config/unicorn.rb
