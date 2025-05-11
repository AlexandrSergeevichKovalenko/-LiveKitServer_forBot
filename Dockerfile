FROM golang:1.20-alpine

WORKDIR /app

# Copy only what's needed for downloading dependencies first
COPY go.mod go.sum ./
RUN go mod download

# Copy the rest of the source code
COPY . .

# Build the application
RUN CGO_ENABLED=0 GOOS=linux GO111MODULE=on go build -a -o livekit-server ./cmd/server

# Remove unnecessary files
RUN rm -rf cmd pkg test tools version

EXPOSE 7880 7881 7882 7883
EXPOSE 50000-51000/udp

ENTRYPOINT ["/app/livekit-server"]