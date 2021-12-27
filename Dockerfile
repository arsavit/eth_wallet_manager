FROM golang:1.17-alpine as dev

RUN  apk --no-cache add py3-pip=20.3.4-r1 openssh=8.8_p1-r1 git=2.34.1-r0 build-base=0.5-r2 python3-dev=3.9.7-r4 \
    && pip3 install --no-cache-dir pre-commit==2.16.0

ADD https://github.com/hadolint/hadolint/releases/download/v2.7.0/hadolint-Linux-x86_64 /bin/hadolint
RUN chmod +x /bin/hadolint

WORKDIR /DEV

COPY .pre-commit-config.yaml .
RUN git init \
    && pre-commit install --install-hooks

COPY go.mod go.sum ./
RUN go mod download

COPY . ./


RUN git add . \
    && go build -o ./build/app ./app/src/main.go


FROM alpine:3.15 as app
WORKDIR /app

COPY --from=dev /DEV/build/app ./app


ENTRYPOINT ["./app"]
