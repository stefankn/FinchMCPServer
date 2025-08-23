FROM swift:latest AS builder
WORKDIR /build
COPY . .
RUN swift build -c release

FROM swift:slim
WORKDIR /app
COPY --from=builder /build .
CMD [ "sleep", "infinity" ]
