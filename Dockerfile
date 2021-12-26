FROM ubuntu:20.04

#ENV DEBIAN_FRONTEND noninteractive
#ENV TZ=Asia/Tokyo
ENV TZ=Asia/Tokyo
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

#add data
ADD ./data /home/data

# Install Node.js, Yarn and required dependencies
RUN apt-get update \
  && apt-get install -y curl gnupg build-essential g++ openmpi-bin openmpi-doc libopenmpi-dev \
  && curl --silent --location https://deb.nodesource.com/setup_17.x | bash - \
  && curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add - \
  && echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list \
  && apt-get remove -y --purge cmdtest \
  && apt-get update \
  && apt-get install -y nodejs yarn \
  # remove useless files from the current layer
  && rm -rf /var/lib/apt/lists/* \
  && rm -rf /var/lib/apt/lists.d/* \
  && apt-get autoremove \
  && apt-get clean \
  && apt-get autoclean 
  # compile
  && cd /home/data/olb-1.4r0 \ 
  && make -j4 samples


RUN adduser --disabled-password --gecos "" --uid 1000 node

USER 1000
WORKDIR /home/node
CMD ["node"]
