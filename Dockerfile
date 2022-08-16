FROM golang:1.19.0-alpine3.16 AS builder

LABEL maintainer = "Fredy Rodriguez - jfredy.rodriguezn@gmail.com"

#Install git inside the container
RUN apk update \
    && apk add --no-cache git \
    && apk add --no-cache bash \
    && apk add --no-cache ca-certificates \
    && apk add --update gcc musl-dev \
    && apk add build-base \
    && update-ca-certificates

# Create a user so the container doesn't run as root
# RUN adduser -D -g '' ubarp
# USER ubarp

# Creates and select workdir folder
WORKDIR /go/src/barp

# Download all the dependencies
# COPY go.mod ./
COPY go.mod go.sum ./
RUN go mod download && go mod verify

# Copy the source from current folder to workdir inside the container
COPY . .
COPY .env .

#Build project
# RUN go build -v -o /go/src/barp
RUN CGO_ENABLED=0 GOARCH=amd64 GOOS=linux go build -a -installsuffix cgo -o abarp .

## Use linux alpine
FROM alpine:latest

RUN apk --no-cache add ca-certificates && update-ca-certificates

WORKDIR /root/

COPY --from=builder /go/src/barp/abarp .

EXPOSE 8000

CMD ["./abarp"]