FROM golang:1.20.0 as builder

ARG TARGETARCH

WORKDIR /app
ADD ./*.go .
ADD ./go.* .
RUN CGO_ENABLED=0 GOARCH=${TARGETARCH} GOOS=linux go build -o main .

FROM scratch
WORKDIR /app
COPY --from=builder /app/main .
COPY ./public/index.html public/index.html
COPY ./public/script.js public/script.js
COPY ./public/style.css public/style.css
CMD ["/app/main"]
EXPOSE 3000
