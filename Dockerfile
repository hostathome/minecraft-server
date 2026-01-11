# HostAtHome - Minecraft Server

FROM itzg/minecraft-server:latest

ENV EULA=TRUE

# Install Python and PyYAML for config parsing
RUN apt-get update && \
    apt-get install -y python3 python3-pip python3-yaml && \
    rm -rf /var/lib/apt/lists/*

RUN mkdir -p /defaults

COPY configs/ /defaults/
COPY config_mapper.py /config_mapper.py
COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh /config_mapper.py

EXPOSE 25565
VOLUME ["/data"]

ENTRYPOINT ["/entrypoint.sh"]
