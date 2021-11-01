FROM node:12-alpine AS base
WORKDIR /app

from base AS dependencies
COPY package*.json ./
RUN npm install

FROM dependencies as build
COPY . .
RUN npm run build

FROM node:12-alpine as release
WORKDIR /app
COPY --from=dependencies /app/package.json ./
RUN npm install --only=production
COPY --from=build /app/dist ./dist

USER node
ENV PORT=8080
EXPOSE 8080

CMD ["node", "dist/main.js"]
