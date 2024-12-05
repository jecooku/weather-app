# Use the official Ruby image as a base image
FROM ruby:3.0.7

# Install dependencies, including jemalloc, Redis tools, and nodejs/npm
RUN apt-get update && \
    apt-get install -y \
    curl \
    gnupg2 \
    redis-tools \
    build-essential \
    && rm -rf /var/lib/apt/lists/*

# Install jemalloc
RUN curl -L https://github.com/jemalloc/jemalloc/releases/download/5.2.1/jemalloc-5.2.1.tar.bz2 | tar -xj && \
    cd jemalloc-5.2.1 && \
    ./configure && \
    make && \
    make install

# Update the shared library cache
RUN ldconfig

# Install Node.js (latest LTS) and npm
RUN curl -sL https://deb.nodesource.com/setup_16.x | bash - && \
    apt-get install -y nodejs

# Set the working directory in the container
WORKDIR /app

# Install Bundler and Rails Gems
COPY Gemfile Gemfile.lock ./
RUN gem install bundler && bundle install

# Install npm dependencies for the React app
COPY ui/package.json ui/package-lock.json ./ui/
WORKDIR /app/ui
RUN npm install

# Copy the rest of the Rails app code into the container
WORKDIR /app
COPY . .

# Expose the Rails app port and React app port
EXPOSE 3000 3001

# Remove the server.pid file if it exists before starting Rails
RUN rm -f tmp/pids/server.pid

# Set environment variables to use jemalloc as the memory allocator
ENV LD_PRELOAD=/usr/local/lib/libjemalloc.so

# Use a shell command to remove server.pid and then start Rails server
ENTRYPOINT ["sh", "-c", "rm -f tmp/pids/server.pid && bundle exec rails server -b '0.0.0.0'"]
