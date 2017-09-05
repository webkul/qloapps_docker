# qloapps_docker
Dockerize version of Qloapps, an open source Hotel Commerce Solution
Qlo booking system allow hotel owners to manage their online & ondesk bookings by launching an Hotel Booking Website. Owner can synchronize their rooms, rates and availabilty on single platform. It is a simple, elegant and astonishing booking system that help end users to book multiple rooms from multiple hotels in single cart.

In our architecture, we are using:

> Apache-2.4.7

> PHP-5.5

> Mysql-5.6

To setup qloapps dockerize version on your server or system, follow these instructions-:

1. Install Docker and its dependencies according to your OS version for more details check -: https://docs.docker.com/engine/installation/linux/ubuntulinux/.

2. Pull qloapps docker image from docker hub by executing command "docker pull webkul/qloapps:latest".

3. After pulling the image, run your qloapps container by specifying ports "docker run -d -p 80:80 -p 3306:3306 webkul/qloapps_docker:latest". For example in this command your Host port 80 is linked with the docker port 80 running apache and Host port 3306 is linked with the docker port 3306 running MySQL, you can change the ports of your Host as per your requirements.

4. Your last command will provide you a unique hash_value or container_ID which is linked with your running container.

5. Now you need to know your mysql credentials for that run "docker logs container_ID", you can also find out your docker container_ID by running command "docker ps"

6. After getting your Mysql credentials open your qloapps on your Host system browser "http://your_host_system_ip".

7. Follow the installtion steps.

8. In Mysql Details host will be your HOST System or Server IP for ex-: "X.X.X.X:3306" and database is "qloapps", database user is "qloappsuser" and password will be randomly generated and will be saved in /var/log/check.log.

9. To get your database user password, run command: "docker exec -i your_container_id cat /var/log/check.log"

10. There is no root password yet for mysql-server. You can set it by yourself. Also, if you wish to make changes in database credentials then download this repository and make changes in mysql.sh.

11. To check your backoffice URL, go to server root directory and check the admin directory name string. You would be needed to rename the admin directory. Then go to updated backoffice URL.

12. After qloapps installation, remove "install" directory from server root directory inside the container. Run command:

> docker exec -ti your_container_id bash

> cd /var/www/html//hotelcommerce-1.1.0/

> rm -r install


Note -: If you are running any other services on your host at port 80 and 3306 then you have to mention other ports in step 3.
