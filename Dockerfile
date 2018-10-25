FROM centos:latest
MAINTAINER pardha p

RUN yum update -y &&\
    yum install -y git wget unzip
COPY jdk-8u191-linux-x64.rpm /root/jdk-8u191-linux-x64.rpm
RUN yum install -y /root/jdk-8u191-linux-x64.rpm
RUN yum install -y expect-devel
RUN mkdir -p /opt/staples/cicd-tools/Android 
RUN wget https://dl.google.com/android/repository/sdk-tools-linux-4333796.zip && unzip sdk-tools-linux-4333796.zip -d /opt/staples/cicd-tools/Android 
RUN chmod a+x /opt/staples/cicd-tools/Android 
RUN yum install -y openssh-server
RUN sed -i 's|session required   pam_loginuid.so|session  optional   pam_loginuid.so|g' /etc/pam.d/sshd 
RUN mkdir -p /var/run/sshd 
RUN useradd -u 1000 -m -s /bin/bash jenkins \
    && echo "jenkins:jenkins" | chpasswd \
    && chown -R jenkins /home/jenkins \
    && /usr/bin/ssh-keygen -A 
RUN chown -R jenkins /opt/staples/cicd-tools/Android
COPY license-accept.sh /root/license-accept.sh
RUN chmod a+x /root/license-accept.sh
ENV JAVA_HOME=/usr/java/jdk1.8.0_191-amd64
ENV PATH=$PATH:$JAVA_HOME/bin`
ENV ANDROID_HOME=/opt/staples/cicd-tools/Android
ENV PATH=$PATH:$ANDROID_HOME/tools:$ANDROID_HOME/platform-tools
RUN ./root/license-accept.sh 
RUN mkdir -p /var/run/sshd
# Standard SSH port
EXPOSE 22

CMD ["/usr/sbin/sshd", "-D"]

