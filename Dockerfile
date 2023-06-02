FROM openjdk:8

MAINTAINER mmsandakov@gmail.com

# Prepare environment
RUN apt-get update && apt-get install -y git ant build-essential gcc python python-dev python3-distutils
RUN useradd -m -s /bin/false buck
RUN mkdir /buck && chown buck /buck
USER buck

# Build buck
# We could just clode because I don't expect buck to be updated in this repository
# ToDo: move to buck2
RUN git clone https://github.com/facebook/buck.git /buck/
RUN cd /buck && ant

# We shoul return to root because github actions expects it
USER root
RUN ln -sf /buck/bin/buck /usr/bin/

ENTRYPOINT ["/usr/bin/buck"]