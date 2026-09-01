FROM golang:1.22.1-alpine

WORKDIR /ProfilsActifs

COPY . .

RUN go build -o main .

EXPOSE 8080

CMD ["./main"]