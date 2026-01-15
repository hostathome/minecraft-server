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

Edit `configs/config.yaml`. Each setting specifies a `key` (itzg environment variable) and a `value`:

```yaml
java:
  version:
    key: VERSION
    value: LATEST
  memory:
    key: MEMORY
    value: 2G

server:
  motd:
    key: MOTD
    value: "My Minecraft Server"
  max-players:
    key: MAX_PLAYERS
    value: 20
  gamemode:
    key: GAMEMODE
    value: survival
  difficulty:
    key: DIFFICULTY
    value: normal

world:
  level-type:
    key: LEVEL_TYPE
    value: default
  seed:
    key: SEED
    value: ""
  view-distance:
    key: VIEW_DISTANCE
    value: 12

network:
  online-mode:
    key: ONLINE_MODE
    value: "TRUE"
  white-list:
    key: WHITE_LIST
    value: "FALSE"
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

## Data & Configuration

The server uses two volumes:

- **`configs/`** → `/configs` (mounted volume)
  - `config.yaml` - Server settings
  - `mods.yaml` - Mod configuration
  - *Changes to these files take effect on container restart*

- **`data/`** → `/data` (mounted volume)
  - `save/` - World saves
  - `backup/` - User backups
  - Runtime data and minecraft server files

## Architecture

```
entrypoint.sh
├── setup.sh → Copy default configs if missing
├── config.py → Parse YAML + mods.yaml → export env vars
├── logging.sh → Display configuration & mod summary
└── /start → Hand off to itzg minecraft-server
```

**Scripts**:
- `config.py` - Parses `config.yaml` and `mods.yaml`, outputs environment variable exports (with logging)
- `setup.sh` - File initialization, copies default configs if missing
- `logging.sh` - Displays configuration and mod setup summary
- `utils.sh` - Shared logging and utility functions
