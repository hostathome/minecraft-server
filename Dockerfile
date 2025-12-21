# HostAtHome - Minecraft Server

FROM itzg/minecraft-server:latest

ENV EULA=TRUE

RUN mkdir -p /data/{save,mods,configs,backup} /defaults

COPY configs/ /defaults/
COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

EXPOSE 25565
VOLUME ["/data"]

ENTRYPOINT ["/entrypoint.sh"]
