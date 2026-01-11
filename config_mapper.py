#!/usr/bin/env python3
"""
HostAtHome Universal Config Mapper
Converts universal YAML configs to game-native formats

Supports inline key mappings:
  field:
    value: "actual value"
    key: 'NATIVE_KEY'
"""
import sys
import yaml
import argparse


def extract_mappings(data, prefix=''):
    """Recursively extract key-value mappings from nested structure"""
    mappings = {}
    
    for field, content in data.items():
        if field.startswith('__'):
            continue
            
        if isinstance(content, dict):
            # Check if this is a mapped value (has 'value' and 'key')
            if 'key' in content and 'value' in content:
                native_key = content['key']
                value = content['value']
                mappings[native_key] = value
            else:
                # Recurse into nested structure
                nested = extract_mappings(content, f"{prefix}{field}.")
                mappings.update(nested)
    
    return mappings


def format_value(value):
    """Format value for config output"""
    if isinstance(value, bool):
        return str(value).lower()
    if value is None:
        return ""
    return str(value)


def yaml_to_properties(mappings):
    """Convert mappings to Java properties format"""
    lines = []
    for native_key, value in mappings.items():
        if value != "":
            lines.append(f"{native_key}={format_value(value)}")
    return '\n'.join(lines)


def yaml_to_ini(mappings):
    """Convert mappings to INI format"""
    lines = []
    for native_key, value in mappings.items():
        if value != "":
            lines.append(f"{native_key}={format_value(value)}")
    return '\n'.join(lines)


def yaml_to_cfg(mappings):
    """Convert mappings to CFG format (Source engine style)"""
    lines = []
    for native_key, value in mappings.items():
        if value != "":
            # CFG format uses quotes for string values
            if isinstance(value, str) and ' ' in value:
                lines.append(f'{native_key} "{value}"')
            else:
                lines.append(f"{native_key} {format_value(value)}")
    return '\n'.join(lines)


def yaml_to_shell(mappings):
    """Convert mappings to shell export statements"""
    lines = []
    for native_key, value in mappings.items():
        if value != "":
            # Shell export format
            lines.append(f"export {native_key}='{format_value(value)}'")
    return '\n'.join(lines)


def process_env_vars(config_file):
    """Process __env__ section from config.yaml and output shell exports"""
    with open(config_file, 'r') as f:
        config = yaml.safe_load(f)

    lines = []
    env_vars = config.get('__env__', {})

    if env_vars:
        for key, value in env_vars.items():
            # Convert key to uppercase and replace hyphens with underscores
            env_key = key.upper().replace('-', '_')
            if value:
                lines.append(f"export {env_key}='{value}'")

    return '\n'.join(lines)


def process_mods(mods_file):
    """Process mods.yaml and output shell exports for itzg container"""
    with open(mods_file, 'r') as f:
        mods = yaml.safe_load(f)

    lines = []

    # Check if using modpack mode (requires platform and slug to be set)
    modpack = mods.get('modpack', {})
    if modpack and modpack.get('platform') == 'curseforge' and modpack.get('slug'):
        # Modpack mode - set CurseForge modpack specific env vars
        lines.append("export MODPACK_PLATFORM='AUTO_CURSEFORGE'")

        if modpack.get('api-key'):
            lines.append(f"export CF_API_KEY='{modpack['api-key']}'")

        if modpack.get('slug'):
            lines.append(f"export CF_SLUG='{modpack['slug']}'")

        if modpack.get('file-id'):
            lines.append(f"export CF_FILE_ID='{modpack['file-id']}'")

        # Note: Don't set TYPE/LOADER in modpack mode - let itzg auto-detect from modpack
    else:
        # Individual mods mode - use existing logic
        loader = mods.get('loader', 'vanilla')
        lines.append(f"export TYPE='{loader.upper()}'")
        lines.append(f"export LOADER='{loader}'")

        # CurseForge individual mods
        mods_section = mods.get('mods', {})
        cf = mods_section.get('curseforge', {})
        if cf.get('api-key'):
            lines.append(f"export CF_API_KEY='{cf['api-key']}'")
            if cf.get('slugs'):
                lines.append(f"export CF_SLUG='{','.join(cf['slugs'])}'")

        # Modrinth mods
        modrinth_section = mods_section.get('modrinth', {})
        mr_projects = modrinth_section.get('projects', [])
        if mr_projects:
            lines.append(f"export MODRINTH_PROJECTS='{','.join(mr_projects)}'")

    return '\n'.join(lines)


def main():
    parser = argparse.ArgumentParser(description='HostAtHome Universal Config Mapper')
    parser.add_argument('config_file', help='Path to config.yaml file')
    parser.add_argument('--mods', action='store_true', help='Process mods.yaml instead')
    parser.add_argument('--env', action='store_true', help='Extract __env__ variables from config.yaml')
    parser.add_argument('--format', choices=['properties', 'ini', 'cfg', 'shell'],
                        help='Output format (overrides __format__ in config)')

    args = parser.parse_args()

    # Handle mods mode
    if args.mods:
        print(process_mods(args.config_file))
        return

    # Handle env mode
    if args.env:
        print(process_env_vars(args.config_file))
        return

    # Load config
    with open(args.config_file, 'r') as f:
        data = yaml.safe_load(f)

    # Get format from config
    output_format = args.format or data.get('__format__', 'properties')

    # Extract mappings from inline key-value structure
    mappings = extract_mappings(data)

    if not mappings:
        print("Error: No mapped values found in config file", file=sys.stderr)
        sys.exit(1)

    # Convert based on format
    formatters = {
        'properties': yaml_to_properties,
        'ini': yaml_to_ini,
        'cfg': yaml_to_cfg,
        'shell': yaml_to_shell,
    }

    formatter = formatters.get(output_format)
    if not formatter:
        print(f"Error: Unknown format '{output_format}'", file=sys.stderr)
        sys.exit(1)

    output = formatter(mappings)
    print(output)


if __name__ == '__main__':
    main()
