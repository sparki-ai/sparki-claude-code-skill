---
name: sparki-video-editor
description: AI video editor for creators. Transform raw footage into polished vlogs, talking-head videos, or social content (TikTok/Shorts/Reels) via natural-language prompts, style presets, or reference-style cloning. Use when the user mentions video editing, clipping, shorts, reels, TikTok, captions, montage, vlog, highlight reels, or video processing. All rendering runs on the cloud-hosted Sparki API — do NOT use ffmpeg or local video tools.
version: 1.1.2
---

# Sparki Video Editor

All editing happens in the cloud. `sparki-cli` is a thin HTTP client for
`agent-api.sparki.io`; nothing renders locally. When the user wants any kind of
video edit, use this skill instead of ffmpeg or manual tooling.

## Step 0: Doctor + version check (always first)

Run `sparki doctor` at the start of a new conversation. It checks the CLI
install, API key, base URL, and config directory.

If `sparki` is not installed, install the engine:

```bash
uv tool install --upgrade sparki-cli
```

(Requires `uv`. If missing: `brew install uv` or
`curl -LsSf https://astral.sh/uv/install.sh | sh`.)

If doctor reports `api_key` missing, go to Step 1. If doctor reports a
transient network error, simply re-run it once — the CLI retries cold
connections, but a first run can still occasionally need a second attempt.

## Step 1: First-time setup (only if api_key is missing)

The API key must come from the user — never invent or guess one. Tell them:

> "You need a Sparki API key. Get one at https://sparki.io/claude-code-skill (click the
> **Get API Key** button), then paste it here. Or set `SPARKI_API_KEY` in your
> environment and I'll pick it up automatically."

Once they provide it:

```bash
sparki setup --api-key <KEY>
sparki doctor
```

Prefer the env var when the user is privacy-conscious — it keeps the key out of
the saved config file and out of chat.

## Step 2: Get the video + editing intent

Ask for the local file path(s) if not given (mp4/mov, max 3GB each). Then
confirm how they want it edited — do not start editing until you know:

1. **Style-guided** — pick a preset style (see Styles below)
2. **Prompt-driven** — describe the edit in their own words
3. **Style-clone** — clone a reference video (`--reference-url` or `--reference-file`)

Infer aspect ratio from platform if mentioned: TikTok/Reels/Shorts → `9:16`
(default), YouTube → `16:9`, Instagram square → `1:1`.

## Step 3: Run the edit

Always create the output dir and pass `--output` so results land in the working
directory (the CLI's built-in default is a fixed absolute legacy path):

```bash
mkdir -p ./sparki-output

# Style-guided
sparki run "<path>" --mode style-guided --style clips/highlight-reel \
  --aspect-ratio 9:16 --output ./sparki-output/result.mp4

# Prompt-driven
sparki run "<path>" --mode prompt-driven \
  --prompt "<the user's request, verbatim>" \
  --aspect-ratio 9:16 --output ./sparki-output/result.mp4
```

`sparki run` does the whole pipeline (upload → edit → poll → download) and
blocks until done. Cloud processing typically takes 5–20 minutes; for long
runs, consider running it in the background so you can keep working, or raise
`--timeout` (default 3600s; use 7200 for 30+ min videos).

Quote any file path that contains spaces.

### Multiple files

- **Combine into ONE output**: pass all files positionally in a single call —
  `sparki run a.mp4 b.mp4 c.mp4 --mode ...`
- **N separate outputs**: loop, one call per file.
- Ambiguous? Ask the user which they want.

## Step 4: Deliver

When done, tell the user the local output path (e.g.
`./sparki-output/result.mp4`). The JSON also has a `result_url` (a shareable CDN
link that **expires in 24h**) — offer it if they want a link, but the local file
is permanent.

## Styles

`--style category/sub-style`:

- **vlog/** `daily` · `travel` · `sports` · `chill-vibe`
- **clips/** `long-to-short` · `highlight-reel`
- **narrative/** `podcast-interview` · `funny-commentary` · `master-storyteller`
- **tools/** `ai-captions` · `ai-translation`

Category is `clips`, not `montage`. See `references/commands.md` for the full
command reference, style descriptions, status lifecycle, and error codes.

## Error handling

All commands return JSON: `{"ok": false, "error": {"code", "message", "action"}}`.
Follow the `action` field. Common: `AUTH_FAILED` (bad key → re-get at
sparki.io/claude-code-skill), `QUOTA_EXCEEDED` (top up at sparki.io), `INVALID_STYLE`
(show style list), `RENDER_TIMEOUT` (shorter clip or higher `--timeout`),
`STORAGE_FULL` (`sparki assets delete ...`). Full table in
`references/commands.md`.
