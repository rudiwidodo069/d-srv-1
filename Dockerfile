FROM node:alpine AS BUILD

WORKDIR /usr/app

COPY package.json .
COPY . .

RUN yarn install
RUN yarn build

FROM node:alpine AS DEPS

WORKDIR /usr/app

COPY package.json .

RUN yarn install --production

FROM node

WORKDIR /usr/app

COPY --from=BUILD /usr/app/build ./build
COPY --from=DEPS /usr/app/node_modules ./node_modules

RUN yarn install

EXPOSE 8000

CMD [ "node","build/index.js" ]