FROM ubuntu:24.04

ARG TARGETARCH

RUN apt-get update && apt-get install -y --no-install-recommends \
    sudo            \
    ca-certificates \
    build-essential \
    libfftw3-dev    \
    g++ gfortran    \
    libopenmpi-dev  \
    openmpi-bin     \
    git             \
    python3         \
    cmake           \
    pkg-config      \
    wget            \
    libxcursor1     \
    libgl1          \
    libxt6          \
    libx11-6        \
    libosmesa6      \
    libosmesa6-dev  \
    ffmpeg          \
 && rm -rf /var/lib/apt/lists/* \
 && update-ca-certificates 

RUN if [ "$TARGETARCH" = "amd64" ]; then \
      wget https://www.paraview.org/files/v6.0/ParaView-6.0.1-MPI-Linux-Python3.12-x86_64.tar.gz \
      && tar -xzf ParaView-6.0.1-MPI-Linux-Python3.12-x86_64.tar.gz -C /opt \
      && rm ParaView-6.0.1-MPI-Linux-Python3.12-x86_64.tar.gz; \
    else \
      echo "Skipping ParaView installation on $TARGETARCH" ; \
    fi

RUN useradd -m -s /bin/bash amrexuser \
 && echo "amrexuser ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers

USER amrexuser
WORKDIR /home/amrexuser
ENV AMReX_ROOT=/home/amrexuser/installdir

RUN if [ "$TARGETARCH" = "amd64" ]; then \
      echo "alias pvpython='/opt/ParaView-6.0.1-MPI-Linux-Python3.12-x86_64/bin/pvpython'" >> /home/amrexuser/.bashrc && \
      echo "export VTK_DEFAULT_OPENGL_WINDOW=vtkOSOpenGLRenderWindow" >> /home/amrexuser/.bashrc; \
    fi

RUN git clone --branch 25.12 --depth 1 https://github.com/AMReX-Codes/amrex.git \
 && cd amrex \
 && cmake -S . -B build \
               -DAMReX_FFT=ON \
               -DAMReX_ENABLE_TESTS=ON \
               -DAMReX_SPACEDIM="3" \
 && cmake --build build -j `nproc` \
 && cmake --build build --target install

RUN git clone https://github.com/WeiqunZhang/amrex-101.git

CMD ["/bin/bash"]
