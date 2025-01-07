# Use an official Node.js runtime as the base image
FROM nginx

# Set the working directory in the container
WORKDIR /usr/share/nginx/html

# Copy the rest of the application code
COPY . .

# Expose the application port

EXPOSE 80
