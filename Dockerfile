# =============================================================================
# stage 1: builder
# =============================================================================
FROM golang:1.23 AS builder

WORKDIR /app

# install dependencies into venv
COPY go.mod . 
COPY main.go .
COPY templates ./templates
RUN CGO_ENABLED=0 go build -o hello .

# =============================================================================
# stage 2: runtime (final image)
# =============================================================================
FROM scratch

WORKDIR /app

COPY --from=builder /app/hello .
COPY --from=builder /app/templates ./templates

# run application
CMD ["./hello"]