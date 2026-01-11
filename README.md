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
__env__:
  memory: 2G  # Increase to 4-6G for modpacks

server:
  motd:
    value: "My Minecraft Server"
    key: motd
  max-players:
    value: 20
    key: max-players
  gamemode:
    value: survival
    key: gamemode
  difficulty:
    value: normal
    key: difficulty

world:
  seed:
    value: "my-custom-seed"
    key: level-seed
  view-distance:
    value: 12
    key: view-distance

network:
  online-mode:
    value: true
    key: online-mode
  white-list:
    value: false
    key: white-list
```

## Mods and Modpacks

Edit `minecraft-server/configs/mods.yaml` - choose **ONE** option:

### Option 1: Use a CurseForge Modpack

```yaml
loader: vanilla  # Ignored for modpacks, auto-detected

modpack:
  platform: curseforge
  slug: "all-the-mods-9"           # CurseForge modpack slug
  file-id: ""                       # Optional: pin specific version
  api-key: "your-curseforge-key"   # Required: get from https://console.curseforge.com/
```

Then increase memory in `config.yaml`:
```yaml
__env__:
  memory: 6G  # Modpacks need more memory
```

### Option 2: Use Individual Mods

```yaml
loader: fabric  # vanilla, paper, fabric, forge

mods:
  curseforge:
    api-key: "your-api-key"
    slugs:
      - jei
      - journeymap

  modrinth:
    projects:
      - lithium
      - sodium
```

### Getting Your API Keys

- **CurseForge**: https://console.curseforge.com/
- **Modrinth**: Not required, but recommended for faster downloads

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
