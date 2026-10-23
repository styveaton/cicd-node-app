FROM node:20

WORKDIR /app

COPY package*.json ./

RUN npm install

COPY . .

EXPOSE 4000

CMD ["node", "index.js"]


Créer :

nano .dockerignore


Ajouter :

node_modules
npm-debug.log
.git
.gitignore
