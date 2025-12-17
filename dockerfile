FROM python:3.10-slim

WORKDIR /app

# system deps that are commonly needed for scientific wheels + plotting
RUN apt-get update && apt-get install -y --no-install-recommends \
    build-essential \
    git \
    && rm -rf /var/lib/apt/lists/*

# install python deps
COPY requirements.txt /app/requirements.txt
RUN pip install --no-cache-dir -r requirements.txt

# copy the whole repo
COPY . /app

# reduce non-determinism from threaded math libs
ENV OMP_NUM_THREADS=1
ENV MKL_NUM_THREADS=1
ENV OPENBLAS_NUM_THREADS=1
ENV NUMEXPR_NUM_THREADS=1

# default: open a shell; you can override in `docker run ...`
CMD ["bash"]
