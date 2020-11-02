FROM golang:1.15.3

WORKDIR /go/src/fullcycle
COPY ./src .
RUN GOOS=linux go build -ldflags="-s -w" -o ./fullcycle ./*
CMD ["./fullcycle"]