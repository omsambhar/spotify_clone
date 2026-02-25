# syntax=docker/dockerfile:1

ARG NODE_VERSION=23.11.0

# -------------------- Build stage --------------------
FROM node:${NODE_VERSION}-alpine AS build

WORKDIR /usr/src/app

# Install dependencies
COPY package.json package-lock.json ./
RUN npm ci

# Copy source
COPY . .

# Build Vite app
RUN npm run build

# -------------------- Runtime stage --------------------
FROM nginx:alpine AS final

# Copy Vite build output
COPY --from=build /usr/src/app/dist /usr/share/nginx/html

# Optional: custom nginx config for SPA routing
# COPY nginx.conf /etc/nginx/conf.d/default.conf

EXPOSE 80

CMD ["nginx", "-g", "daemon off;"]
