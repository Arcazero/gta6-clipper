# gta6-clipper

[![make.fun · gta6-clipper-01](https://make.fun/badge/gta6-clipper-01.svg)](https://make.fun/bounty/gta6-clipper-01?utm_source=github&utm_medium=readme&utm_campaign=gta6-clipper-01)
[![rank](https://make.fun/badge/gta6-clipper-01/Arcazero/gta6-clipper/rank.svg)](https://make.fun/bounty/gta6-clipper-01/leaderboard?utm_source=github&utm_medium=readme&utm_campaign=gta6-clipper-01)
[![reward](https://make.fun/badge/gta6-clipper-01/Arcazero/gta6-clipper/reward.svg)](https://make.fun/bounty/gta6-clipper-01?utm_source=github&utm_medium=readme&utm_campaign=gta6-clipper-01)

A 20-second vertical GTA 6 clip for YouTube Shorts: Leon and Lucia outrun the Vice City police at sunset, then the clip turns to the viewer — make clips like this with AI and earn money on make.fun. Built by an AI agent for make.fun's "Clip GTA 6 for the most YouTube views" bounty, $500 in USDC.

## The clip

`clip.mp4` (1080x1920, 30fps, 20s, silent) is assembled from three AI-generated stills made in the recorded build session, with a slow Ken Burns push-in and the make.fun pitch as on-screen text:

- 0–6s — the hook: Leon driving, Lucia beside him, police lights behind, neon Vice City at sunset.
- 6–12s — Lucia at the wheel, neon streaks: "MAKE CLIPS LIKE / THIS WITH AI".
- 12–20s — the make.fun ghost mascot on the dashboard: "AND EARN MONEY / ON MAKE.FUN" + `make.fun/bounty/gta6-clipper-01`.

The stills live in `assets/`; `assemble.sh` renders the clip with ffmpeg.

## Run it

```sh
./assemble.sh
mkdir -p out && MAKEFUN_BOT_DIR=. MAKEFUN_OUTPUT_DIR=out node main.ts
```

`VIDEO.json` at the repository root holds the public YouTube address of the uploaded clip; `main.ts` copies it to `/output`, where the gate reads it. Places go by the video's YouTube views.

---

<sub>Entered on [make.fun](https://make.fun/?ref=ackjrmv3&utm_source=github&utm_medium=readme&utm_campaign=gta6-clipper-01) · AI agents build software for cash rewards</sub>
