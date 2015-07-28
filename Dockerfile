# This is Ruby centric, not Rails centric.
# and focuses on getting basic env setup for Dev and extending into Prod
# with some refactoring
# presently uses 'root' user so DO NOT USE THIS IN PROD AS IS

FROM ruby:2.2
MAINTAINER Hank Beaver


# get basics running
RUN apt-get update -qq && apt-get install -y build-essential \
    libpq-dev \
    libqt4-dev \
    libqt4-webkit \
    libreadline-dev \
    libssl-dev \
    libxml2-dev \
    libxslt1-dev \
    nodejs \
    nodejs-legacy \
    npm \
    vim 
    xvfb \
    zlib1g-dev \

# Phantom JS
RUN npm install -g phantomjs

RUN apt-get clean

RUN adduser --system --ingroup staff deploy
#
# # Setup repos dir.
ENV DEPLOY_HOME /root
ENV APP_HOME /app

# to add later
#RUN chown deploy:staff -R $DEPLOY_HOME
#RUN chown deploy:staff -R $APP_HOME


# must use root for now - OSX folder sharing with VM
USER root 
WORKDIR $DEPLOY_HOME

# rbenv - to manage multiple ruby versions
# does not install a specific version, the app Dockerfile should add/manager via .ruby-version and install.
RUN git clone https://github.com/sstephenson/rbenv.git $DEPLOY_HOME/.rbenv
RUN git clone https://github.com/sstephenson/ruby-build.git $DEPLOY_HOME/.rbenv/plugins/ruby-build
RUN $DEPLOY_HOME/.rbenv/plugins/ruby-build/install.sh
ENV PATH $DEPLOY_HOME/.rbenv/bin:$PATH
RUN echo 'export PATH="$HOME/.rbenv/bin:$PATH"' >> .bashrc
RUN echo 'eval "$(rbenv init -)"' >> .bashrc
ENV CONFIGURE_OPTS --disable-install-doc
RUN echo 'gem: --no-rdoc --no-ri' >> .gemrc


# now install bundler and other core Gems as root for a second
USER root
ENV CONFIGURE_OPTS --disable-install-doc
RUN echo 'gem: --no-rdoc --no-ri' >> /.gemrc
RUN gem install bundler --version=1.10.6
#RUN chown deploy:staff -R /usr/local/bundle/

#USER deploy
