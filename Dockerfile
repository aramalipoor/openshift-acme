FROM golang:1.9

ENV GO_SOURCE_PATH=/go/src/github.com/tnozicka/openshift-acme \
    GOBIN=/go/bin

RUN apt-get update && \
    apt-get install -y \
        tzdata \
        curl \
        bash \
        ca-certificates \
        rsync \
        git \
        netcat \
    && \
    rm -rf /var/lib/apt/lists/*

RUN curl https://glide.sh/get | sh

WORKDIR $GO_SOURCE_PATH

COPY glide.yaml glide.lock ${GO_SOURCE_PATH}/

RUN glide update && cat glide.lock
RUN glide install

COPY ./ $GO_SOURCE_PATH

RUN go install -v .

WORKDIR $GOBIN

CMD ["openshift-acme"]
