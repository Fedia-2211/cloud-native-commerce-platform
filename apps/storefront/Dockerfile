FROM node:18-alpine
WORKDIR /app
RUN npm init -y && npm install express node-fetch@2
COPY server.js .
EXPOSE 3000
CMD ["node", "server.js"]
