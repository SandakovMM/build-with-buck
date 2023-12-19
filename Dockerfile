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

USER root

RUN ln -sf /buck/bin/buck /usr/bin/

# Use runner user to make sure we work as files owner (default github action user)
RUN adduser --disabled-password --gecos "" --uid 1001 runner \
    && groupadd docker --gid 123 \
    && usermod -aG sudo runner \
    && usermod -aG docker runner \
    && echo "%sudo   ALL=(ALL:ALL) NOPASSWD:ALL" > /etc/sudoers \
    && echo "Defaults env_keep += \"DEBIAN_FRONTEND\"" >> /etc/sudoers

USER runner

ENV HOME /home/runner
ENV PYENV_ROOT $HOME/.pyenv
ENV PATH $PYENV_ROOT/shims:$PYENV_ROOT/bin:$PATH

# Make sure we have exactly python 3.6 installed. Because I need this version of python for my projects.
# You could freely change it to any other version. Or remove pyenv at all if you fine
# with the default python version (3.9 for this container).
# ToDo: find a way to configure python version from an action configuration
RUN curl https://pyenv.run | bash
RUN pyenv install 3.6.12
RUN pyenv global 3.6.12

USER root
# A little hack to avoid all tihs .pyenv pathes in .buckconfig files. Looks not so bad I suppose
RUN ln -sf $HOME/.pyenv/shims/python3.6 /usr/bin/python3.6

USER runner

ENTRYPOINT ["/usr/bin/buck"]