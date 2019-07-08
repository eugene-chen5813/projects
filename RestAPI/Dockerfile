FROM node:10

# Creating app directory

RUN mkdir -p ~/node/app/node_modules && chown -R node:node ~/node/app

WORKDIR ~/node/app

COPY package*.json ./

USER node

RUN npm install

COPY --chown=node:node . .

EXPOSE 8080

CMD ["node", "server.js"]