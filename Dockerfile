ARG CMAKE_URL=https://github.com/Kitware/CMake/releases/download/v3.21.4/cmake-3.21.4-linux-x86_64.tar.gz

FROM ubuntu:latest
ARG CMAKE_URL

WORKDIR /

ENV TZ=Europe/Berlin

RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone
RUN apt update
RUN apt -y dist-upgrade
RUN apt -y install build-essential wget gcc-10 g++-10 clang-11 clang-format-11 clang-tidy-11 python3 python3-pip
RUN update-alternatives --install /usr/bin/gcc gcc /usr/bin/gcc-10 100
RUN update-alternatives --install /usr/bin/g++ g++ /usr/bin/g++-10 100
RUN update-alternatives --install /usr/bin/clang clang /usr/bin/clang-11 100
RUN update-alternatives --install /usr/bin/clang++ clang++ /usr/bin/clang++-11 100
RUN update-alternatives --install /usr/bin/clang-format clang-format /usr/bin/clang-format-11 100
RUN update-alternatives --install /usr/bin/clang-tidy cclang-tidy /usr/bin/clang-tidy-11 100
RUN update-alternatives --install /usr/bin/python python /usr/bin/python3 100
RUN pip3 install --upgrade pip
RUN apt -y autoclean
RUN apt -y clean
RUN rm -rf /var/lib/apt/lists/*
RUN wget -qO - ${CMAKE_URL} | tar --strip-components=1 -xz -C /usr/local

COPY run-clang-tidy.py /run-clang-tidy.py
RUN chmod +x /run-clang-tidy.py
COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]
