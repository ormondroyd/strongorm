FROM python:3.11-slim AS builder

RUN pip install jinja2 jinja2-cli toml

WORKDIR /app
COPY . .

RUN make all

FROM nginx:alpine
COPY --from=builder /app/build /usr/share/nginx/html
EXPOSE 80
