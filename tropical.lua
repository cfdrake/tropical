-- tropical
-- by: @cfd90

local musicutil = require "musicutil"

engine.name = "Thebangs"

local notes = musicutil.generate_scale_of_length(48, "minor pentatonic", 24)
local note_trigs = {0, 0, 0, 0, 0, 0, 0, 0}

function new_fish()
  return {
    x = math.random(0, 128),
    y = math.random(0, 80),
    speed_x = math.random(),
    speed_y = math.random()
  }
end

local fishes = {}
local fish_metro

function init()
  engine.algoIndex(4)
  engine.amp(1)
  engine.cutoff(5000)
  engine.attack(0.2)
  engine.release(1)
  
  fishes = {new_fish(), new_fish(), new_fish(), new_fish()}
  
  fish_metro = metro.init()
  fish_metro.time = 1/15
  fish_metro.event = function()
    update_fishes()
    redraw()
  end
  
  fish_metro:start()
end

function update_fishes()
  for i=1,#fishes do
    local fish = fishes[i]
    
    if math.random() > 0.98 then
      fishes[i].speed_x = -fish.speed_x
    end
    
    if math.random() > 0.98 then
      fishes[i].speed_y = -fish.speed_y
    end
    
    if fish.x + fish.speed_x <= 0 or fish.x + fish.speed_x >= 128 then
      fish.speed_x = -fish.speed_x
    end
    
    if fish.y + fish.speed_y <= 0 or fish.y + fish.speed_y >= 64 then
      fish.speed_y = -fish.speed_y
    end
    
    if math.random() > 0.5 then
      fishes[i].x = fish.x + fish.speed_x
    end
    
    if math.random() > 0.5 then
      fishes[i].y = fish.y + fish.speed_y
    end
  end
end

function play_note(i)
  if note_trigs[i] == 0 then
    note_trigs[i] = 1
    engine.hz(musicutil.note_num_to_freq(notes[i * 2]))
    clock.run(function()
      clock.sleep(1)
      note_trigs[i] = 0
    end)
  end
end

function redraw()
  screen.clear()
  
  for i=1,8 do
    local y = 2 + (i * 7)
    
    for j=1,#fishes do
      local fish = fishes[j]
      
      if math.abs(fish.y - y) < 2 then
        screen.level(2)
        play_note(i)
        break
      else
        screen.level(1)
      end
    end
    
    screen.move(0, y)
    screen.line(128, y)
    screen.stroke()
  end
  
  for i=1,#fishes do
    local fish = fishes[i]
    
    screen.level(8)
    screen.move(fish.x, fish.y)
    
    if fish.speed_x > 0 then
      screen.text("><>")
    else
      screen.text("<><")
    end
  end
  
  screen.update()
end

function key(n, d)
  if (n == 2 or n == 3) and d == 1 then
    for i=1,#fishes do
      fishes[i].x = math.random(0, 128)
      fishes[i].y = math.random(0, 80)
      speed_x = math.random()
      speed_y = math.random()
    end
  end
end