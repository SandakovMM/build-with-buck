FROM openjdk:8

MAINTAINER mmsandakov@gmail.com

# Prepare environment
RUN apt-get update && apt-get install -y git ant build-essential gcc python python-dev python3-distutils zlib1g-dev openssl libssl-dev
RUN useradd -m -s /bin/false buck
RUN mkdir /buck && chown buck /buck
USER buck

# Build buck
# We could just clode because I don't expect buck to be updated in this repository
# ToDo: move to buck2
RUN git clone https://github.com/facebook/buck.git /buck
RUN cd /buck && git checkout v2022.05.05.01 && ant

# We shoul return to root because github actions expects it
USER root

# Make sure we have exactly python 3.6 installed. Because I need this version of python for my projects.
# You could freely change it to any other version. Or remove pyenv at all if you fine
# with the default python version (3.9 for this container).
# ToDo: find a way to configure python version from an action configuration
RUN curl https://pyenv.run | bash
ENV PATH="/root/.pyenv/bin:$PATH"
RUN eval "$(pyenv init -)" && eval "$(pyenv virtualenv-init -)" && pyenv install 3.6.12 && pyenv global 3.6.12

RUN ln -sf /buck/bin/buck /usr/bin/

ENTRYPOINT ["/usr/bin/buck"]