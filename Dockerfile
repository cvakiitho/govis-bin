FROM golang:alpine AS builder

# Install git + SSL ca certificates.
# Git is required for fetching the dependencies.
# Ca-certificates is required to call HTTPS endpoints.
RUN apk update && apk add --no-cache git ca-certificates && update-ca-certificates


RUN mkdir /app
ADD . /app/
WORKDIR /app
CMD ["./Govis-CI"]

FROM scratch AS binary
COPY --from=builder /etc/ssl/certs/ca-certificates.crt /etc/ssl/certs/
COPY --from=builder /app/Govis-CI /app/Govis-CI
EXPOSE 8000
CMD ["./Govis-CI"]

FROM alpine:latest AS alpine
COPY --from=builder /etc/ssl/certs/ca-certificates.crt /etc/ssl/certs/
COPY --from=builder /app/Govis-CI /app/Govis-CI
WORKDIR /app/
EXPOSE 8000
CMD ["./Govis-CI"]
