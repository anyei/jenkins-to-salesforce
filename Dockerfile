FROM jenkins/jenkins:latest

MAINTAINER anyei <angelyoelroblesmercedes@gmail.com>

#Star me or leave any comment here: https://hub.docker.com/r/anyei/jenkins-to-salesforce/
#Please report issues here : https://github.com/anyei/jenkins-to-salesforce/issues


#Changing to root, it was running on jenkins user context
USER root


#INSTALLING ANT

RUN mkdir -p /var/ant_home

ADD http://ftp.wayne.edu/apache/ant/binaries/apache-ant-1.10.6-bin.zip /var/ant_home/apache-ant-1.10.6-bin.zip 

RUN unzip /var/ant_home/apache-ant-1.10.6-bin.zip -d /var/ant_home && rm /var/ant_home/apache-ant-1.10.6-bin.zip

ENV ANT_HOME=/var/ant_home/apache-ant-1.10.6

ENV PATH=${PATH}:${ANT_HOME}/bin

#In case anyone is intersted, the following command would retreive additional ant's plugins
#RUN ant -f ${ANT_HOME}/fetch.xml -Ddest=sytem

#INSTALLING ANT BUILD.XML TEMPLATE FOR SALESFORCE PLUGIN

RUN mkdir -p /var/ant_home/build_template/

ADD https://raw.githubusercontent.com/anyei/jenkins-to-salesforce/jenkins_jenkins_docker_upgrade/tools/buildTemplate.xml /var/ant_home/build_template/build_template.xml

ENV SFDC_BUILD_TEMPLATE=/var/ant_home/build_template/

ENV PATH=${PATH}:${SFDC_BUILD_TEMPLATE}

#INSTALL add_run_tests.sh

ADD https://raw.githubusercontent.com/anyei/jenkins-to-salesforce/jenkins_jenkins_docker_upgrade/tools/add_run_tests.sh /usr/bin/add_run_tests.sh

RUN chmod +x /usr/bin/add_run_tests.sh

RUN echo "alias get_build_template='add_run_tests.sh'" >> /etc/bash.bashrc


#INSTALLING SALESFORCE ANT PLUGIN
RUN mkdir ${ANT_HOME}/lib/x

ADD https://gs0.salesforce.com/dwnld/SfdcAnt/salesforce_ant_48.0.zip ${ANT_HOME}/lib/x/salesforce_ant_48.0.zip
#https://na17.salesforce.com/dwnld/SfdcAnt/salesforce_ant_34.0.zip ${ANT_HOME}/lib/x/salesforce_ant_34.0.zip

RUN unzip ${ANT_HOME}/lib/x/salesforce_ant_48.0.zip -d ${ANT_HOME}/lib/x && cp ${ANT_HOME}/lib/x/ant-salesforce.jar ${ANT_HOME}/lib/ant-salesforce.jar && rm -rf ${ANT_HOME}/x

RUN chown -R jenkins "${ANT_HOME}" /usr/bin/add_run_tests.sh

#Changing to jenkins user
USER jenkins

