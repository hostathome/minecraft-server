# HostAtHome - Minecraft Server

Minecraft Java Edition server with mod support (Paper, Fabric, Forge).

## Quick Start

```bash
hostathome install minecraft
hostathome run minecraft
```

## Ports

| Port | Protocol | Purpose |
|------|----------|---------|
| 1024 | TCP | Player connections |
| 1025 | TCP | RCON |

## Configuration

Edit `minecraft-server/configs/config.yaml`:

```yaml
server:
  motd: "My Minecraft Server"
  max-players: 20
  gamemode: survival
  difficulty: normal

world:
  seed: "my-custom-seed"
  view-distance: 12

network:
  online-mode: true
  white-list: false
```

## Mods

Edit `minecraft-server/mods/mods.yaml`:

```yaml
loader: fabric  # vanilla, paper, fabric, forge

modrinth:
  - lithium
  - sodium

curseforge:
  api-key: "your-api-key"
  mods:
    - jei
```

## Directory Structure

```
minecraft-server/
├── save/           # World data
├── mods/           # Plugins and mods
│   └── mods.yaml   # Mod configuration
├── configs/
│   └── config.yaml # Server configuration
└── backup/         # Your backups
```

## Docker (Development)

```bash
docker build -t minecraft-server .
docker run -d -p 1024:25565 -v $(pwd):/data minecraft-server
```
