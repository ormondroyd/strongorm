FROM emscripten/emsdk:latest AS builder

RUN apt-get update && apt-get install -y git curl python3 python3-pip make && \
    pip3 install jinja2 jinja2-cli toml requests --break-system-packages

WORKDIR /app
COPY . .

RUN git config --global --add safe.directory '*' && \
    sed -i 's/-Wall -Werror/-Wall -Werror -Wno-unused-but-set-variable/' arculator-wasm/Makefile && \
    cp toml2json-patched.py arclive-software/toml2json.py && \
    sed -i 's|archive="elite.zip"|archive="http://acorn.revivalteam.de/Download/Images/Elite.zip"|' arclive-software/catalogue/games/full/fullgames.toml && \
    sed -i 's|archive="twinworld.zip"|archive="http://acorn.revivalteam.de/Download/Images/Twinworld.zip"|' arclive-software/catalogue/games/full/fullgames.toml && \
    sed -i "s|archive=\"mr-doo.zip\"|archive=\"http://acorn.revivalteam.de/Download/Images/Mr%20Doo.zip\"|" arclive-software/catalogue/games/full/fullgames.toml && \
    sed -i 's|archive="2067bc.zip"|archive="http://acorn.revivalteam.de/Download/Images/2067%20BC.zip"|' arclive-software/catalogue/games/full/fullgames.toml && \
    sed -i 's|archive="alerion.zip"|archive="http://acorn.revivalteam.de/Download/Images/Alerion.zip"|' arclive-software/catalogue/games/full/fullgames.toml && \
    make build/index.html build/arculator.js build/nspark/nspark.js build/emu build/software/software.json

FROM nginx:alpine
COPY --from=builder /app/build /usr/share/nginx/html
EXPOSE 80
