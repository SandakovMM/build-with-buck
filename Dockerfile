FROM openjdk:8

MAINTAINER mmsandakov@gmail.com

# Prepare environment
RUN apt-get update && apt-get install -y git ant build-essential gcc python python-dev
RUN useradd -m -s /bin/false buck
RUN mkdir /buck && chown buck /buck
USER buck

# Build buck
RUN git clone https://github.com/facebook/buck.git /buck/
RUN CURRENT_DIR=`pwd`
RUN cd /buck && ant

# We shoul return to root because github actions expects it
USER root
RUN ln -sf /buck/bin/buck /usr/bin/

RUN cd $CURRENT_DIR
ENTRYPOINT ["/usr/bin/buck"]