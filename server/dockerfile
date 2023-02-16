#define build-test stage - docker multistage pipeline
FROM node:12 as build-test          

#create app directory
WORKDIR /app

#install dependencies
COPY package*.json ./

RUN npm install

COPY . .

RUN npm test
    
# run lean image
FROM node:12-alpine as run    

#create app directory
WORKDIR /app

#install dependencies
COPY package*.json ./

RUN npm install

COPY . .

EXPOSE 3000

CMD ["node","index.js"]

# Writing docker file changes here
#docker run -p 4000:3000 -d austinabro321/node_greeting
#docker run -p 5432:5432 -v /postgres-data:/var/lib/postgresql/data -e POSTGRES_PASSWORD=password -d postgres:13.1-alpine