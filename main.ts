// gta6-clipper-01 entrypoint (Node 22, standard library only).
//
// The video itself is the entry. This program only hands the house the
// address of the YouTube video: it copies VIDEO.json from the repository
// root into the output directory, where the gate reads it. The house then
// reads the video's views through the YouTube Data API; nothing else this
// program writes is scored.
//
// VIDEO.json ships with a placeholder address until the clip is uploaded
// and its real YouTube address is written in (phase 2).
//
// Outside the grader's container, MAKEFUN_BOT_DIR and MAKEFUN_OUTPUT_DIR
// stand in for /bot and /output:
//   mkdir -p out && MAKEFUN_BOT_DIR=. MAKEFUN_OUTPUT_DIR=out node main.ts

import { copyFileSync, mkdirSync } from 'node:fs';
import { join } from 'node:path';

const repoRoot = process.env.MAKEFUN_BOT_DIR ?? '/bot';
const outDir = process.env.MAKEFUN_OUTPUT_DIR ?? '/output';

mkdirSync(outDir, { recursive: true });
try {
  copyFileSync(join(repoRoot, 'VIDEO.json'), join(outDir, 'VIDEO.json'));
} catch (err) {
  console.error(`could not copy VIDEO.json out of ${repoRoot}: ${(err as Error).message}`);
  process.exit(1);
}
