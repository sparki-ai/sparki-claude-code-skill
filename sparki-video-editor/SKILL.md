---
name: sparki-video-editor
description: AI video editor for creators. Transform raw footage into polished vlogs, talking-head videos, or social content (TikTok/Shorts/Reels) via natural-language prompts, style presets, or reference-style cloning. Use when the user mentions video editing, clipping, shorts, reels, TikTok, captions, montage, vlog, highlight reels, or video processing. All rendering runs on the cloud-hosted Sparki API — do NOT use ffmpeg or local video tools.
metadata:
  version: "1.1.6"
---

# Sparki Video Editor

All editing happens in the cloud. `sparki-cli` is a thin HTTP client for
`agent-api.sparki.io`; nothing renders locally. When the user wants any kind of
video edit, use this skill instead of ffmpeg or manual tooling.

## Step 0: Install and connect (always first)

This plugin targets Claude Code environments that can run local commands. If
the current surface cannot run Claude Code plugin or shell commands, stop and
explain that this bundle cannot be partially installed there.

Complete routine setup steps autonomously and keep progress updates brief. Do
not narrate repository inspection, package metadata, or every successful
command. Only pause when the user must act or when a real error requires input.

Install or upgrade the CLI so browser login and the shared configuration path
are available:

```bash
uv tool install --upgrade sparki-cli
```

After installation, use `sparki` when it is on `PATH`; otherwise use `uv tool
run --from sparki-cli sparki` as the Sparki command for the current session.

`uv` is required. If it is missing, use a trusted package manager already
available on the operating system (`brew install uv` on macOS, `winget install
--id=astral-sh.uv -e` on Windows, or `pipx install uv` where available).
Otherwise direct the user to the official installation guide at
https://docs.astral.sh/uv/getting-started/installation/. Do not silently run a
remote installer script.

Never ask the user to paste an API key into chat or expose it in command-line
arguments. Tell the user in one short message that a browser may open, and if
it does they should sign in and approve access without replying in chat. Then
run the complete connection flow:

```bash
sparki connect --channel claude --timeout 540
```

Run this as a foreground shell-tool call with a timeout of at least 600000
milliseconds. Do not background it or end the assistant turn while approval is
pending. If the host backgrounds it anyway, poll that same task until it exits;
do not ask the user to send "done" or start another connection.

`connect` reuses an existing credential. Otherwise it opens `sparki.io` for the
existing email-code, Google, or Apple login, saves the approved key at
`~/.sparki/config/config.json`, and runs doctor before returning. For a known
headless environment, add `--no-browser`; show the URL printed by that same
running command. Report completion only when its final JSON has `ok: true`.
Follow a failed result's `action`; use `--force` only when it asks to replace a
rejected credential. Never request a key or authorization code.

If `skill_version` is `skip`, continue with this loaded SKILL.md. If it reports
a different concrete version, reload the installed skill before editing.

The `SPARKI_API_KEY` environment variable still takes precedence for managed
environments. Set `SPARKI_CHANNEL=claude` alongside it for channel-specific
recovery guidance.

## Step 1: Get the video + editing intent

Ask for the local file path(s) if not given (mp4/mov, max 3GB each). Then
confirm how they want it edited — do not start editing until you know:

1. **Style-guided** — pick a preset style (see Styles below)
2. **Prompt-driven** — describe the edit in their own words
3. **Style-clone** — clone a reference video (`--reference-url` or `--reference-file`)

Infer aspect ratio from platform if mentioned: TikTok/Reels/Shorts → `9:16`
(default), YouTube → `16:9`, Instagram square → `1:1`.

## Step 2: Run the edit

Always pass `--output` so results land in the working directory (the CLI
creates the parent directory; its built-in default is a fixed absolute legacy
path). Keep commands on one line so the examples work in POSIX shells and
Windows terminals:

```bash
sparki run "<path>" --mode style-guided --style clips/highlight-reel --aspect-ratio 9:16 --output ./sparki-output/result.mp4
sparki run "<path>" --mode prompt-driven --prompt "<the user's request, verbatim>" --aspect-ratio 9:16 --output ./sparki-output/result.mp4
```

`sparki run` does the whole pipeline (upload → edit → poll → download) and
blocks until done. Cloud processing typically takes 5–20 minutes; for long
runs, consider running it in the background so you can keep working, or raise
`--timeout` (default 3600s; use 7200 for 30+ min videos).

Quote any file path that contains spaces.

Creating a new editing project may consume credits. Obtain the user's explicit
approval before the first run or before retrying a failed edit as a new project.
Checking or downloading an existing `task_id` does not create a new project.

### Multiple files

- **Combine into ONE output**: pass all files positionally in a single call —
  `sparki run a.mp4 b.mp4 c.mp4 --mode ...`
- **N separate outputs**: loop, one call per file.
- Ambiguous? Ask the user which they want.

## Step 3: Deliver

When done, report the absolute `local_path` and `output_directory`. Add
`--reveal` only when Claude is running on the user's computer with native GUI
access. Omit it for SSH, containers, and headless hosts. If reveal fails, keep
the successful local file and tell the user exactly where it is stored.

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
Follow the `action` field. Common: `AUTH_FAILED` (bad key → run `sparki connect
--channel claude --force --timeout 540`), `QUOTA_EXCEEDED` (top up at sparki.io), `INVALID_STYLE`
(show style list), `RENDER_TIMEOUT` (shorter clip or higher `--timeout`),
`STORAGE_FULL` (`sparki assets delete ...`). Full table in
`references/commands.md`.
