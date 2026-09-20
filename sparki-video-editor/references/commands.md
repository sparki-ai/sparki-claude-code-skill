# Sparki CLI — Full Command Reference

Progressive-disclosure reference for the `sparki-video-editor` skill. Load when
you need the full command surface; SKILL.md covers the common path.

## Commands

| Command | Purpose |
|---|---|
| `sparki config-status --channel claude` | Check whether the canonical config file exists without reading or printing its key. |
| `sparki login --channel claude` | Open browser login, show an approval prompt after sign-in, and save the account key without displaying it. Use `--no-browser` for headless terminals and `--force` to replace an existing config. |
| `sparki doctor --channel claude` | Self-check: CLI version, API key, base URL, config dir. `--json` / `--fix`. |
| `sparki upload <files...>` | Upload assets; returns object keys. `--dir`, `--max-retries`, `--upload-timeout`, `--quiet`. |
| `sparki run <files...>` | End-to-end: upload → edit → poll → download. |
| `sparki edit <object_keys...>` | Create a project from already-uploaded assets. |
| `sparki status --task-id <id>` | Poll project status. |
| `sparki download --task-id <id> --output <path>` | Download a finished result. |
| `sparki assets list` | List uploaded assets (find object keys). `--limit`. |
| `sparki assets delete <keys...>` | Delete by object key, `--name <hash>`, or `--all --yes`. |
| `sparki history` | List recent projects. `--limit`, `--status`. |

## `sparki run` / `sparki edit` options

| Option | Notes |
|---|---|
| `--mode` | `style-guided` \| `prompt-driven` \| `style-clone` (required) |
| `--style` | `category/sub-style` (required for style-guided) |
| `--prompt` | natural-language description (required for prompt-driven) |
| `--reference-url` / `--reference-file` | reference video (required for style-clone) |
| `--aspect-ratio` | `9:16` (default) \| `1:1` \| `16:9` |
| `--duration-range` | `<30s` \| `30s~60s` \| `60s~90s` \| `>90s` \| `custom` |
| `--output` | output path. **Always set to `./sparki-output/...`**; default is legacy `~/.openclaw/workspace/sparki/videos/<task_id>.mp4` |
| `--timeout` | max wait seconds (default 3600; use 7200 for 30+ min video) |
| `--poll-interval` | seconds between status checks (default 30) |
| `--max-retries` / `--upload-timeout` / `--strict` / `--quiet` | upload reliability (run only) |

## Style catalog

| Style | Best for |
|---|---|
| `vlog/daily` | Day-in-the-life, event recaps, BTS |
| `vlog/travel` | Vacations, road trips, city breaks |
| `vlog/sports` | Game highlights, performance reels |
| `vlog/chill-vibe` | Morning routines, slow living, aesthetic |
| `clips/long-to-short` | A long video's best moments → a short |
| `clips/highlight-reel` | Beat-synced montage of best moments |
| `narrative/podcast-interview` | Trim filler/pauses from podcasts & interviews |
| `narrative/funny-commentary` | Written & voiced comedic commentary |
| `narrative/master-storyteller` | Dramatic narration with emotional arcs |
| `tools/ai-captions` | Timed, styled captions from dialogue |
| `tools/ai-translation` | Captions translated to a target language |

## Status lifecycle

Standard: `INIT → CHAT → PLAN → QUEUED → EXECUTOR → COMPLETED / FAILED`
Style-clone (shorter): `INIT → EXECUTOR → COMPLETED / FAILED / CANCEL`

## Config & paths (Claude Code)

- Config: `Path.home()/.sparki/config/config.json` on macOS, Linux, and Windows.
  The stored field is `SPARKI_API_KEY`. The environment variable with the same
  name takes precedence; set `SPARKI_CHANNEL=claude` alongside it to preserve
  channel-specific recovery guidance. Older OpenClaw config is read-only fallback.
- Base URL: `https://agent-api.sparki.io`.
- Always pass `--output ./sparki-output/...` so results stay in the workspace.

## Error codes

| Code | Action |
|---|---|
| `AUTH_FAILED` | Invalid key → `sparki login --channel claude --force`, approve in the browser, then rerun doctor |
| `QUOTA_EXCEEDED` | Out of credits → top up at https://sparki.io/ |
| `STORAGE_FULL` | `sparki assets list` then `sparki assets delete ...`, retry |
| `FILE_TOO_LARGE` | File > 3GB → compress/trim |
| `CONCURRENT_LIMIT` | Too many active projects → `sparki history`, wait |
| `INVALID_FILE_FORMAT` | Only mp4/mov supported |
| `INVALID_STYLE` | Unknown style → show the catalog |
| `INVALID_MODE` | Use style-guided / prompt-driven / style-clone |
| `INVALID_REFERENCE` | style-clone needs `--reference-url` or `--reference-file` |
| `UPLOAD_FAILED` | Retry; on partial, reuse successes and retry failures |
| `RENDER_TIMEOUT` | Shorter clip or higher `--timeout` |
| `TASK_NOT_FOUND` | `sparki history` |
| `NETWORK_ERROR` | Check connection; re-run (CLI retries cold connections) |
| `NO_MATCH` | `--name` takes the hashed `file_name` from `assets list`, not the original filename |
| `DOCTOR_FAILED` | Inspect `checks[]`, follow each `action` |

## Constraints

- Formats: mp4, mov. Max 3GB/file. Up to 10 files per upload.
- Processing: typically 5–20 min. Result URLs expire in 24h.
- Rate limit: 3s between requests (server-enforced).
