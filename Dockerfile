FROM alpine:latest

LABEL mantainer="ing.norville@gmail.com"

# Install packages
RUN apk update && apk upgrade && apk add \
        vim \
        wget \
        curl \
        sudo \
        python \
        openssh

# Add default user
RUN adduser --disabled-password --gecos "" $DEF_USER && \
# Add default user to sudo group
    adduser $DEF_USER sudo && \
# Disable password for sudo group
    echo '%sudo ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers

# Enable sshd
RUN rc-update add sshd && /etc/init.d/sshd start

# Configure user env
ENV DEF_USER dummy
USER $DEF_USER
ENV DEF_WDIR /home/$DEF_USER/dev
WORKDIR $DEF_WDIR/
RUN chmod 777 $DEF_WDIR/

# Install Anaconda
ENV ANA_VER 2019.10
RUN wget https://repo.anaconda.com/archive/Anaconda3-$ANA_VER-Linux-x86_64.sh && \
    bash Anaconda3-$ANA_VER-Linux-x86_64.sh && \
    rm Anaconda3-$ANA_VER-Linux-x86_64.sh
# Add conda to shell path
ENV PATH $DEF_WDIR/anaconda3/bin:$PATH
# Update anaconda
RUN conda update conda && conda update anaconda && conda update --all

# Configure Jupyter
RUN mkdir -p $DEF_WDIR/notebooks && \
    jupyter notebook --generate-config --allow-root

# Open ssh and jupyter ports
EXPOSE 22
EXPOSE 8888

CMD ["jupyter", "notebook", "--allow-root", "--notebook-dir=/home/ubuntu/notebooks", "--ip='*'", "--port=8888", "--no-browser"]
