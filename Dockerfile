FROM python:3.7-alpine
MAINTAINER Aleksandar Tisma

#Run in unbufferd mode and it does not allow python to buffer outputs
ENV PYTHONUNBUFFERD 1

#Copies dependencies to our image
COPY ./requirements.txt /requirements.txt
#Uses package and updates
RUN apk add --update --no-cache postgresql-client
#Installing tmp dependecies that we will delete later
RUN apk add --update --no-cache --virtual .tmp-build-deps \
      gcc libc-dev linux-headers postgresql-dev
#Instal dependencies to our image
RUN pip install -r /requirements.txt
#Deleting dependecies from above
RUN apk del .tmp-build-deps

#Creates a directory app and switches to it so everything we run, we
#run it from working directory, and every time we run docker, our app
#folder will be copied to workdir
RUN mkdir /app
WORKDIR /app
COPY ./app /app

#Creates an user that can only run our aplication
RUN adduser -D user
USER user
