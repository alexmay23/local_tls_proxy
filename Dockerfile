# Use the official Nginx image as the base
FROM nginx:alpine

# Remove the default Nginx configuration
RUN rm /etc/nginx/conf.d/default.conf

# Copy custom Nginx configuration
COPY default.conf /etc/nginx/conf.d/default.conf

# Copy SSL certificates into the container
COPY certs /etc/nginx/certs
