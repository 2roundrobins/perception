--- percpetion v0.1 @fellowfinch
--- llllllll.co/t/url
--- 
---
---
---
--- ▼▼▼ instructions below ▼▼▼
---
--- load sample via PARAMS
--- E1 change the animal 
--- E2 volume
--- E3 detune (issue)
--- K1 toggle recording
--- K2 start/stop
--- K3 reverse


-- TO DO
-- ISSUE: when recording from external audio it records also the sample playback, should be seperate! dont know why, there are different buffers
-- ISSUE: detuning not working properly, E3 gives me only two values, without inbetween, making the tuning not viable. 


-- vars
local current_animal = 8
MAX_BUFFER = 350
-- sample variables
sample_voice = 4
rec_voice = 1
sample_level = 0.5
sample_tune = 1
sample_is_planted = false
pos = 1
rec = 0
play = 0
pre = 0.8
k1_pressed = false

-- init
function init()
    softcut.buffer_clear()
    audio.level_adc_cut(1)
    audio.level_tape_cut(0)
    softcut.buffer_clear()
  
  --smpl
    softcut.enable(sample_voice, 1) 
    softcut.buffer(sample_voice, 2)
    softcut.level(sample_voice, 0.5)
    softcut.rate(sample_voice, 1)
    softcut.loop(sample_voice, 1)
    softcut.loop_start(sample_voice, 1)
    softcut.loop_end(sample_voice, MAX_BUFFER)
    softcut.position(sample_voice, 1)
    softcut.rate_slew_time(sample_voice, 4)
    softcut.post_filter_rq(sample_voice, 10)
    softcut.play(sample_voice, 1)
    softcut.rec(sample_voice, 0) -- just here to explicitly make sure that the rec flag is off

    softcut.fade_time(sample_voice, 0)
    
    --rec buffer
    softcut.enable(rec_voice,1)
    softcut.buffer(rec_voice,1)
    softcut.level_input_cut(1,rec_voice,1.0)
    softcut.level_input_cut(2,rec_voice,1.0) -- grab audio from both adc inputs

    softcut.level(rec_voice,1.0)
    softcut.rate(rec_voice,1.0)
    softcut.position(rec_voice,1)

    softcut.loop(rec_voice,1)
    softcut.loop_start(rec_voice,1)
    softcut.loop_end(rec_voice, 5)
    softcut.fade_time(rec_voice, 0.5)

    softcut.rate_slew_time(rec_voice, 4)
    softcut.post_filter_rq(rec_voice, 10)

    softcut.play(rec_voice, 1) -- play flag should be on at all times. use softcut.level to mute and softcut.position to set position.
    softcut.rec(rec_voice, 1) -- rec flag should be on at all times. modulate rec_level and pre_level to toggle recording.
    softcut.rec_level(rec_voice,0) -- rec level 0 as default --> no recording.
    softcut.pre_level(rec_voice,1) -- pre level 1 as default --> no erasing.

    setRate(animal_tab[current_animal].cff)
    setFreq()
    
    
  -- sample parameters
  params:add_separator("sample_params", "sample")
  params:add_file("load_sample", "> select sample", "")
  params:set_action("load_sample", function(path) load_audio(path) end)
  
  
  params:add_control("sample_level", "intensity", controlspec.new(0, 1, 'lin', 0, 0.7), function(param) return (round_form(util.linlin(0, 1, 0, 100, param:get()), 1, "%")) end)
  params:set_action("sample_level", function(val) sample_level = val softcut.level(sample_voice, val) end)
  
   params:add_option("plant_sample", "load?", {"no", "yes"}, 2)
  params:set_action("plant_sample", function(val) sample_is_planted = val == 2 and true or false toggle_sample() end)
  
  --problem with detune
  -- params:add_control("sample_tune", "detune", controlspec.new(-1, 1, 'lin', 0, setRate(animal_tab[current_animal].cff)), function(param) return (round_form(util.linlin(0, 1, 0, 100, param:get()), 1, "%")) end)
  -- params:set_action("sample_tune", function(val) sample_tune = val setRate(sample_voice, val) end)
  
  params:bang()


end


-- animal table
animal_tab = {
    {name = "Cane Toad", species = "Rhinella marina", order = "Anura", class = "Amphibia", phylum = "Chordata", lifespan = 12.5, cff = 6.7, lp = 3000, hp = 20},
    {name = "Green Frog", species = "Rana clamitans", order = "Anura", class = "Amphibia", phylum = "Chordata", lifespan = 3, cff = 21, lp = 20000, hp = 20},
    {name = "Rainbow Trout", species = "Oncorhynchus mykiss", order = "Salmoniformes", class = "Actinopterygii", phylum = "Chordata", lifespan = 3.5, cff = 27, lp = 500, hp = 100},
    {name = "Harp Seal", species = "Pagophilus groenlandicus", order = "Carnivora", class = "Mammalia", phylum = "Chordata", lifespan = 32, cff = 33, lp = 20000, hp = 950},
    {name = "Brown Rat", species = "Rattus norvegicus", order = "Rodentia", class = "Mammalia", phylum = "Chordata", lifespan = 2, cff = 39, lp = 20000, hp = 500},
    {name = "Horned Owl", species = "Bubo virginianus", order = "Strigiformes", class = "Aves", phylum = "Chordata", lifespan = 25, cff = 45, lp = 12000, hp = 200},
    {name = "Cat", species = "Felis catus", order = "Carnivora", class = "Mammalia", phylum = "Chordata", lifespan = 14, cff = 55, lp = 20000, hp = 45},
    {name = "Human", species = "Homo sapiens", order = "Primates", class = "Mammalia", phylum = "Chordata", lifespan = 77, cff = 60, lp = 20000, hp = 20},
    {name = "Tussah Moth", species = "Antheraea pernyi", order = "Lepidoptera", class = "Insecta", phylum = "Arthropoda", lifespan = 0.02, cff = 70, lp = 20000, hp = 10000},
    {name = "Dog",species = "Canis lupus", order = "Carnivora", class = "Mammalia", phylum = "Chordata", lifespan = 13, cff = 80, lp = 20000, hp = 67},
    {name = "Treeshrew", species = "Tupaia glis", order = "Scandentia", class = "Mammalia", phylum = "Chordata", lifespan = 2.5, cff = 90, lp = 6000, hp = 250},
    {name = "Starling", species = "Sturnus vulgaris", order = "Passeriformes", class = "Aves", phylum = "Chordata", lifespan = 2.5, cff = 100, lp = 8700, hp = 700},
    {name = "Ground Squirrel", species = "Spermophilus lateralis", order = "Rodentia", class = "Mammalia", phylum = "Chordata", lifespan = 7, cff = 120, lp = 32000, hp = 500},
    {name = "Tsetse Fly", species = "Glossina morsitans", order = "Diptera", class = "Insecta", phylum = "Arthropoda", lifespan = 0.08, cff = 145, lp = 7200, hp = 5300},
    {name = "Honey Bee", species = "Apis mellifera", order = "Hymenoptera", class = "Insecta", phylum = "Arthropoda", lifespan = 0.1, cff = 200, lp = 500, hp = 100}
}

--cff rate
function setRate(cff)
    cffrate = 60 / cff
    softcut.rate(sample_voice, cffrate)
    softcut.rate(rec_voice, cffrate)
    print("CFF Rate:", cffrate)
    return cffrate
end

--filtering
-- turning both hp and lp filters on will have no effect.
-- if you want a band-pass then you'll need to activate post_filter_bp only and play with the centre freq and rq values.
-- if this doesn't lead to the desired effect you'll need to re-route softcut into supercollider and do the filtering there.
function setFreq()
    local hp = animal_tab[current_animal].hp
    local lp = animal_tab[current_animal].lp
    softcut.post_filter_dry(sample_voice, 0)
    softcut.post_filter_hp(sample_voice, 1)
    softcut.post_filter_lp(sample_voice, 1)
    softcut.post_filter_fc(sample_voice, hp, lp) -- passing too many args here. post_filter_fc expects voice and freq_value
    
    softcut.post_filter_dry(rec_voice, 0)
    softcut.post_filter_hp(rec_voice, 1)
    softcut.post_filter_lp(rec_voice, 1)
    softcut.post_filter_fc(rec_voice, hp, lp) -- too many args (lp will be ignored)
end

  
-- load sample file
function load_audio(path)
    if path ~= "cancel" and path ~= "" then
      local ch, len = audio.file_info(path)
      if ch > 0 and len > 0 then
        softcut.buffer_clear_channel(2)
        softcut.buffer_read_stereo(path, 0, 1, -1, 1, 2, 0, 1) -- needs to be mono if you need separate buffers this is why you're hearing the sample being overdubbed.
        local l = math.min(len / 48000, MAX_BUFFER)
        softcut.loop_start(sample_voice, 1)
        softcut.loop_end(sample_voice, 1 + l)
        params:set("plant_sample", 2)
        params:set("load_sample", "")
        print("file loaded: "..path.." is "..l.."s")
      else
        print("not a sound file")
      end
    end
  end
  
function toggle_sample()
    if sample_is_planted then
      softcut.position(sample_voice, 1)
      softcut.play(sample_voice, 1)
      softcut.level(sample_voice, sample_level)
    else
      softcut.level(sample_voice, 0)
    end
end

--UI--
  
function key(n, z)
  if n == 1 and z == 1 then -- try to avoid K1 to do things other than use as a shift key.
    rec = rec == 0 and 1 or 0
    --play = play == 0 and 1 or 0
    play = 1
    print("Recording external audio:", rec == 1)
    softcut.rec(1, rec) -- don't toggle flags. modulate levels insted.
    softcut.play(1, play) -- don't toggle flags. set level and position instead.
  elseif n == 2 and z == 1 then
    sample_is_planted = not sample_is_planted -- toggle the state before you apply conditionals, no?
      if sample_is_planted then
        softcut.rate(sample_voice, 0) -- this is intentionally stopping playback right?
        softcut.rate(rec_voice, 0) -- bet it sounds cool with such a large slew rate.
      else
        setRate(animal_tab[current_animal].cff)
      end
  elseif n == 3 and z == 1 then
    sample_is_planted = not sample_is_planted -- toggle the state before you apply conditionals, no?
    if sample_is_planted then
      setRate(animal_tab[current_animal].cff)
    else
      setRate(-animal_tab[current_animal].cff) -- why this? you're neither stopping or reversing playback. just asking.
    end
  end
end



-- encoder control
function enc(n, d)
  if n == 1 then
    current_animal = util.clamp(current_animal + d, 1, #animal_tab)
    setRate(animal_tab[current_animal].cff)
    setFreq(animal_tab[current_animal].lp, animal_tab[current_animal].hp)
  elseif n == 2 then 
    params:delta("sample_level", d)
  elseif n == 3 then
    -- this will only ever give you two values because you're basically first setting the rate via setRate(CFF)
    -- which also returns the current rate to which you add delta and then set the rate again.
    -- if you need a detune parameter add this to params and include the variable in your setRate() function.
    -- see the detune param in mlre if you want to add detune in cent steps.
    local new_rate = setRate(animal_tab[current_animal].cff) + d
    softcut.rate(sample_voice, new_rate)
    print("rate is " .. new_rate)
  end
  redraw()
end


--SCREEN
function redraw()
  screen.clear()
  screen.font_size(15)
  screen.font_face(49)
  screen.move(5, 10)
  screen.text(animal_tab[current_animal].name)
  screen.move(5, 23)
  screen.font_size(9)
  screen.font_face(17)
  screen.text(animal_tab[current_animal].species)
  screen.font_size(8)
  screen.font_face(1)
  screen.move(5, 35)
  screen.text("Order: " .. animal_tab[current_animal].order)
  screen.move(5, 44)
  screen.text("CFF: " .. animal_tab[current_animal].cff)
  screen.font_size(8)
  screen.font_face(1)
  screen.move(5,53)
  screen.text("HR: " .. animal_tab[current_animal].hp.. "-" .. animal_tab[current_animal].lp.."hz")
  screen.move(5,62)
  screen.text("Vol: " .. params:string("sample_level"))
  
  
  --pngs
    if animal_tab[current_animal].name == "Human" then
      screen.display_png(_path.code .. "/perception/assets/human.png", 55, 0)
  elseif animal_tab[current_animal].name == "Cane Toad" then
      screen.display_png(_path.code .. "/perception/assets/toad.png", 78, 20)
  elseif animal_tab[current_animal].name == "Green Frog" then
      screen.display_png(_path.code .. "/perception/assets/gfrog.png", 75, 20)
  elseif animal_tab[current_animal].name == "Rainbow Trout" then
      screen.display_png(_path.code .. "/perception/assets/trout.png", 85, 25)
  elseif animal_tab[current_animal].name == "Harp Seal" then
      screen.display_png(_path.code .. "/perception/assets/seal.png", 85, 25)
  elseif animal_tab[current_animal].name == "Brown Rat" then
      screen.display_png(_path.code .. "/perception/assets/rat.png", 76, 8)
  elseif animal_tab[current_animal].name == "Horned Owl" then
      screen.display_png(_path.code .. "/perception/assets/owl.png", 95, 8)
  elseif animal_tab[current_animal].name == "Cat" then
      screen.display_png(_path.code .. "/perception/assets/cat.png", 73, 7)
  elseif animal_tab[current_animal].name == "Tussah Moth" then
      screen.display_png(_path.code .. "/perception/assets/moth.png", 92, -5)
  elseif animal_tab[current_animal].name == "Dog" then
      screen.display_png(_path.code .. "/perception/assets/dog.png", 75, 4)
  elseif animal_tab[current_animal].name == "Treeshrew" then
      screen.display_png(_path.code .. "/perception/assets/shrew.png", 70, 1)
  elseif animal_tab[current_animal].name == "Starling" then
      screen.display_png(_path.code .. "/perception/assets/starling.png", 75, 1)
  elseif animal_tab[current_animal].name == "Ground Squirrel" then
      screen.display_png(_path.code .. "/perception/assets/squirrel.png", 80, 25)
  elseif animal_tab[current_animal].name == "Tsetse Fly" then
      screen.display_png(_path.code .. "/perception/assets/fly.png", 75, 0)
  elseif animal_tab[current_animal].name == "Honey Bee" then
      screen.display_png(_path.code .. "/perception/assets/bee.png", 80, -4)
  end
  screen.update()
end

--util
function r()
  norns.script.load(norns.state.script)
end

function round_form(param, quant, form)
  return(util.round(param, quant)..form)
end


function screen_redraw()
  if dirtyscreen then
    redraw()
    dirtyscreen = false
  end
end
