FROM openjdk:8

MAINTAINER mmsandakov@gmail.com

# Prepare environment
RUN apt-get update && apt-get install -y git ant build-essential gcc python python-dev
RUN useradd -m -s /bin/false buck
RUN mkdir /buck && chown buck /buck
USER buck

# Build buck
RUN git clone https://github.com/facebook/buck.git /buck/
RUN cd /buck && ant

USER root
RUN ln -sf /buck/bin/buck /usr/bin/

# Use target directory as working directory
RUN mkdir /target
WORKDIR /target

ENTRYPOINT ["/usr/bin/buck"]