# Sparki Video Editor — Claude Code Skill

AI video editing for creators, as a [Claude Code](https://claude.com/claude-code)
skill. All rendering runs on the cloud-hosted Sparki API (`agent-api.sparki.io`)
via `sparki-cli` — no ffmpeg, no local rendering.

## Layout

```
sparki-video-editor/
├── SKILL.md                    # instructions + metadata (loaded on demand)
├── scripts/
│   └── install.sh              # install the CLI and verify its executable
└── references/
    └── commands.md             # full command / style / error reference
```

## Supported surfaces

This repository is a Claude Code plugin for desktop and terminal environments.
It is not an installable Claude.ai browser integration. A browser-only Claude
surface requires a separately published remote integration, such as MCP.

## Install

Install the plugin from Claude Code:

```bash
claude plugin marketplace add https://github.com/sparki-ai/sparki-claude-code-skill.git
claude plugin install sparki-video-editor@sparki
claude plugin list
```

If the installed plugin is not active in the current session, run
`/reload-plugins --force` or restart Claude Code. Manual skill installation is
also supported by copying `sparki-video-editor/` into:

- Personal (all projects): `~/.claude/skills/`
- Project-scoped (checked in for your team): `.claude/skills/`

The bundled skill installs the engine and checks whether it is already
configured when first used:

```bash
bash sparki-video-editor/scripts/install.sh
sparki config-status --channel claude
sparki login --channel claude  # only when configured is false
sparki doctor --channel claude
```

Browser login reuses the existing Sparki email-code, Google, and Apple sign-in
flows, then shows an explicit approval prompt. No authorization code or API key
needs to be entered, printed, or pasted into Claude. Managed environments may
instead set both `SPARKI_API_KEY` and `SPARKI_CHANNEL=claude`.

## Usage

Just ask Claude to edit a video — the skill triggers on mentions of vlog / clip
/ short / reel / caption / montage / TikTok, etc.:

```
> Edit ./raw/trip.mp4 into a vertical travel highlight reel
```

Claude runs `sparki doctor --channel claude`, confirms your editing intent, then
`sparki run ... --output ./sparki-output/result.mp4`.

## Requirements

- [`uv`](https://docs.astral.sh/uv/) on PATH
- A Sparki account; first-time setup opens https://sparki.io for approval

## Notes

- Formats: mp4/mov, max 3GB. Processing typically 5–20 min.
- Config lives at `Path.home()/.sparki/config/config.json` on macOS, Linux, and
  Windows. The CLI still reads the old OpenClaw config as a fallback. Output
  keeps its legacy default, so the skill always passes `--output
  ./sparki-output/...`.

## License

MIT-0
