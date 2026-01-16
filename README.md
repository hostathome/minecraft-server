# HostAtHome - Minecraft Server

Minecraft Java Edition server with mod support (Paper, Fabric, Forge).

**Image Credit**
- **Source:** itzg/docker-minecraft-server ([GitHub](https://github.com/itzg/docker-minecraft-server)) and Read the Docs ([Read the Docs](https://docker-minecraft-server.readthedocs.io/en/latest/#using-docker-compose/)).

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

Edit `configs/config.yaml`. Each setting specifies a `key` (itzg environment variable) and a `value`:

```yaml
enviroment:
  version:
    key: VERSION
    value: LATEST
  memory:
    key: MEMORY
    value: 2G
```

See [itzg documentation](https://docker-minecraft-server.readthedocs.io/en/latest/variables/) for all available variables.

## Mods

Edit `configs/mods.yaml` to configure mods:

### CurseForge Modpack

```yaml
loader:
  type:
    key: TYPE
    value: vanilla

modpack:
  slug:
    key: CF_SLUG
    value: "all-the-mods-9"
  file-id:
    key: CF_FILE_ID
    value: ""
  api-key:
    key: CF_API_KEY
    value: "your-api-key"
```

### Individual Mods

```yaml
loader:
  type:
    key: TYPE
    value: fabric

curseforge:
  api-key:
    key: CF_API_KEY
    value: "your-api-key"
  mods:
    key: CF_MODLIST
    value: "jei,journeymap"

modrinth:
  projects:
    key: MODRINTH_PROJECTS
    value: "sodium,lithium"
```