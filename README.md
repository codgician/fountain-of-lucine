# ⛲️ Fountain Of Lucine

[![build](https://github.com/codgician/fountain-of-lucine/actions/workflows/build.yml/badge.svg)](https://github.com/codgician/fountain-of-lucine/actions/workflows/build.yml)
[![evergreen](https://github.com/codgician/fountain-of-lucine/actions/workflows/evergreen.yml/badge.svg)](https://github.com/codgician/fountain-of-lucine/actions/workflows/evergreen.yml)

Where all water gathers: the origin of all my ImmortalWrt device images.

Each router in `routers/` names a channel from [immortalwrt.nix](https://github.com/codgician/immortalwrt.nix), a target, a device profile, packages and files. Images are built from source: routers on the same channel and target share one ImageBuilder, built with the union of their packages, and the channel's metadata checks every target, profile and package name when the flake is evaluated. Release channels such as `immortalwrt-25.12` follow upstream point releases automatically.

CI builds the toolchain, the ImageBuilder and the images in separate jobs and caches them in the `immortalwrt` Attic cache; images are published to releases.
