# Fetching the minified node image
FROM node:slim

# Setting up the work directory
WORKDIR /usr/src/app

# Copying all project the files
COPY . .

# Installing dependencies
RUN npm install

# Exposing server port
EXPOSE 3000

# Starting our application
CMD [ "node", "index.js" ]