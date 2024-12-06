# Use the official Ruby image as a base image
FROM ruby:3.0.7-alpine

# Install production dependencies, including jemalloc, Node.js, and essential libraries
RUN apk add --no-cache \
    build-base \
    libxml2-dev \
    libxslt-dev \
    postgresql-dev \
    curl \
    redis \
    nodejs \
    npm \
    && rm -rf /var/cache/apk/*

# Install jemalloc
RUN curl -L https://github.com/jemalloc/jemalloc/releases/download/5.2.1/jemalloc-5.2.1.tar.bz2 | tar -xj && \
    cd jemalloc-5.2.1 && \
    ./configure && \
    make && \
    make install

# Update the shared library cache
RUN ldconfig

# Set the working directory in the container
WORKDIR /app

# Install Bundler and Rails Gems
COPY Gemfile Gemfile.lock ./
RUN gem install bundler && bundle install --without development test

# Install npm dependencies for the React app
COPY ui/package.json ui/package-lock.json ./ui/
WORKDIR /app/ui
RUN npm install --production

# Precompile Rails assets for production
WORKDIR /app
RUN RAILS_ENV=production bundle exec rake assets:precompile

# Remove any development-specific files (e.g., server.pid)
RUN rm -f tmp/pids/server.pid

# Expose the Rails app and React app ports
EXPOSE 3000 3001

# Set environment variables to use jemalloc as the memory allocator
ENV LD_PRELOAD=/usr/local/lib/libjemalloc.so

# Set the default environment for Rails
ENV RAILS_ENV=production

# Use a shell command to remove server.pid and start the Rails server
ENTRYPOINT ["sh", "-c", "rm -f tmp/pids/server.pid && bundle exec rails server -b '0.0.0.0'"]
