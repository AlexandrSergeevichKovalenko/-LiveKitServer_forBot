FROM golang:1.20-alpine AS builder

ARG TARGETPLATFORM
ARG TARGETARCH
RUN echo building for "$TARGETPLATFORM"

WORKDIR /workspace

# Copy the Go Modules manifests
COPY go.mod go.mod
COPY go.sum go.sum
RUN go mod download

# Copy the go source
COPY cmd/ cmd/
COPY pkg/ pkg/
COPY test/ test/
COPY tools/ tools/
COPY version/ version/

RUN CGO_ENABLED=0 GOOS=linux GOARCH=$TARGETARCH GO111MODULE=on go build -a -o livekit-server ./cmd/server

FROM alpine:3.18

COPY --from=builder /workspace/livekit-server /livekit-server

# Copy your configuration file
COPY livekit.yaml /livekit.yaml

EXPOSE 7880 7881 7882 7883

ENTRYPOINT ["/livekit-server"]