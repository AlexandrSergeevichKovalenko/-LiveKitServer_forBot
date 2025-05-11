# Dockerfile for LiveKit server

FROM livekit/livekit-server:v1.4.0

COPY livekit.yaml /app/livekit.yaml

EXPOSE 7880 7881 7882 7883

CMD ["livekit-server", "--config", "/app/livekit.yaml"]


