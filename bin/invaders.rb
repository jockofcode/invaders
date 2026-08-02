require "sdl"

SDL::Log.open("/tmp/sdl_invaders.log")

WIDTH  = 800
HEIGHT = 700
SCALE  = 3

# Builds a run of n copies of ch. Sprite bitmaps below are assembled from
# these runs (rather than typed out char-by-char) so each row's width is a
# checkable sum instead of something to count by eye.
def rep(ch, n)
  s = ""
  i = 0
  while i < n
    s += ch
    i += 1
  end
  s
end

# ---- Sprites (pixel-art bitmaps, "X" = filled cell) ----

SQUID_FRAME0 = [
  rep(".", 2) + "X" + rep(".", 2) + "X" + rep(".", 2),
  rep(".", 3) + rep("X", 2) + rep(".", 3),
  rep(".", 2) + rep("X", 4) + rep(".", 2),
  "." + rep("X", 2) + rep(".", 2) + rep("X", 2) + ".",
  rep("X", 8),
  "X" + "." + rep("X", 4) + "." + "X",
  "X" + "." + "X" + rep(".", 2) + "X" + "." + "X",
  rep(".", 2) + "X" + rep(".", 2) + "X" + rep(".", 2),
]

SQUID_FRAME1 = [
  SQUID_FRAME0[0],
  SQUID_FRAME0[1],
  SQUID_FRAME0[2],
  SQUID_FRAME0[3],
  SQUID_FRAME0[4],
  SQUID_FRAME0[5],
  "X" + rep(".", 2) + rep("X", 2) + rep(".", 2) + "X",
  "." + "X" + "." + rep("X", 2) + "." + "X" + ".",
]

CRAB_FRAME0 = [
  rep(".", 2) + "X" + rep(".", 5) + "X" + rep(".", 2),
  rep(".", 3) + "X" + rep(".", 3) + "X" + rep(".", 3),
  rep(".", 2) + rep("X", 7) + rep(".", 2),
  "." + rep("X", 2) + "." + rep("X", 3) + "." + rep("X", 2) + ".",
  rep("X", 11),
  "X" + "." + rep("X", 7) + "." + "X",
  "X" + "." + "X" + rep(".", 5) + "X" + "." + "X",
  rep(".", 3) + rep("X", 2) + "." + rep("X", 2) + rep(".", 3),
]

CRAB_FRAME1 = [
  CRAB_FRAME0[0],
  "X" + rep(".", 2) + "X" + rep(".", 3) + "X" + rep(".", 2) + "X",
  CRAB_FRAME0[5],
  rep("X", 3) + "." + rep("X", 3) + "." + rep("X", 3),
  rep("X", 11),
  "." + rep("X", 9) + ".",
  CRAB_FRAME0[0],
  "." + "X" + rep(".", 7) + "X" + ".",
]

OCTO_FRAME0 = [
  rep(".", 3) + rep("X", 6) + rep(".", 3),
  rep(".", 2) + rep("X", 8) + rep(".", 2),
  "." + rep("X", 2) + "." + rep("X", 4) + "." + rep("X", 2) + ".",
  rep("X", 3) + "." + rep("X", 4) + "." + rep("X", 3),
  rep("X", 12),
  rep("X", 2) + "." + rep("X", 2) + rep(".", 2) + rep("X", 2) + "." + rep("X", 2),
  "." + "X" + rep(".", 2) + "X" + rep(".", 2) + "X" + rep(".", 2) + "X" + ".",
  rep(".", 2) + "X" + "." + "X" + rep(".", 2) + "X" + "." + "X" + rep(".", 2),
]

OCTO_FRAME1 = [
  OCTO_FRAME0[0],
  OCTO_FRAME0[1],
  OCTO_FRAME0[2],
  OCTO_FRAME0[3],
  OCTO_FRAME0[4],
  OCTO_FRAME0[5],
  "X" + rep(".", 4) + rep("X", 2) + rep(".", 4) + "X",
  rep(".", 2) + "X" + rep(".", 2) + rep("X", 2) + rep(".", 2) + "X" + rep(".", 2),
]

PLAYER_SPRITE = [
  rep(".", 6) + "X" + rep(".", 6),
  rep(".", 5) + rep("X", 3) + rep(".", 5),
  rep(".", 5) + rep("X", 3) + rep(".", 5),
  rep("X", 13),
  rep("X", 13),
  rep("X", 13),
  rep("X", 13),
  rep("X", 13),
]

UFO_HALF_DOME = "." + "X" + "." + "X" + "." + "X" + "."
UFO_HALF_BODY = "." + rep("X", 5) + "."

UFO_SPRITE = [
  rep(".", 5) + rep("X", 4) + rep(".", 5),
  rep(".", 3) + rep("X", 8) + rep(".", 3),
  rep(".", 2) + rep("X", 10) + rep(".", 2),
  rep("X", 14),
  UFO_HALF_DOME + UFO_HALF_DOME,
  UFO_HALF_BODY + UFO_HALF_BODY,
  rep(".", 4) + rep("X", 2) + rep(".", 2) + rep("X", 2) + rep(".", 4),
]

BARRIER_MASK = [
  rep(".", 2) + rep("X", 7) + rep(".", 2),
  "." + rep("X", 9) + ".",
  rep("X", 11),
  rep("X", 11),
  rep("X", 3) + rep(".", 5) + rep("X", 3),
  rep("X", 2) + rep(".", 7) + rep("X", 2),
]

ALIEN_FRAMES = [
  [SQUID_FRAME0, SQUID_FRAME1],
  [CRAB_FRAME0, CRAB_FRAME1],
  [OCTO_FRAME0, OCTO_FRAME1],
]
ALIEN_COLORS = [SDL::Color::CYAN, SDL::Color::YELLOW, SDL::Color::ORANGE]
ALIEN_POINTS = [30, 20, 10]
ALIEN_W = [
  SQUID_FRAME0[0].length * SCALE,
  CRAB_FRAME0[0].length * SCALE,
  OCTO_FRAME0[0].length * SCALE,
]
ALIEN_H = [
  SQUID_FRAME0.length * SCALE,
  CRAB_FRAME0.length * SCALE,
  OCTO_FRAME0.length * SCALE,
]

PLAYER_W = PLAYER_SPRITE[0].length * SCALE
PLAYER_H = PLAYER_SPRITE.length * SCALE
UFO_W    = UFO_SPRITE[0].length * SCALE
UFO_H    = UFO_SPRITE.length * SCALE

BARRIER_SCALE = 6
BARRIER_COUNT = 4
BARRIER_W     = BARRIER_MASK[0].length * BARRIER_SCALE
BARRIER_H     = BARRIER_MASK.length * BARRIER_SCALE

# ---- Layout ----

ALIEN_COLS = 11
ALIEN_ROWS = 5
CELL_W     = 54
CELL_H     = 40
GRID_TOP   = 90
GRID_LEFT  = (WIDTH - ALIEN_COLS * CELL_W) / 2

EDGE_MARGIN = 16
STEP_X      = 10
DROP_Y      = 16

PLAYER_Y     = HEIGHT - 70
PLAYER_SPEED = 6

PLAYER_BULLET_W     = 3
PLAYER_BULLET_H     = 14
PLAYER_BULLET_SPEED = 9

ALIEN_BULLET_W       = 3
ALIEN_BULLET_H       = 12
ALIEN_BULLET_SPEED   = 5
MAX_ALIEN_BULLETS    = 3
SHOOT_CHANCE_PERCENT = 35

BARRIER_Y   = PLAYER_Y - 130
INVASION_Y  = PLAYER_Y - 20

LIVES_START = 3
INVULN_MS   = 1500

UFO_Y            = 48
UFO_SPEED        = 4
UFO_MIN_GAP      = 9000
UFO_GAP_RANGE    = 8000
UFO_BONUS        = [50, 100, 150, 300]

EXPLOSION_DIRS = [
  [1.0, 0.0], [0.7071, 0.7071], [0.0, 1.0], [-0.7071, 0.7071],
  [-1.0, 0.0], [-0.7071, -0.7071], [0.0, -1.0], [0.7071, -0.7071],
]
EXPLOSION_SPEED = 2.4
EXPLOSION_LIFE  = 18

STAR_COUNT     = 90
WAVE_INTRO_MS  = 1400
FRAME_MS       = 16

BG_COLOR             = [8, 8, 20, 255]
HUD_COLOR            = SDL::Color::WHITE
PLAYER_COLOR         = SDL::Color::GREEN
PLAYER_BULLET_COLOR  = SDL::Color::WHITE
ALIEN_BULLET_COLOR   = SDL::Color::RED
BARRIER_COLOR        = SDL::Color::GREEN
UFO_COLOR            = SDL::Color::MAGENTA

LEFT_KEY  = LibSDL::K_LEFT
RIGHT_KEY = LibSDL::K_RIGHT
R_KEY     = "r".ord
P_KEY     = "p".ord
Q_KEY     = "q".ord

# ---- Small helpers ----

def rects_overlap?(ax, ay, aw, ah, bx, by, bw, bh)
  ax < bx + bw && ax + aw > bx && ay < by + bh && ay + ah > by
end

def draw_sprite(renderer, rows, x, y, scale, r, g, b, a)
  renderer.draw_color(r, g, b, a)
  ri = 0
  while ri < rows.length
    row = rows[ri]
    ci = 0
    while ci < row.length
      if row[ci] == "X"
        run_start = ci
        while ci < row.length && row[ci] == "X"
          ci += 1
        end
        renderer.fill_rect(x + run_start * scale, y + ri * scale, (ci - run_start) * scale, scale)
      else
        ci += 1
      end
    end
    ri += 1
  end
end

def alien_type_for_row(row)
  return 0 if row == 0
  return 1 if row == 1 || row == 2
  2
end

# ---- World setup ----

def new_aliens
  aliens = []
  row = 0
  while row < ALIEN_ROWS
    type = alien_type_for_row(row)
    w = ALIEN_W[type]
    col = 0
    while col < ALIEN_COLS
      cell_x = GRID_LEFT + col * CELL_W
      aliens.push({
        row:   row,
        col:   col,
        type:  type,
        x:     cell_x + (CELL_W - w) / 2,
        y:     GRID_TOP + row * CELL_H,
        alive: true,
      })
      col += 1
    end
    row += 1
  end
  aliens
end

def build_barrier_cells
  cells = []
  r = 0
  while r < BARRIER_MASK.length
    row_cells = []
    c = 0
    while c < BARRIER_MASK[r].length
      row_cells.push(BARRIER_MASK[r][c] == "X")
      c += 1
    end
    cells.push(row_cells)
    r += 1
  end
  cells
end

def new_barriers
  barriers = []
  i = 1
  while i <= BARRIER_COUNT
    center_x = (WIDTH * i) / (BARRIER_COUNT + 1)
    barriers.push({ x: center_x - BARRIER_W / 2, y: BARRIER_Y, cells: build_barrier_cells })
    i += 1
  end
  barriers
end

def build_starfield(count)
  stars = []
  i = 0
  while i < count
    stars.push({ x: rand(WIDTH), y: 40 + rand(HEIGHT - 40), size: 1 + rand(2), seed: rand(3) })
    i += 1
  end
  stars
end

def start_wave(state, wave, now)
  aliens = new_aliens
  state[:wave]            = wave
  state[:aliens]          = aliens
  state[:alien_total]     = aliens.length
  state[:alien_alive]     = aliens.length
  state[:alien_dir]       = 1
  state[:alien_frame]     = 0
  state[:last_alien_step] = now
  state[:bullets_player]  = []
  state[:bullets_alien]   = []
  state[:barriers]        = new_barriers
  state[:wave_intro]      = WAVE_INTRO_MS
end

def new_game(now)
  state = {
    player_x:     (WIDTH - PLAYER_W) / 2,
    move_left:    false,
    move_right:   false,
    lives:        LIVES_START,
    score:        0,
    game_over:    false,
    paused:       false,
    invuln:       false,
    invuln_until: 0,
    explosions:   [],
    ufo:          nil,
    next_ufo_at:  now + UFO_MIN_GAP + rand(UFO_GAP_RANGE),
  }
  start_wave(state, 1, now)
  state
end

# ---- Updates ----

def update_player(state)
  state[:player_x] -= PLAYER_SPEED if state[:move_left]
  state[:player_x] += PLAYER_SPEED if state[:move_right]
  state[:player_x] = 0 if state[:player_x] < 0
  state[:player_x] = WIDTH - PLAYER_W if state[:player_x] > WIDTH - PLAYER_W
end

def fire_player_bullet(state)
  return if state[:bullets_player].length > 0
  bx = state[:player_x] + PLAYER_W / 2 - PLAYER_BULLET_W / 2
  state[:bullets_player].push({ x: bx, y: PLAYER_Y - 6 })
end

def update_bullets_player(state)
  state[:bullets_player].each { |b| b[:y] -= PLAYER_BULLET_SPEED }
  state[:bullets_player] = state[:bullets_player].select { |b| b[:y] + PLAYER_BULLET_H > 0 }
end

def update_bullets_alien(state)
  state[:bullets_alien].each { |b| b[:y] += ALIEN_BULLET_SPEED }
  state[:bullets_alien] = state[:bullets_alien].select { |b| b[:y] < HEIGHT }
end

def alien_bounds(state)
  min_x = WIDTH
  max_x = 0
  state[:aliens].each do |a|
    next unless a[:alive]
    right = a[:x] + ALIEN_W[a[:type]]
    min_x = a[:x] if a[:x] < min_x
    max_x = right if right > max_x
  end
  [min_x, max_x]
end

def bottom_shooters(aliens)
  shooters = []
  col = 0
  while col < ALIEN_COLS
    best = nil
    aliens.each do |a|
      if a[:alive] && a[:col] == col
        best = a if best == nil || a[:row] > best[:row]
      end
    end
    shooters.push(best) if best != nil
    col += 1
  end
  shooters
end

def maybe_alien_shoot(state)
  return if state[:bullets_alien].length >= MAX_ALIEN_BULLETS
  return if rand(100) >= SHOOT_CHANCE_PERCENT

  shooters = bottom_shooters(state[:aliens])
  return if shooters.length == 0

  shooter = shooters[rand(shooters.length)]
  w = ALIEN_W[shooter[:type]]
  h = ALIEN_H[shooter[:type]]
  state[:bullets_alien].push({ x: shooter[:x] + w / 2 - ALIEN_BULLET_W / 2, y: shooter[:y] + h })
end

def step_aliens(state)
  min_x, max_x = alien_bounds(state)
  dir = state[:alien_dir]
  will_hit = (dir == 1 && max_x + STEP_X > WIDTH - EDGE_MARGIN) ||
             (dir == -1 && min_x - STEP_X < EDGE_MARGIN)

  if will_hit
    state[:aliens].each { |a| a[:y] += DROP_Y if a[:alive] }
    state[:alien_dir] = 0 - dir
  else
    state[:aliens].each { |a| a[:x] = a[:x] + STEP_X * dir if a[:alive] }
  end

  state[:alien_frame] = 1 - state[:alien_frame]
end

def alien_interval(state)
  wave = state[:wave]

  min_ms = 90 - (wave - 1) * 3
  min_ms = 35 if min_ms < 35
  max_ms = 650 - (wave - 1) * 25
  max_ms = 220 if max_ms < 220

  ratio = state[:alien_alive].to_f / state[:alien_total].to_f
  (min_ms + ratio * (max_ms - min_ms)).round
end

def update_aliens(state, now)
  return if state[:alien_alive] <= 0
  if now - state[:last_alien_step] >= alien_interval(state)
    step_aliens(state)
    state[:last_alien_step] = now
    maybe_alien_shoot(state)
  end
end

def update_ufo(state, now)
  if state[:ufo] == nil
    if now >= state[:next_ufo_at]
      dir = rand(2) == 0 ? 1 : -1
      state[:ufo] = { x: dir == 1 ? (0 - UFO_W) : WIDTH, dir: dir }
    end
  else
    u = state[:ufo]
    u[:x] = u[:x] + UFO_SPEED * u[:dir]
    if u[:x] < 0 - UFO_W - 10 || u[:x] > WIDTH + 10
      state[:ufo] = nil
      state[:next_ufo_at] = now + UFO_MIN_GAP + rand(UFO_GAP_RANGE)
    end
  end
end

def spawn_explosion(state, cx, cy, color)
  particles = []
  i = 0
  while i < EXPLOSION_DIRS.length
    d = EXPLOSION_DIRS[i]
    particles.push({ px: cx.to_f, py: cy.to_f, vx: d[0] * EXPLOSION_SPEED, vy: d[1] * EXPLOSION_SPEED })
    i += 1
  end
  state[:explosions].push({ particles: particles, life: EXPLOSION_LIFE, color: color })
end

def update_explosions(state)
  state[:explosions].each do |e|
    e[:life] -= 1
    e[:particles].each do |p|
      p[:px] = p[:px] + p[:vx]
      p[:py] = p[:py] + p[:vy]
    end
  end
  state[:explosions] = state[:explosions].select { |e| e[:life] > 0 }
end

def hit_barrier(bar, x, y, w, h)
  return false unless rects_overlap?(x, y, w, h, bar[:x], bar[:y], BARRIER_W, BARRIER_H)

  hit = false
  r = 0
  while r < bar[:cells].length
    c = 0
    while c < bar[:cells][r].length
      if !hit && bar[:cells][r][c]
        cx = bar[:x] + c * BARRIER_SCALE
        cy = bar[:y] + r * BARRIER_SCALE
        if rects_overlap?(x, y, w, h, cx, cy, BARRIER_SCALE, BARRIER_SCALE)
          bar[:cells][r][c] = false
          hit = true
        end
      end
      c += 1
    end
    r += 1
  end
  hit
end

def hit_player(state, now)
  spawn_explosion(state, state[:player_x] + PLAYER_W / 2, PLAYER_Y + PLAYER_H / 2, PLAYER_COLOR)
  state[:lives] -= 1
  if state[:lives] <= 0
    state[:game_over] = true
  else
    state[:player_x]     = (WIDTH - PLAYER_W) / 2
    state[:invuln_until] = now + INVULN_MS
  end
end

def check_player_bullets(state, now)
  state[:bullets_player].each do |b|
    next if b[:dead]

    state[:aliens].each do |a|
      next unless a[:alive]
      next if b[:dead]
      w = ALIEN_W[a[:type]]
      h = ALIEN_H[a[:type]]
      if rects_overlap?(b[:x], b[:y], PLAYER_BULLET_W, PLAYER_BULLET_H, a[:x], a[:y], w, h)
        a[:alive]            = false
        b[:dead]             = true
        state[:alien_alive] -= 1
        state[:score]        = state[:score] + ALIEN_POINTS[a[:type]]
        spawn_explosion(state, a[:x] + w / 2, a[:y] + h / 2, ALIEN_COLORS[a[:type]])
      end
    end

    if !b[:dead] && state[:ufo] != nil
      u = state[:ufo]
      if rects_overlap?(b[:x], b[:y], PLAYER_BULLET_W, PLAYER_BULLET_H, u[:x], UFO_Y, UFO_W, UFO_H)
        state[:score] = state[:score] + UFO_BONUS[rand(UFO_BONUS.length)]
        spawn_explosion(state, u[:x] + UFO_W / 2, UFO_Y + UFO_H / 2, UFO_COLOR)
        state[:ufo]         = nil
        state[:next_ufo_at] = now + UFO_MIN_GAP + rand(UFO_GAP_RANGE)
        b[:dead]            = true
      end
    end

    if !b[:dead]
      state[:barriers].each do |bar|
        next if b[:dead]
        b[:dead] = true if hit_barrier(bar, b[:x], b[:y], PLAYER_BULLET_W, PLAYER_BULLET_H)
      end
    end
  end

  state[:bullets_player] = state[:bullets_player].select { |b| !b[:dead] }
end

def check_alien_bullets(state, now)
  state[:bullets_alien].each do |b|
    next if b[:dead]

    if !state[:invuln] && rects_overlap?(b[:x], b[:y], ALIEN_BULLET_W, ALIEN_BULLET_H,
                                          state[:player_x], PLAYER_Y, PLAYER_W, PLAYER_H)
      b[:dead] = true
      hit_player(state, now)
    end

    if !b[:dead]
      state[:barriers].each do |bar|
        next if b[:dead]
        b[:dead] = true if hit_barrier(bar, b[:x], b[:y], ALIEN_BULLET_W, ALIEN_BULLET_H)
      end
    end
  end

  state[:bullets_alien] = state[:bullets_alien].select { |b| !b[:dead] }
end

def check_invasion(state)
  state[:aliens].each do |a|
    next unless a[:alive]
    state[:game_over] = true if a[:y] + ALIEN_H[a[:type]] >= INVASION_Y
  end
end

def update_game(state, now)
  state[:invuln] = now < state[:invuln_until]

  if state[:wave_intro] > 0
    state[:wave_intro] -= FRAME_MS
    return
  end

  update_player(state)
  update_aliens(state, now)
  update_bullets_player(state)
  update_bullets_alien(state)
  update_ufo(state, now)
  update_explosions(state)

  check_player_bullets(state, now)
  check_alien_bullets(state, now)
  check_invasion(state)

  if state[:alien_alive] <= 0 && !state[:game_over]
    start_wave(state, state[:wave] + 1, now)
  end
end

# ---- Rendering ----

def draw_starfield(renderer, now, stars)
  stars.each do |s|
    level = (now / 350 + s[:seed]) % 3
    v = 90 + level * 55
    renderer.draw_color(v, v, v, 255)
    renderer.fill_rect(s[:x], s[:y], s[:size], s[:size])
  end
end

def draw_aliens(renderer, state)
  state[:aliens].each do |a|
    next unless a[:alive]
    rows  = ALIEN_FRAMES[a[:type]][state[:alien_frame]]
    color = ALIEN_COLORS[a[:type]]
    draw_sprite(renderer, rows, a[:x], a[:y], SCALE, color[0], color[1], color[2], color[3])
  end
end

def draw_player(renderer, state, now)
  return if state[:invuln] && (now / 100) % 2 == 0
  c = PLAYER_COLOR
  draw_sprite(renderer, PLAYER_SPRITE, state[:player_x], PLAYER_Y, SCALE, c[0], c[1], c[2], c[3])
end

def draw_bullets(renderer, state)
  pc = PLAYER_BULLET_COLOR
  renderer.draw_color(pc[0], pc[1], pc[2], pc[3])
  state[:bullets_player].each { |b| renderer.fill_rect(b[:x], b[:y], PLAYER_BULLET_W, PLAYER_BULLET_H) }

  ac = ALIEN_BULLET_COLOR
  renderer.draw_color(ac[0], ac[1], ac[2], ac[3])
  state[:bullets_alien].each { |b| renderer.fill_rect(b[:x], b[:y], ALIEN_BULLET_W, ALIEN_BULLET_H) }
end

def draw_barriers(renderer, state)
  c = BARRIER_COLOR
  renderer.draw_color(c[0], c[1], c[2], c[3])
  state[:barriers].each do |bar|
    r = 0
    while r < bar[:cells].length
      c2 = 0
      while c2 < bar[:cells][r].length
        if bar[:cells][r][c2]
          renderer.fill_rect(bar[:x] + c2 * BARRIER_SCALE, bar[:y] + r * BARRIER_SCALE, BARRIER_SCALE, BARRIER_SCALE)
        end
        c2 += 1
      end
      r += 1
    end
  end
end

def draw_ufo(renderer, state)
  return if state[:ufo] == nil
  u = state[:ufo]
  c = UFO_COLOR
  draw_sprite(renderer, UFO_SPRITE, u[:x], UFO_Y, SCALE, c[0], c[1], c[2], c[3])
end

def draw_explosions(renderer, state)
  state[:explosions].each do |e|
    c = e[:color]
    renderer.draw_color(c[0], c[1], c[2], c[3])
    e[:particles].each { |p| renderer.fill_rect(p[:px].round, p[:py].round, 3, 3) }
  end
end

def draw_lives(renderer, state)
  c = PLAYER_COLOR
  n = state[:lives]
  n = 0 if n < 0
  i = 0
  while i < n
    draw_sprite(renderer, PLAYER_SPRITE, WIDTH - 30 - i * 24, 12, 1, c[0], c[1], c[2], c[3])
    i += 1
  end
end

def draw_hud(renderer, font, state)
  hud = HUD_COLOR
  renderer.draw_text(font, "SCORE #{state[:score]}", 16, 8, hud[0], hud[1], hud[2], hud[3])

  wave_label = "WAVE #{state[:wave]}"
  renderer.draw_text(font, wave_label, WIDTH / 2 - wave_label.length * 6, 8, hud[0], hud[1], hud[2], hud[3])

  draw_lives(renderer, state)

  renderer.draw_color(50, 50, 70, 255)
  renderer.draw_line(0, 34, WIDTH, 34)

  renderer.draw_text(font, "ARROWS MOVE   SPACE FIRE   P PAUSE   ESC QUIT", 16, HEIGHT - 24, 90, 90, 110, 255)
end

def draw_overlays(renderer, font, big_font, state)
  if state[:game_over]
    warn = SDL::Color::RED
    t1 = "GAME OVER"
    renderer.draw_text(big_font, t1, WIDTH / 2 - t1.length * 11, HEIGHT / 2 - 60, warn[0], warn[1], warn[2], warn[3])

    hud = HUD_COLOR
    t2 = "FINAL SCORE #{state[:score]}"
    renderer.draw_text(font, t2, WIDTH / 2 - t2.length * 6, HEIGHT / 2 - 6, hud[0], hud[1], hud[2], hud[3])

    t3 = "R to restart    Esc to quit"
    renderer.draw_text(font, t3, WIDTH / 2 - t3.length * 6, HEIGHT / 2 + 22, hud[0], hud[1], hud[2], hud[3])
  elsif state[:wave_intro] > 0
    hud = HUD_COLOR
    t1 = "WAVE #{state[:wave]}"
    renderer.draw_text(big_font, t1, WIDTH / 2 - t1.length * 11, HEIGHT / 2 - 50, hud[0], hud[1], hud[2], hud[3])

    t2 = "GET READY"
    renderer.draw_text(font, t2, WIDTH / 2 - t2.length * 6, HEIGHT / 2 + 6, hud[0], hud[1], hud[2], hud[3])
  elsif state[:paused]
    hud = HUD_COLOR
    t = "PAUSED"
    renderer.draw_text(big_font, t, WIDTH / 2 - t.length * 11, HEIGHT / 2 - 24, hud[0], hud[1], hud[2], hud[3])
  end
end

def render(renderer, font, big_font, state, now, stars)
  bg = BG_COLOR
  renderer.draw_color(bg[0], bg[1], bg[2], bg[3])
  renderer.clear

  draw_starfield(renderer, now, stars)
  draw_barriers(renderer, state)
  draw_aliens(renderer, state)
  draw_ufo(renderer, state)
  draw_player(renderer, state, now)
  draw_bullets(renderer, state)
  draw_explosions(renderer, state)
  draw_hud(renderer, font, state)
  draw_overlays(renderer, font, big_font, state)

  renderer.present
end

# ---- Main loop ----

SDL::Screen.open("Invaders", width: WIDTH, height: HEIGHT, flags: 0) do |window, renderer|
  window.title = "Invaders"
  font     = SDL::Font.bundled(SDL::Fonts::VT323_NAME, 20)
  big_font = SDL::Font.bundled(SDL::Fonts::VT323_NAME, 46)
  stars    = build_starfield(STAR_COUNT)
  state    = new_game(SDL::Screen.ticks)
  running  = true

  while running
    now = SDL::Screen.ticks

    while (event_type = SDL::Event.poll)
      if event_type == LibSDL::QUIT
        running = false
      elsif event_type == LibSDL::KEYDOWN
        key = SDL::Event.key_sym

        if key == LibSDL::K_ESCAPE || key == Q_KEY
          running = false
        elsif state[:game_over]
          state = new_game(now) if key == R_KEY
        elsif key == P_KEY
          state[:paused] = !state[:paused]
        elsif !state[:paused] && state[:wave_intro] <= 0
          if key == LEFT_KEY
            state[:move_left] = true
          elsif key == RIGHT_KEY
            state[:move_right] = true
          elsif key == LibSDL::K_SPACE
            fire_player_bullet(state)
          end
        end
      elsif event_type == LibSDL::KEYUP
        key = SDL::Event.key_sym
        state[:move_left]  = false if key == LEFT_KEY
        state[:move_right] = false if key == RIGHT_KEY
      end
    end

    update_game(state, now) if !state[:game_over] && !state[:paused]

    render(renderer, font, big_font, state, now, stars)
    SDL::Screen.delay(16)
  end

  font.close
  big_font.close
end
