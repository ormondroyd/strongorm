FROM emscripten/emsdk:latest AS builder

RUN apt-get update && apt-get install -y git curl python3 python3-pip make && \
    pip3 install jinja2 jinja2-cli toml requests --break-system-packages

WORKDIR /app
COPY . .

RUN git config --global --add safe.directory '*' && \
    sed -i 's/-Wall -Werror/-Wall -Werror -Wno-unused-but-set-variable/' arculator-wasm/Makefile && \
    make build/index.html build/arculator.js build/nspark/nspark.js build/emu

FROM nginx:alpine
COPY --from=builder /app/build /usr/share/nginx/html
EXPOSE 80
