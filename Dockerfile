 # Use an official Node.js image as the build stage
FROM node:20 AS build
 
# Set the working directory
WORKDIR /app
 
# Copy package.json and package-lock.json
COPY package.json package-lock.json ./
 
# Install dependencies
RUN npm install --legacy-peer-deps
 
# Copy the rest of the project
COPY . .
 
# Build the Vite app (output goes to /app/dist)
RUN npm run build
 
# Use Nginx for serving the app
FROM nginx:alpine
 
# Copy built files from the correct output directory
COPY --from=build /app/dist /usr/share/nginx/html
 
# Expose port 80
EXPOSE 80
 
# Start Nginx
CMD ["nginx", "-g", "daemon off;"]
