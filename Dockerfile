# Stage 1: Build the application
FROM node:20-alpine as builder
 
WORKDIR /app
 
# Copy package files first for better layer caching
COPY package.json package-lock.json* ./
 
# Install dependencies
RUN npm install
 
# Copy the rest of the application
COPY . .
 
# Build the application
RUN npm run build
 
# Stage 2: Serve the application
FROM nginx:alpine
 
# Copy the build output from the builder stage
COPY --from=builder /app/dist /usr/share/nginx/html
 
# Custom nginx configuration for port 8080
RUN echo "server { \
    listen 8080; \
    server_name localhost; \
    location / { \
        root /usr/share/nginx/html; \
        index index.html; \
        try_files \$uri \$uri/ /index.html; \
    } \
}" > /etc/nginx/conf.d/default.conf
 
# Expose port 8080
EXPOSE 8080
 
# Start nginx
CMD ["nginx", "-g", "daemon off;"]]
