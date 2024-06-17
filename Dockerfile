FROM golang:latest as builder
WORKDIR /app
ADD ./*.go .
ADD ./go.* .
RUN CGO_ENABLED=0 GOARCH=${TARGETARCH} GOOS=linux go build -o guestbook .

FROM scratch
WORKDIR /app
COPY --from=builder /app/guestbook .
COPY ./public public
CMD ["/app/guestbook"]
EXPOSE 3000
