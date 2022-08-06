FROM golang:1.19.0-alpine3.16 as builder

LABEL maintainer = "Fredy Rodriguez - jfredy.rodriguezn@gmail.com"

#Install git inside the container
RUN apk update && apk add --no-cache git && apk add --no-cache bash && apk add build-base

# Creates and select workdir folder
RUN mkdir /go/src/barp
WORKDIR /go/src/barp

# Download all the dependencies
# COPY go.mod go.sum ./
COPY go.mod ./
RUN go mod download && go mod verify

# Copy the source from current folder to workdir inside the container
COPY . .
COPY .env .

#Build project
COPY . .
RUN CGO_ENABLED=0 GOOS=linux go build -a -installsuffix cgo -o main .

## Use linux alpine
FROM alpine:latest

RUN apk --no-cache add ca-certificates && update-ca-certificates

WORKDIR /root/

COPY --from=builder /go/src/barp/main .
    
EXPOSE 10000 10000

CMD ["./main"]