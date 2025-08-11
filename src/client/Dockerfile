# Build Stage
FROM node:22.16.0-alpine AS build
WORKDIR /app
COPY package*.json yarn.lock ./

RUN yarn install
COPY . .
RUN yarn build

# Production Stage
FROM nginx:stable-alpine AS production
COPY --from=build /app/dist /usr/share/nginx/html
EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]