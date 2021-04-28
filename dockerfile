FROM node:12-slim
WORKDIR /usr/src/app
COPY package*.json ./
RUN yarn install
EXPOSE 3000
COPY . ./
CMD [ "yarn", "serve" ]