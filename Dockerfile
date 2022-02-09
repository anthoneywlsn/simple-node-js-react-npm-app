FROM jenkins/jenkins:2.319.2-jdk11
WORKDIR /simplilearn-capstone
ENV PATH /simplilearn-capstone/simple-node-js-react-npm-app/latest
USER root
RUN apt-get update && apt-get install -y lsb-release
RUN curl -fsSLo /usr/share/keyrings/docker-archive-keyring.asc \
  https://download.docker.com/linux/debian/gpg
RUN echo "deb [arch=$(dpkg --print-architecture) \
  signed-by=/usr/share/keyrings/docker-archive-keyring.asc] \
  https://download.docker.com/linux/debian \
  $(lsb_release -cs) stable" > /etc/apt/sources.list.d/docker.list
RUN docker --version
RUN ./aws/install
USER jenkins
RUN usermod -aG docker ${USER}
RUN usermod -aG docker jenkins
RUN jenkins-plugin-cli --plugins "blueocean:1.25.2 docker-workflow:1.27"
