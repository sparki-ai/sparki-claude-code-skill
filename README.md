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

## Install

Copy the `sparki-video-editor/` directory into your Claude Code skills folder:

- Personal (all projects): `~/.claude/skills/`
- Project-scoped (checked in for your team): `.claude/skills/`

Then install the engine and configure your key:

```bash
bash sparki-video-editor/scripts/install.sh
sparki setup --api-key <YOUR_KEY> --channel claude  # get a key at https://sparki.io/claude-code-skill
sparki doctor --channel claude
```

(Or set both `SPARKI_API_KEY` and `SPARKI_CHANNEL=claude` in your environment
instead of running `sparki setup`.)

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
- A Sparki API key from https://sparki.io/claude-code-skill

## Notes

- Formats: mp4/mov, max 3GB. Processing typically 5–20 min.
- Config lives at `~/.openclaw/config/sparki.json` (legacy dir name — does NOT
  require OpenClaw). Output defaults there too, so the skill always passes
  `--output ./sparki-output/...`.

## License

MIT-0
