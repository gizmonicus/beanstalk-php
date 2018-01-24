# beanstalk-php
PHP image for testing EB apps locally

# Environment setup

## Docker
Before running this image, you will need a working version of Docker installed. Follow the instructions here https://docs.docker.com/engine/installation/ for your operating system.

## Docker Compose
You can run the image manually if you would like using docker commands, but for convenience, I have added a docker-compose.yaml file that handles mappings of ports, volumes, and environment variables for you. This way you can run and restart this image with a few shortcut commands. You will need to install docker-compose to take advantage of these features. It is best to install docker-compose through pip (you may need to install python-pip through your package manager), but you may also be able to install it through your operating system's package manager. For more details, see https://docs.docker.com/compose/install/

## UID/GID
When working with docker, sometimes you will have need to mount a directory into the container in a way that it can be written to. This can pose a challenge because the container has its own UID/GID space that is baked into the image on build. So if apache has a UID of 33 in the container, that may be some entirely different user on the host OS. To overcome this, the run.sh script looks for two environment variables: MYUID and MYGID. This will override the apache user's UID and GID. By setting these variables to your own UID/GID will allow the apache user to effectively have your permissions on the host OS.

# Working with docker-compose

## Edit docker-compose.yaml
Before you begin, you will want to map your code repository to the /var/www/html directory as well as add any necessary environment variables by editing the docker-compose-$VERSION.yaml.example file and saving it to docker-compose.yaml. There is a .gitignore statement that will prevent docker-compose.yaml from being committed in the repo. If you will be working with both PHP5 and PHP7, you can create two different docker-compose-$VERSION.yaml files and refer to them with ```docker-compose -f docker-compose-$VERSION.yaml``` when running any of the commands later in this document.

## Run the image
Note that all of these commands should be run from the root of this Git repo.

* To run in foreground mode
```
docker-compose up
```

* To run in background mode
```
docker-compose up -d
```

* Running /bin/bash in the container (i.e. how to "SSH" in). Note that docker-compose files can be made up of multiple containers. When running commands like `docker-compose up`, you don't have to identify which container to run since it will start all of them at the same time. However, when using exec, you must specify which one to exec the command in. In this case 'php' is the service name.
```
# If you are using the php5 image, use this command
docker-compose exec php5 /bin/bash

# If you are using the php7 image, use this command
docker-compose exec php7 /bin/bash
```

* To get the status of a running docker-compose service
```
docker-compose ps
```

## Stopping and restarting
* Stopping a container
```
docker-compose stop
```

* Starting a container
```
docker-compose start
```

* Forcing a restart
```
docker-compose restart
```

* To stop and remove all containers (useful when you want to pull the latest image and start the application again)
```
docker-compose down
```

* To pull the latest version of this container
```
docker-compose pull
```

## Building the image
You have two options for building. The easiest option would be to modify the Dockerfile and commit/push the changes. This will trigger a Dockerhub build that can take anywhere from 10-20 minutes to complete. If you are impatient, and would like to try the build locally before committing the changes, run the following command to trigger a build locally.
```
docker-compose build
```
It's best to try the build locally first to make sure you don't run into syntax errors or problems with the build before pushing it to Github.

## Troubleshooting
To restart the docker daemon on Linux, use one of the following commands:
```
# On systems with systemd init system
systemctl restart docker

# On systems with upstart or SysVinit
service docker restart
```
