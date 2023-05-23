ARG FROM_IMAGE
FROM ${FROM_IMAGE}

RUN --mount=type=cache,target=/var/cache/apt,sharing=locked \
    apt-get update ; \
    apt-get upgrade -y ; \
    apt-get install -y --no-install-recommends git python3 python3-pip libopenblas-dev ninja-build build-essential 

RUN --mount=type=cache,target=/root/.cache/pip,sharing=locked \
    pip3 install --upgrade pip pytest cmake scikit-build setuptools fastapi uvicorn sse-starlette

WORKDIR /app
COPY . .


ARG CMAKE_ARGS=
RUN FORCE_CMAKE=1 python3 setup.py develop

# We need to set the host to 0.0.0.0 to allow outside access
ENV HOST 0.0.0.0
EXPOSE 8000

# Run the server
ENTRYPOINT ["python3", "-m", "llama_cpp.server"]
