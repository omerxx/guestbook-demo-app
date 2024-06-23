FROM golang
WORKDIR /app
COPY . .
RUN CGO_ENABLED=0 GOARCH=${TARGETARCH} GOOS=linux go build -o guestbook .
CMD ["/app/guestbook"]

