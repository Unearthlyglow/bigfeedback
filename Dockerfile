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
# go.sum

# Download all dependencies.
RUN go mod download

# Copy the source from the current directory to the working Directory inside the container.
COPY . .

# Build the Go app.
RUN CGO_ENABLED=0 GOOS=linux go build -o /cmd/bigfeedback ./cmd

# Start a new stage from scratch for smaller image size.
#Install ca-certificates Package: ca-certificates is a package in Linux that contains a set of CA (Certificate Authority) certificates. These are used for establishing the authenticity of SSL/TLS connections (for example, when your application makes HTTPS requests to other web services). Without these certificates, your application might not be able to securely connect to other services over HTTPS, as it won't be able to verify the server's SSL certificate.

# Use of --no-cache Option: The --no-cache option is specific to apk, which is the package manager for Alpine Linux. This option tells apk to not cache the index locally, which is a practice that reduces the size of the built Docker images. In Docker environments, especially when building minimal images for production, it's a common practice to avoid keeping unnecessary files in the image to reduce its size. By using --no-cache, it ensures that the index used by the package manager to install ca-certificates is not stored in the Docker image, thereby making the image smaller.

# In summary, this command is about ensuring that your Docker container has the necessary certificates to establish secure connections, while also keeping the size of your Docker image as small as possible by not caching extra data.

FROM alpine:latest  
RUN apk --no-cache add ca-certificates

WORKDIR /root/

# Copy the pre-built binary file from the previous stage.
COPY --from=builder /cmd/bigfeedback .

# Command to run the executable.
CMD ["./bigFeedback"] 
