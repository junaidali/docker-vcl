# Running Apache VCL in docker container within Kubernetes

You will need the following setup before you can run apache VCL as a containerized application
1. [Docker](https://www.docker.com/get-docker)
2. [Docker Compose](https://docs.docker.com/compose/install/)
3. [Kubernetes](https://kubernetes.io/)

## Building Images
The images built need to be published to a remote repository that will be used to pull the image down for execution. The default image repositories uses [Dockerhub - Junaid](https://hub.docker.com/u/junaid/).

Update the docker-compose.yml file with the path of the image repository that will be used for pulling images at runtime within the kubernetes cluster. Update line # 26 and 39 with the settings that match your envioronment. To build the image
```
docker-compose build
```

## Pushing Images
To push the image to your image repository
```
docker push <image name> <tag>
e.g. docker push junaid/vcl-www k8s && docker push junaid/vcl-mgmt k8s
```

6. Access the vcl website at https://localhost/vcl and login with the default password adminVc1passw0rd
7. Set the admin user password (DO NOT skip this step):

    * Click User Preferences
    * Enter the current password: adminVc1passw0rd
    * Enter a new password
    * Click Submit Changes

8. The management node already has the vmware vsphere sdk installed. If you need other provisioning tools you will have to update the [Management Node Docker File](mgmt/Dockerfile) accordingly

# Debug Instructions
The VCL Docker environment can also be used for local development purposes. Docker allows mounting local volumes that can allow you to share your local project files directly in the running container, thus allowing to use your local editor/IDE for development. Additionally using [xdebug](https://xdebug.org/) based remote debugging capabilities allows to use an IDE like [Eclipse PDT](https://www.eclipse.org/pdt/) to write and debug code from your local PC without having to manage software dependencies and building it in a consistent way that is true deployable code.

## Setup IDE and PHP
Eclipse PDT is a nice freely available IDE for PHP development. You can download the current version of Eclipse PDT from [here](https://projects.eclipse.org/projects/tools.pdt/downloads)

You will need to have a local install of PHP for debugging purposes. You can download current PHP from [here](http://php.net/downloads.php)

You will also need to setup some of the libraries that are used within your PHP project on your computer for the IDE to work properly, e.g. code completion, debugging. PHP Unit is required for unit testing and can be installed from [here](https://phpunit.de/announcements/phpunit-5.html)


## Setup Project Directories
Download your code repositories onto your local computer. In my case I create a Projects directory within my home directory and create sub folder for VCL

```
mkdir ~/Projects/vcl/
```

Clone this repository

```
cd ~/Projects/vcl
git clone https://github.com/junaidali/docker-vcl.git
```

Switch to debug branch

```
cd ~/Projects/vcl/docker-vcl
git checkout -b debug
git pull origin debug
```

Clone the VCL Website directory from your source control system

```
cd ~/Projects/vcl
git clone https://github.com/junaidali/vcl-web.git web
```

## Update the xdebug configuration file
Xdebug allows you to debug your PHP web application. We need to setup xdebug to connect to the debugger running on your local computer. You will need to provide the IP of the computer where you run the debugger. Create a file within www/etc/php.d/xdebug.ini with following contents and replacing the YOUR_IP_ADDRESS_HERE with your computer's IP address:

```
; Enable xdebug extension module. Make sure the following path is correct depending upon your installation
zend_extension=/usr/lib64/php/modules/xdebug.so
xdebug.remote_enable=On
xdebug.remote_handler="dbgp"
xdebug.remote_mode="req"
xdebug.remote_port=9000
xdebug.remote_host="YOUR_IP_ADDRESS_HERE"
xdebug.profiler_output_dir=/tmp/php-xdebug
```

## Build containers
You will need to build your containers locally using the new xdebug configuration file.

```
docker-compose build
```

## Launch Database containers
You are now ready to launch the development environment. You can change the container environment variables using the [environment file](.\.env) file

```
cd ~/Projects/vcl/docker-vcl
docker-compose up -d db
```

For your current release of VCL, you will need the vcl.sql file that is provided in the mysql directory of the [download](https://vcl.apache.org/downloads/download.cgi)

Copy the vcl.sql file to your container

```
cd ~/Projects/vcl/docker-vcl
docker cp /Users/junaid/Projects/vcl/apache-VCL-2.5/mysql/vcl.sql dockervcl_db_1:/tmp/
```

Import the VCL database

```
cd ~/Projects/vcl/docker-vcl
docker-compose exec db sh
sh# mysql -uvcl -ps3cr3t vcl < /tmp/vcl.sql

where the vcl user's password is s3cr3t. it can be modified by changing the .env environment file
```

## Launch web container
You will need to copy the following files (that are excluded from git repository) into the .ht-inc directory of the vcl website. These files are available in [www](./www/) directory

```
secrets.php
conf.php
```

Launch the web container with the correct mount point for the website files.

```
docker-compose run -d -v /Users/junaid/Projects/iitvcl/web:/var/www/html --service-ports www

Update the /Users/junaid/Projects/iitvcl/web path to your local project path
e.g. /home/jdoe/Projects/vcl/web
```

Regenerate the keys

```
cd ~/Projects/vcl/docker-vcl
docker exec -it dockervcl_www_run_1 sh
sh# cd .ht-inc
sh# ./genkeys.sh
```

## Setup IDE's for development
1. Create a new Project from ~/Projects/vcl/web directory
2. Open your project in Eclipse PDT
3. In the main menu select Project->Properties
4. On the left side of the window select "PHP Debug" and then click on "Configure Workspace Settings"
5. On the "PHP Debugger" dropdown select Xdebug and click "Apply"
6. Click "Configure" to the right of Xdebug in the same window.
7. Select Xdebug and click "Configure".
8. On the "Accept remote session(JIT)" select "any" and click "OK". This is extremely important and this is where most people get stuck.
9. Add external dependencies for [PHP Unit](https://phpunit.de/getting-started/phpunit-5.html)
10. Setup new PHP server

Item | Value |
--- | --- |
Server Name | Localhost Docker
Base URL | https://localhost/
Document Root | BLANK
Debugger | XDebug
Port | 9000
Path Mapping | Manual - /vcl - /vcl


## Start Debugging
* Install the [Firefox Xdebug helper](https://addons.mozilla.org/en-US/firefox/addon/xdebug-helper-for-firefox/) if you are using Firefox. You will need this to start the debug session.
* Open Firefox and go to https://localhost/vcl/testsetup.php. Make sure all tests are passing.
* If you receive error about maintenance and cryptkey directories are not writable, perform the following fix
```
cd ~/Projects/vcl/docker-vcl
docker exec -it dockervcl_www_run_1 sh
sh# cd .ht-inc
sh# chown -R apache:apache maintenance/ cryptkey/
```
* Start Xdebug session by clicking the helper icon in the address bar. It should turn green to signify that Xdebug has been enabled. Next reload the page and it should launch Eclipse IDE in debug mode.
