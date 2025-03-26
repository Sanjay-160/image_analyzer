# Use an official Node.js image as the build stage
FROM node:20 AS build
 
# Set the working directory
WORKDIR /app
 
# Copy package.json and package-lock.json
COPY package.json package-lock.json ./
 
# Install dependencies with legacy-peer-deps
RUN npm install --legacy-peer-deps
 
# Copy the rest of the project
COPY . .
 
# Build the React app
RUN npm run build
 
# Use Nginx for serving the app
FROM nginx:alpine
 
# Copy built files from build stage
COPY --from=build /app/build /usr/share/nginx/html
 
# Expose port 80
EXPOSE 80
 
# Start Nginx
CMD ["nginx", "-g", "daemon off;"]
