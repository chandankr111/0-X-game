# Build stage
FROM node:20-alpine3.21 AS build
WORKDIR /app

# Update apk and install fixed libxml2 version before dependencies install
RUN apk update && apk add --no-cache libxml2=2.13.4-r6

COPY package*.json ./
RUN npm ci
COPY . .
RUN chmod +x ./node_modules/.bin/vite
RUN npm run build

# Production stage
FROM nginx:alpine
COPY --from=build /app/dist /usr/share/nginx/html
# Add nginx configuration if needed
# COPY nginx.conf /etc/nginx/conf.d/default.conf
EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]