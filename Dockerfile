#latest-build
FROM node:boron-jessie
RUN echo deb http://http.debian.net/debian stretch main >> /etc/apt/sources.list

# Update and install packages
RUN apt-get update && \
    apt-get install -y -t stretch python python-dev python-pip python-virtualenv zip rsync openjdk-8-jdk && \
    rm -rf /var/lib/apt/lists/*

ENV JAVA_HOME /usr/lib/jvm/java-8-openjdk-amd64/
ENV PATH="$JAVA_HOME/bin:$PATH"

# Create app directory
WORKDIR /usr/src/app

# Install app dependencies
COPY package.json .

RUN npm install

# Install python dependencies
COPY requirements.txt /usr/src/app/
RUN pip install -r /usr/src/app/requirements.txt

# Install Hetzner CLI
RUN git clone https://github.com/Homebrew/brew ~/.linuxbrew/Homebrew && mkdir ~/.linuxbrew/bin && ln -s ~/.linuxbrew/Homebrew/bin/brew ~/.linuxbrew/bin && eval $(~/.linuxbrew/bin/brew shellenv)
RUN brew install hcloud
# Bundle app source
COPY . .

EXPOSE 3001
CMD [ "npm", "start" ]
