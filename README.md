# Running Apache VCL in docker container

You will need the following setup before you can run apache VCL
1. [Docker](https://www.docker.com/get-docker)
2. [Docker Compose](https://docs.docker.com/compose/install/)


To run apache VCL in docker containers perform the following steps:

1. Clone this repository onto a local folder
2. Change to the folder where you downloaded this repository
3. Update .env file with MYSQL_PASSWORD you will like to use
4. Launch containers using docker-compose

```
    docker-compose up -d
```

5. Check if the containers launched correctly

```
    docker-compose ps
```

6. Access the vcl website at https://localhost/vcl and login with the default password adminVc1passw0rd
7. Set the admin user password (DO NOT skip this step):

    * Click User Preferences
    * Enter the current password: adminVc1passw0rd
    * Enter a new password
    * Click Submit Changes

8. The management node already has the vmware vsphere sdk installed. If you need other provisioning tools you will have to update the [Management Node Docker File](mgmt/Dockerfile) accordingly
