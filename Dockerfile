# Use an official Ruby runtime as a parent image
FROM ruby:3.1.4

# Set the working directory in the container
WORKDIR /app

# Copy the Gemfile and Gemfile.lock to the container
COPY Gemfile Gemfile.lock ./

# Install the app dependencies
RUN bundle install

# Install Redis CLI tools
RUN apt-get update && \
    apt-get install -y redis-tools

# Copy the rest of the app's code to the container
COPY . .

# Specify the command to run your app
CMD ["ruby", "app/server.rb"]
