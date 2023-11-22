# # syntax=docker/dockerfile:1

# FROM golang:1.21.3 AS build

# # Set destination for COPY
# WORKDIR /app

# # Download Go modules
# COPY go.mod ./
# RUN go mod download

# # Copy the source code. Note the slash at the end, as explained in
# # https://docs.docker.com/engine/reference/builder/#copy
# # COPY *.go ./
# COPY *.go ./

# # Build

# RUN CGO_ENABLED=0 GOOS=linux go build -o /bigFeedback 
# # RUN CGO_ENABLED=0 GOOS=linux go build -o bigFeedback cmd/main.go



# # To bind to a TCP port, runtime parameters must be supplied to the docker command.
# # But we can (optionally) document in the Dockerfile what ports
# # the application is going to listen on by default.
# # https://docs.docker.com/engine/reference/
# # Run
# CMD [ "/bigFeedback" ]

# ORIGINAL ABOVE
################### //
# Use the official Golang image to create a build artifact.
# This is stage 1 of multi-stage build.
FROM golang:latest as builder

# Set the working directory inside the container.
WORKDIR /app

# Copy go mod and sum files.
COPY go.mod ./

# Download all dependencies.
RUN go mod download

# Copy the source from the current directory to the working Directory inside the container.
COPY . .

# Build the Go app.
RUN CGO_ENABLED=0 GOOS=linux go build -o /cmd/bigfeedback ./cmd

# Start a new stage from scratch for smaller image size.
FROM alpine:latest  
RUN apk --no-cache add ca-certificates

WORKDIR /root/

# Copy the pre-built binary file from the previous stage.
COPY --from=builder /cmd/bigfeedback .

# Command to run the executable.
CMD ["./bigFeedback"] 
