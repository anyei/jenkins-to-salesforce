# jenkins-to-salesforce

Simple jenkins image with Force.com Migrations tool api 48.

Please report any issues or comments here:
https://github.com/anyei/jenkins-to-salesforce/issues

## Features
Tools needed to make deployments to salesforce.com included in this image:
* Force.com Migrations Tool ([official resources]( https://developer.salesforce.com/page/Force.com_Migration_Tool ))
* Custom script for easy test class listing and base build.xml template

#### plugins installed
NONE

## Usage

This is the basic command to start jenkins:
```sh
$ docker run -p 8080:8080 anyei/jenkins-to-salesforce
```
This will store all jenkins data and configuration in /var/jenkins_home. You can make that a persistent volume:

```sh
$ docker run --name jenkins-sfdc -p 8080:8080 -v /var/jenkins_home anyei/jenkins-to-salesforce
```

You can bind volume from host and container: 
The jenkins user in container (jenkins user - uid 102, same as base jenkins image) must have access to /usr/back/jenkins:

```sh
$ docker run -p 8080:8080 -v /usr/back/jenkins:/var/jenkins_home anyei/jenkins-to-salesforce
```

You can do it all in one command too : 
```sh
$ docker run --name jenkins-sfdc -p 8080:8080 -p 50000:50000 -v /usr/back/jenkins:/var/jenkins_home -d anyei/jenkins-to-salesforce
```

Please refer to jenkins official usage for a more complete explanation on the rest of jenkins matter: https://hub.docker.com/r/jenkins/jenkins

### Jenkins initial screen asking for password
Latest versions of jenkins asks for a password the very first time you load the page, you will have to get it from the server where is running (in this case from the docker running conainer):
```sh
$ docker exec -it jenkins-sfdc /bin/bash
```
Then you should be able to cat command to display the password from the path jenkins is asking from:
```sh
$ cat path/to/file/jenkins/is/asking
```

### Public key authentication with git
If you have a jenkins job setup with git plugin, the best way to authenticate against the server where the target repository lives is with a public key. Jenkins runs as jenkins user within the container, therefore you'll need jenkin's user public key.

Get inside the running container (we are assuming the containers name is jenkins-sfdc):
```sh
$ docker exec -it jenkins-sfdc /bin/bash 
```
Then generate the rsa key pair :
```sh
$ ssh-keygen -t rsa 
```
Follow the instructions, leaving everything in blank and just hitting enter key will be enough for the public and private key to get generated. Assuming you did so, the public key should be located in the following file /var/jenkins_home/.ssh/id_rsa.pub. You can use that key later to authenticate to github, bitbucket or any other servers accepting this type of authentication. For more information and additional example go to [Github wiki page](https://github.com/anyei/jenkins-to-salesforce/wiki).

### ADDITIONAL - USE build_template.xml included in the image

If you want to use the build_template.xml included in this image and leverage the ability to include specific test class to run during the build/deployment:
* Add an execute shell build step and add the following lines:
```
get_build_template "${SFDC_BUILD_TEMPLATE}build_template.xml" "${WORKSPACE}/build.xml" "JPath_Test,AnotherTest"
```

The command **get_build_template** has three arguments:
* first is the template to use, in this case the path to the folder is available in the SFDC_BUILD_TEMPLATE environment variable.
* second is the resulting build.xml full path, in this case we are using the current workspace and the build.xml name (this is important as ant will be looking for something called build.xml by default).
* third, this is optional, if you want to run specific tests then you pass a comma separated list of test class names without spaces.

##### Now add your invoke ant build step and fill the properties so that the build.xml produced has inputs and the deployment can be performed, it should look like the following image.

![push to salesforce](https://github.com/anyei/jenkins-to-salesforce/raw/master/images/pushToSfdc.PNG)
Leave "Build File" field empty as the above image shows, it is implicitly defaulted to build.xml which we are already producing.

This are the list of build properties used by the "push" ant command from the build.xml:
* sf.user_name
* sf.password
* sf.session_id
* sf.test_level               default value is **RunLocalTests**
* sf.ignore_warnings          default value is **true**
* sf.check_only               default value is false
* sf.target_build_folder      default value is src
* sf.poll_wait_millis         default value is 10000
* sf.server_url               default value is https://test.salesforce.com
* sf.max_poll                 default value is 2000

Almost all of these parameters corresponds to the ant migration tool.
**sf.target_build_folder** is the folder where you have your package.xml.

### Documentation
You can find more about jenkins image in the official [docker repository](https://hub.docker.com/r/jenkins/jenkins).

### Issues
Let's keep this in [Github](https://github.com/anyei/jenkins-to-salesforce/issues).

### Contributing

You are invited to contribute, let's keep in touch in [Github](https://github.com/anyei/jenkins-to-salesforce)


