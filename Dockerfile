FROM golang as builder
WORKDIR /app
COPY . .
RUN CGO_ENABLED=0 GOARCH=${TARGETARCH} GOOS=linux go build -o guestbook .
CMD ["/app/guestbook"]

FROM scratch
WORKDIR /app
COPY --from=builder /app/guestbook .
COPY ./public public
CMD ["/app/guestbook"]
