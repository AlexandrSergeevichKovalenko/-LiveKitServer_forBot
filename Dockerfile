FROM golang:1.20-alpine

ARG TARGETPLATFORM
ARG TARGETARCH
RUN echo building for "$TARGETPLATFORM"

# Install necessary packages
RUN apk add --no-cache ca-certificates

WORKDIR /app

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

# Build the application
RUN CGO_ENABLED=0 GOOS=linux GOARCH=$TARGETARCH GO111MODULE=on go build -a -o livekit-server ./cmd/server

# Copy your configuration file
COPY livekit.yaml /app/livekit.yaml

# Clean up build artifacts to reduce image size
RUN rm -rf cmd/ pkg/ test/ tools/ version/

EXPOSE 7880 7881 7882 7883
EXPOSE 50000-51000/udp

ENTRYPOINT ["/app/livekit-server"]
CMD ["-c", "/app/livekit.yaml"]