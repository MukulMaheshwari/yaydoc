#latest-build
FROM node:boron-jessie
RUN echo deb http://http.debian.net/debian stretch main >> /etc/apt/sources.list 
RUN echo deb-src http://http.debian.net/debian stretch main >> /etc/apt/sources.list
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
RUN apt-get install build-essential curl file git
RUN su && apt-get update
RUN apt-get install sudo -y
RUN echo sh -c "$(curl -fsSL https://raw.githubusercontent.com/Linuxbrew/install/master/install.sh)"
ENV PATH=/home/linuxbrew/.linuxbrew/Homebrew/Library/Homebrew/vendor/portable-ruby/current/bin:$PATH
RUN echo 'eval $(/home/linuxbrew/.linuxbrew/bin/brew shellenv)' >>~/.bash_profile
RUN eval $(/home/linuxbrew/.linuxbrew/bin/brew shellenv)
RUN brew install hcloud
# Bundle app source
COPY . .

EXPOSE 3001
CMD [ "npm", "start" ]
