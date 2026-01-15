#!/usr/bin/env python3
"""
HostAtHome Configuration Script for Minecraft Server
Processes config.yaml and mods.yaml, exports itzg environment variables.
"""
import sys
import yaml


def format_value(value):
    """Format value for shell export"""
    if isinstance(value, bool):
        return "TRUE" if value else "FALSE"
    if value is None:
        return ""
    return str(value)


def load_yaml(filepath):
    """Load YAML file with error handling"""
    try:
        with open(filepath, 'r') as f:
            return yaml.safe_load(f) or {}
    except FileNotFoundError:
        print(f"Error: {filepath} not found", file=sys.stderr)
        sys.exit(1)
    except yaml.YAMLError as e:
        print(f"Error: Invalid YAML in {filepath}: {e}", file=sys.stderr)
        sys.exit(1)


def extract_exports(data):
    """
    Extract environment variable exports from YAML config.
    Looks for entries with both 'key' and 'value' fields.
    """
    exports = []

    for section_name, section_value in data.items():
        # Skip metadata keys
        if section_name.startswith('__'):
            continue

        if isinstance(section_value, dict):
            for option_name, option_value in section_value.items():
                if isinstance(option_value, dict) and 'key' in option_value and 'value' in option_value:
                    env_key = option_value['key']
                    env_value = option_value['value']

                    # Skip empty values
                    if env_value == "" or env_value is None:
                        continue

                    formatted = format_value(env_value)
                    if formatted:
                        exports.append(f"export {env_key}='{formatted}'")

    return exports


def detect_modpack_mode(mods):
    """
    Detect if modpack mode is enabled.
    Modpack mode is active when CF_SLUG is set (not empty).
    """
    modpack = mods.get('modpack', {})
    if modpack and isinstance(modpack, dict):
        slug_entry = modpack.get('slug', {})
        if isinstance(slug_entry, dict) and slug_entry.get('value'):
            return True
    return False


def main():
    # Load both config files
    config = load_yaml('/configs/config.yaml')
    mods = load_yaml('/configs/mods.yaml')

    # Extract all exports from config.yaml and mods.yaml
    exports = []
    exports.extend(extract_exports(config))
    exports.extend(extract_exports(mods))

    # Count user settings (before adding system settings)
    user_settings_count = len(exports)

    # If modpack mode is enabled, set MODPACK_PLATFORM
    if detect_modpack_mode(mods):
        exports.append("export MODPACK_PLATFORM='AUTO_CURSEFORGE'")

    # Tell itzg to use environment variables
    exports.append("export OVERRIDE_SERVER_PROPERTIES='false'")
    exports.append("export SKIP_SERVER_PROPERTIES='true'")

    # Output logging info to stderr
    print(f"[HostAtHome] Configuration loaded: {user_settings_count} settings applied", file=sys.stderr)

    for export_line in exports:
        print(export_line)


if __name__ == '__main__':
    main()
