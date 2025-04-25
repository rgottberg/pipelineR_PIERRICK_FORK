
# start from
FROM jenkins/jenkins:latest

USER root

# install linux dependencies and utilities (JENKINS)
RUN apt-get update -qq && apt-get install -y --no-install-recommends \
    software-properties-common \
    dirmngr \
    wget \
    ca-certificates \
    gnupg \
    software-properties-common \
    libpq-dev \
    libx11-dev \
    libcurl4-openssl-dev \
    libssl-dev \
    make \
    pandoc \
    libicu-dev \
    libxml2-dev \
    git


# Add the R repository and install R 4.4
RUN wget -qO- "https://cloud.r-project.org/bin/linux/ubuntu/marutter_pubkey.asc" | tee -a "/etc/apt/trusted.gpg.d/cran_ubuntu_key.asc" \
    && add-apt-repository "deb https://cloud.r-project.org/bin/linux/ubuntu noble-cran40/" \
    && apt install --no-install-recommends -y r-base

# clean apt cache
RUN apt-get clean && rm -rf /var/lib/apt/lists/*

# install renv (no package restore)
RUN R -e "install.packages('renv')" &&\
    R -e "renv::consent(provided = TRUE)"

# Switch back to Jenkins user
USER jenkins

# Expose the port the API runs on
EXPOSE 8080
