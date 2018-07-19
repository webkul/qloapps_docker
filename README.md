## WHAT IS QLOAPPS

Qloapps is an open source, free and customizable online reservation system. You can launch a userfriendly site and can manage online as well as offline bookings. Using this you can easily launch your hotel booking website and even manage your offline booking too. This package is developed on top of Prestashop 1.6.

## DOCKERIZING QLOAPPS

Docker is an open-source project that can be integrated with almost all the applications allowing scope of isolation and flexibility. It can be integrated with  Qloapps.

## PREREQUISITES

> Install lastest avaiable Docker version and its dependencies according to your OS version. Refer to link https://docs.docker.com/install/linux/docker-ce/ubuntu/#prerequisites. 

> Check if your user has access privileges to run docker commands.

#### NOTE TO THE USER

> Mysql root password, Mysql Database name and SSH user password is not set. Users have to pass *Mysql root password, database name, and SSH user password* as arguments while running the docker image.

> Default SSH user is created as "qloapps" while building this image. You can change user argument in Dockerfile and rebuild the docker image for your own use.

> 


## DOCKERIZING QLOAPPS

In the dockerized Qloapps architecture, we are using:

> Ubuntu 14.04

> Mysql Server 5.6

> PHP 5.6

> SSH Server

To begin with:

1. Pull qloapps docker image from docker hub by running command "docker pull webkul/qloapps:latest".

2. After pulling the image, run your qloapps container by specifying ports and arguments as: 

> docker run -tidp 80:80 -p 3306:3306 -p 2222:22 -name qloappsv111 -e USER_PASSWORD=qloappsuserpassword -e MYSQL_ROOT_PASSWORD=myrootpassword -e MYSQL_DATABASE=mydatabase webkul/qloapps_docker:latest

3. In the above command, your Host port 80 is linked with the docker port 80 running apache and Host port 3306 is linked with the docker port 3306 running MySQL, you can change the ports of your Host as per your requirements. Also, your SSH port 2222 is mapped with docker port 22 running SSH server. Please ensure that no other services are running on these host ports.

4. Mention your mysql root password, database name, 'qloapps' user password in arguments MYSQL_ROOT_PASSWORD, MYSQL_DATABASE and 
USER_PASSWORD respectively.

5. Check your running container using command *docker ps*. It will display you a container running with name qloappsv111.

6. Now go to your browser and hit your IP or domain name and start qloapps installation process

7. After qloapps installation, remove "install" directory from server root directory inside the container. Run command:

> docker exec -i qloappsv111 rm -rf /home/qloapps/www/hotelcommerce/install .

8. On clicking on backoffice URL, you will be promped to rename your backoffice URL. Go to running docker container and change the name of admin directory as mentioned.

9. To access your qloapps files and directories, you can SSH in your docker container as:

> ssh qloapps@mention_your_ip -p 2222

Note -: If you are running any other services on your host at port 80, 22 and 3306 then you have to mention other ports in step 2.

## GETTING SUPPORT

If you have any issues, contact us at support@webkul.com or raise ticket at https://webkul.uvdesk.com/


Thank you.
