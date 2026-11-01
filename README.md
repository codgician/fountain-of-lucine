# ⛲️ Fountain Of Lucine

[![build](https://github.com/codgician/fountain-of-lucine/actions/workflows/build.yml/badge.svg)](https://github.com/codgician/fountain-of-lucine/actions/workflows/build.yml)
[![evergreen](https://github.com/codgician/fountain-of-lucine/actions/workflows/evergreen.yml/badge.svg)](https://github.com/codgician/fountain-of-lucine/actions/workflows/evergreen.yml)

Where all water gathers: the origin of all my ImmortalWrt device images.

Each router in `routers/` picks a channel from [immortalwrt.nix](https://github.com/codgician/immortalwrt.nix) and builds its image with that channel's `mkImage`. The target and device profile are checked against the channel when the flake is evaluated. Release channels such as `immortalwrt-25.12` follow upstream point releases automatically.

All images are built weekly and published to releases.
