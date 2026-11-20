#!/usr/bin/env bash
# Assemble clip.mp4 for the gta6-clipper-01 entry: a vertical 9:16 YouTube Short.
# Three AI-generated stills (made in this session) get a slow Ken Burns zoom,
# then the make.fun pitch goes on screen as text in the second half.
#   0-6s   frame1 (Vice City chase, Leon driving, Lucia beside, police behind) — hook, no text
#   6-12s  frame2 (Lucia driving, Leon shotgun, neon streaks) — "MAKE CLIPS LIKE THIS WITH AI"
#   12-20s frame3 (make.fun ghost mascot on the dashboard) — "AND EARN MONEY ON MAKE.FUN"
#          + "make.fun/bounty/gta6-clipper-01"
# Total 20s, 1080x1920, 30fps, H.264, silent. Under a minute, so YouTube treats it as a Short.
#
# NOTE: ffmpeg's zoompan filter was far too slow here (~2s/frame, single-threaded
# resampling), so the zoom is pre-rendered as JPEG frames by render_frames.py
# (PIL, C-speed) and ffmpeg only encodes + draws text.
set -euo pipefail
cd "$(dirname "$0")"
FONT=/usr/share/fonts/truetype/dejavu/DejaVuSans-Bold.ttf
OUT=clip.mp4
ENC="-c:v libx264 -pix_fmt yuv420p -r 30 -crf 26 -maxrate 6M -bufsize 12M -an"

python3 render_frames.py

# Segment 1: hook, no text.
ffmpeg -y -v error -framerate 30 -i frames/seg1/%04d.jpg \
  $ENC seg1.mp4

# Segment 2: pitch line 1 on screen (t 0.5-5.5 of the segment), split over two
# lines in the dark lower third so it never covers the faces or runs off the edges.
ffmpeg -y -v error -framerate 30 -i frames/seg2/%04d.jpg \
  -vf "drawtext=fontfile=$FONT:text='MAKE CLIPS LIKE':fontsize=58:fontcolor=white:borderw=3:bordercolor=black:box=1:boxcolor=black@0.45:boxborderw=24:x=(w-text_w)/2:y=1420:enable='between(t,0.5,5.5)',drawtext=fontfile=$FONT:text='THIS WITH AI':fontsize=58:fontcolor=white:borderw=3:bordercolor=black:box=1:boxcolor=black@0.45:boxborderw=24:x=(w-text_w)/2:y=1510:enable='between(t,0.5,5.5)'" \
  $ENC seg2.mp4

# Segment 3: pitch line 2, then the bounty page (t 0.5-4.0 and 4.5-7.5 of the segment).
ffmpeg -y -v error -framerate 30 -i frames/seg3/%04d.jpg \
  -vf "drawtext=fontfile=$FONT:text='AND EARN MONEY':fontsize=58:fontcolor=white:borderw=3:bordercolor=black:box=1:boxcolor=black@0.45:boxborderw=24:x=(w-text_w)/2:y=1380:enable='between(t,0.5,4.0)',drawtext=fontfile=$FONT:text='ON MAKE.FUN':fontsize=58:fontcolor=white:borderw=3:bordercolor=black:box=1:boxcolor=black@0.45:boxborderw=24:x=(w-text_w)/2:y=1470:enable='between(t,0.5,4.0)',drawtext=fontfile=$FONT:text='make.fun/bounty/gta6-clipper-01':fontsize=44:fontcolor=white:borderw=3:bordercolor=black:box=1:boxcolor=black@0.45:boxborderw=20:x=(w-text_w)/2:y=1580:enable='between(t,4.5,7.5)'" \
  $ENC seg3.mp4

# Concatenate the three segments.
printf "file 'seg1.mp4'\nfile 'seg2.mp4'\nfile 'seg3.mp4'\n" > concat.txt
ffmpeg -y -v error -f concat -safe 0 -i concat.txt -c copy "$OUT"

# Verify + preview frames for a legibility check.
ffprobe -v error -show_entries format=duration,size -show_entries stream=width,height,codec_name,r_frame_rate -of default=noprint_wrappers=1 "$OUT"
for t in 3 9 15 18; do
  ffmpeg -y -v error -ss "$t" -i "$OUT" -frames:v 1 "preview-$t.png"
done
ls -la "$OUT" preview-*.png
