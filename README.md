# Invaders

A classic Space Invaders clone built with [Spinel](https://github.com/matz/spinel)
and [sdl](https://github.com/jockofcode/sdl) — a demo of the sdl bindings.

Five rows of hand-pixelled aliens march back and forth, speeding up as the
formation thins out and dropping a rank every time they hit a wall. Destructible
green bunkers erode as they take fire, a mystery UFO occasionally drifts across
the top of the screen for bonus points, and the game runs forever in waves that
get progressively faster.

## Requirements

- Spinel (`spin`)
- SDL3, statically linked via the `sdl` package — no `brew install` needed at build or run time

## Install Spinel

With `asdf`:

```bash
asdf plugin add spinel https://github.com/jockofcode/asdf-spinel
asdf install spinel master
asdf set -u spinel master   # make it the default (~/.tool-versions)
```

Or build it from source:

```bash
git clone https://github.com/matz/spinel.git
cd spinel
make
export PATH="$PWD/bin:$PATH"
cd -
```

## Play

```sh
spin run invaders
```

Or build first and run the binary directly:

```sh
spin build
./build/bin/invaders
```

## Controls

| Key | Action |
|---|---|
| Left / Right | Move ship |
| Space | Fire (one shot on screen at a time) |
| P | Pause |
| R | Restart (after game over) |
| Esc / Q | Quit |

## Scoring

| Alien | Points |
|---|---|
| Squid (top row) | 30 |
| Crab (middle rows) | 20 |
| Octopus (bottom rows) | 10 |
| UFO | 50 / 100 / 150 / 300 |

Losing all three lives, or letting the formation reach your bunkers, ends the game.
