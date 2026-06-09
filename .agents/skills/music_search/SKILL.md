---
name: music_search
description: >
  Skill for searching internet web radio stations matching user requests and adding/playing them on an mpd host via shell commands.
  Trigger words include "mpc", "search music", "mpd", "web radio", "webラジオ", "ウェブラジオ" and similar terms.
---

# music_search

## Purpose

Search for internet web radio stations based on user requests and add/play them on a specified mpd host.

## Prerequisites

- `mpc` command must be installed.
- `radio-browser-cli` command must be installed(`/home/tekkamelon/.local/bin`)
- MPD server must be running.

## Tools Used

- `web_search` tools: Used for vague requests or to look up specific radio station names.
- `radio-browser-cli`: Uses the Radio-Browser.info API to retrieve URLs.
- `mpc`: Command-line client for MPD.

## When to Use Which Search Tool

### web_search Tools

Use these for vague requests based on emotions or scenes.
Examples:
- Music perfect for sleeping
- Refreshing music for the morning
- Music to listen to when concentrating

In these cases, first use web_search tools to investigate recommended radio station names or streaming URLs.

### radio-browser-cli

Use this when specific genres, countries, or tags are provided.
Examples:
- Play some jazz or lofi
- Play Japanese music
- Find a classical radio station

Also, after obtaining a specific radio station name via web_search, you may use radio-browser-cli to get that station's URL.

## How to Use radio-browser-cli

### Searching for Radio Stations

```bash
radio-browser-cli search [OPTIONS]
```

Options:
- `--name NAME`: Search by radio station name.
- `--country COUNTRY`: Search by country (e.g., Japan).
- `--tag TAG`: Search by genre/tag (e.g., jazz).
- `--language LANGUAGE`: Search by language (e.g., japanese).
- `--limit LIMIT`: Maximum number of results (default: 20).
- `--format {csv,tsv,urls,json,m3u}`: Output format (default: csv).

### Getting URLs Only

Use `--format urls` for passing to `mpc add`.

```bash
radio-browser-cli search --name "BBC" --format urls
```

### List of Countries

```bash
radio-browser-cli countries
```

### List of Tags

```bash
radio-browser-cli tags
```

## How to Use mpc

### Specifying a Host

Either set the `MPD_HOST` environment variable or use the `--host` option.
If a host is specified by the user, use `mpc --host="HOSTNAME"`.

```bash
# Using environment variable
export MPD_HOST=localhost

# Using command option
mpc --host="localhost"
```

### Adding to Queue

```bash
mpc add "URL"
```

## Workflow

1. Evaluate the user's request.
   - Vague requests (emotions/scenes) -> Investigate candidates using web_search tools.
   - Specific genres/countries/tags -> Search directly using radio-browser-cli.
2. If a station name is known -> Retrieve the URL using radio-browser-cli (`--format urls`).
3. Add the retrieved URL to the mpd queue using `mpc add`.
   - If a host is specified, add the `--host=` option.
4. Optionally start playback with `mpc play`.

### Example Execution

```bash
# After finding station name via web_search, get URL with radio-browser-cli
url=$(radio-browser-cli search --name "BBC" --format urls | head -n 1)

# Add to local MPD
mpc add "${url}"

# Add to remote MPD
mpc --host="remote-host" add "${url}"
```

## Scripts

Shell scripts are placed in the `scripts/` directory.

### search_and_add.sh

Searches for a radio station using a keyword and adds it to the mpd queue.

```bash
scripts/search_and_add.sh "KEYWORD" [HOSTNAME]
```

- Arg 1: Search keyword (required)
- Arg 2: MPD hostname (optional, default: localhost)

## Constitution

- NEVER: Do not clear the existing queue (do not use `mpc clear`).
- Use only `mpc add` to respect the user's existing playback queue.
