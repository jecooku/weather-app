# Use official Node.js image as a base image
FROM node:18

# Set working directory inside the container
WORKDIR /app

# Copy package.json and package-lock.json (or yarn.lock)
COPY package.json package-lock.json ./

# Install dependencies
RUN npm install

# Copy the rest of the React app's code into the container
COPY . ./

# Expose the port React will run on
EXPOSE 3001

# Command to start the React app
CMD ["npm", "start"]
