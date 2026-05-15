FROM node:18-alpine
WORKDIR /app
COPY .npmrc ./
COPY package.json ./
RUN npm install --production
COPY server.js ./
EXPOSE 3000
USER node
CMD ["node", "server.js"]
