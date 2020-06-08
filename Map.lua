Map = Class{}
-- Get Ready for some ineffiecient programming

function Map:init()
    -- Creates map, 1st level
    map = 'hideout'
    coll = bump.newWorld() -- Collision World
    self.key = false -- Need Key to unlock boss room
    self.keyPickup = love.audio.newSource("Sounds/key.wav", 'static')

    -- Initializing maps
    Hideout = sti('Maps/Hideout.lua', {"bump"})
    map2 = sti('Maps/map2.lua', {"bump"})
    map3 = sti('Maps/map3.lua', {"bump"})
    map4 = sti('Maps/map4.lua', {"bump"})
    map5 = sti('Maps/map5.lua', {"bump"})
    map6 = sti('Maps/map6.lua', {"bump"})
    map7 = sti('Maps/map7.lua', {"bump"})
    map8 = sti('Maps/map8.lua', {"bump"})
    map9 = sti('Maps/map9.lua', {"bump"})
    map10 = sti('Maps/map10.lua', {"bump"})
    map11 = sti('Maps/map11.lua', {"bump"})
    map12 = sti('Maps/map12.lua', {"bump"})
    map13 = sti('Maps/map13.lua', {"bump"})
    map14 = sti('Maps/map14.lua', {"bump"})
    map15 = sti('Maps/map15.lua', {"bump"})
    map17 = sti('Maps/map17.lua', {"bump"})
    
    coll:add(player, player.x, player.y, player.Width / 1.4, player.Height / 1.4)
    Hideout:bump_init(coll)

    -- 1st Level, Pacifist Mobs
    bat = Entity(150, 230, 32, 32, 'rab.png')
    rogue = Entity(100, 100, 32, 32, 'rogue.png')
    cleric = Entity(240, 90, 32, 32, 'cleric.png')
    orcP = Entity(75, 175, 32, 32, 'orc.png')

    -- Enemies
    -- 1st level
    slime = Enemy(120, 100, 32, 32, 'slime')

    -- 3rd level
    skeleton = Enemy(120, 100, 32, 32, 'skeleton')

    -- 4th level
    orc = Enemy(80, 120, 32, 32, 'orc')

    -- 7th level
    slime6 = Enemy(150, 100, 32, 32, 'slime')
    slime7 = Enemy(170, 150, 32, 32, 'slime')
    slime8 = Enemy(250, 125, 32, 32, 'slime')
    skeleton4 = Enemy(170, 100, 32, 32, 'skeleton')

    -- 8th level
    orc2 = Enemy(250, 120, 32, 32, 'orc')
    orc3 = Enemy(250, 160, 32, 32, 'orc')

    -- 9th level
    skeleton5 = Enemy(220, 130, 32, 32, 'skeleton')

    -- 10th level
    slime9 = Enemy(160, 125, 32, 32, 'slime')
    slime10 = Enemy(250, 125, 32, 32, 'slime')
    skeleton1 = Enemy(120, 100, 32, 32, 'skeleton')
    orc1 = Enemy(250, 150, 32, 32, 'orc')

    -- 11th level  
    slime1 = Enemy(120, 100, 32, 32, 'slime')
    slime2 = Enemy(160, 40, 32, 32, 'slime')
    slime3 = Enemy(100, 60, 32, 32, 'slime')
    slime4 = Enemy(200, 100, 32, 32, 'slime')
    slime5 = Enemy(130, 70, 32, 32, 'slime')

    -- 12th Level
    skeleton2 = Enemy(170, 100, 32, 32, 'skeleton')
    skeleton3 = Enemy(180, 150, 32, 32, 'skeleton')

    -- 13th Level
    orc4 = Enemy(30, 120, 32, 32, 'orc')

    -- 17th level Boss Room
    minotaur = Boss(260, 160, 48, 48, 'minotaur')

end

-- This Function handles transition between rooms, even the Devil has no power in this domain
-- Basically YandereDev
-- Maybe i could have used functions or switch cases
function Map:update(dt)
    if map == 'hideout' then
        Hideout:update(dt)
        bat:update(dt)
        rogue:update(dt)
        cleric:update(dt)
        orcP:update(dt) -- Pacifist orc

        if player.y < 10 then
            map = 'map2'
            player.y = player.y + VIRTUAL_HEIGHT - 10
            coll = bump.newWorld()
            coll:add(player, player.x, player.y, player.Width / 1.4, player.Height / 1.4)
            map2:bump_init(coll)
        end

    elseif map == 'map2' then

        slime:update(dt)

        if player.y > VIRTUAL_HEIGHT + 16 then
            map = 'hideout'
            player.y = 0 + 20
            coll = bump.newWorld()
            coll:add(player, player.x, player.y, player.Width / 1.4, player.Height / 1.4)
            Hideout:bump_init(coll)
        end

        if player.x < 0 + 20 then
            map = 'map3'
            player.x = player.x + VIRTUAL_WIDTH - 10
            coll = bump.newWorld()
            coll:add(player, player.x, player.y, player.Width / 1.4, player.Height / 1.4)
            map3:bump_init(coll)
        end 

    elseif map == 'map3' then

        skeleton:update(dt)

        if player.y > VIRTUAL_HEIGHT + 16 then
            map = 'map5'
            player.y = 0 + 20
            coll = bump.newWorld()
            coll:add(player, player.x, player.y, player.Width / 1.4, player.Height / 1.4)
            map5:bump_init(coll)
        end

        if player.x < 0 + 10 then
            map = 'map4'
            player.x = player.x + VIRTUAL_WIDTH - 10
            coll = bump.newWorld()
            coll:add(player, player.x, player.y, player.Width / 1.4, player.Height / 1.4)
            map4:bump_init(coll)
        end

        if player.x > VIRTUAL_WIDTH + 16 then
            map = 'map2'
            player.x = 0 + 20
            coll = bump.newWorld()
            coll:add(player, player.x, player.y, player.Width / 1.4, player.Height / 1.4)
            map2:bump_init(coll)
        end
    
    elseif map == 'map4' then

        orc:update(dt)

        if player.y < 0 + 16 then
            map = 'map6'
            player.y = VIRTUAL_HEIGHT - 20
            coll = bump.newWorld()
            coll:add(player, player.x, player.y, player.Width / 1.4, player.Height / 1.4)
            map6:bump_init(coll)
        end

        if player.x > VIRTUAL_WIDTH + 16 then
            map = 'map3'
            player.x = 0 + 20
            coll = bump.newWorld()
            coll:add(player, player.x, player.y, player.Width / 1.4, player.Height / 1.4)
            map3:bump_init(coll)
        end

        if player.x < 0 + 10 then
            map = 'map11'
            player.x = player.x + VIRTUAL_WIDTH - 10
            coll = bump.newWorld()
            coll:add(player, player.x, player.y, player.Width / 1.4, player.Height / 1.4)
            map11:bump_init(coll)
        end 
        
    elseif map == 'map5' then
        if player.y < 0 + 16 then
            map = 'map3'
            player.y = VIRTUAL_HEIGHT - 16
            coll = bump.newWorld()
            coll:add(player, player.x, player.y, player.Width / 1.4, player.Height / 1.4)
            map3:bump_init(coll)
        end
    
    elseif map == 'map6' then
        if player.y < 0 + 16 then
            map = 'map7'
            player.y = VIRTUAL_HEIGHT - 16
            coll = bump.newWorld()
            coll:add(player, player.x, player.y, player.Width / 1.4, player.Height / 1.4)
            map7:bump_init(coll)
        end

        if player.y > VIRTUAL_HEIGHT - 16 then
            map = 'map4'
            player.y = 0 + 20
            coll = bump.newWorld()
            coll:add(player, player.x, player.y, player.Width / 1.4, player.Height / 1.4)
            map4:bump_init(coll)
        end
    
    elseif map == 'map7' then

        slime6:update(dt)
        slime7:update(dt)
        slime8:update(dt)
        skeleton4:update(dt)

        if player.y > VIRTUAL_HEIGHT - 16 then
            map = 'map6'
            player.y = 0 + 20
            coll = bump.newWorld()
            coll:add(player, player.x, player.y, player.Width / 1.4, player.Height / 1.4)
            map6:bump_init(coll)
        end

        if player.x > VIRTUAL_WIDTH + 16 then
            map = 'map8'
            player.x = 0 + 20
            coll = bump.newWorld()
            coll:add(player, player.x, player.y, player.Width / 1.4, player.Height / 1.4)
            map8:bump_init(coll)
        end
        
        if player.x < 0 + 10 then
            map = 'map13'
            player.x = player.x + VIRTUAL_WIDTH - 10
            coll = bump.newWorld()
            coll:add(player, player.x, player.y, player.Width / 1.4, player.Height / 1.4)
            map13:bump_init(coll)
        end
    
    elseif map == 'map8' then

        orc2:update(dt)
        orc3:update(dt)

        if player.x > VIRTUAL_WIDTH + 16 then
            map = 'map9'
            player.x = 0 + 20
            coll = bump.newWorld()
            coll:add(player, player.x, player.y, player.Width / 1.4, player.Height / 1.4)
            map9:bump_init(coll)
        end

        if player.x < 0 + 10 then
            map = 'map7'
            player.x = player.x + VIRTUAL_WIDTH - 10
            coll = bump.newWorld()
            coll:add(player, player.x, player.y, player.Width / 1.4, player.Height / 1.4)
            map7:bump_init(coll)
        end

    elseif map == 'map9' then

        skeleton5:update(dt)

        if player.x < 0 + 10 then
            map = 'map8'
            player.x = player.x + VIRTUAL_WIDTH - 10
            coll = bump.newWorld()
            coll:add(player, player.x, player.y, player.Width / 1.4, player.Height / 1.4)
            map8:bump_init(coll)
        end

        if player.y > VIRTUAL_HEIGHT - 16 then
            map = 'map10'
            player.y = 0 + 20
            coll = bump.newWorld()
            coll:add(player, player.x, player.y, player.Width / 1.4, player.Height / 1.4)
            map10:bump_init(coll)
        end
    
    elseif map == 'map10' then

        slime9:update(dt)
        slime10:update(dt)
        skeleton1:update(dt)
        orc1:update(dt)

        if player.y < 0 + 16 then
            map = 'map9'
            player.y = VIRTUAL_HEIGHT - 16
            coll = bump.newWorld()
            coll:add(player, player.x, player.y, player.Width / 1.4, player.Height / 1.4)
            map9:bump_init(coll)
        end

        if (player.y > 130 and player.y < 170) and
            (player.x > 200 and player.x < 240) then
            self.key = true
            self.keyPickup:play()
        end
    
    elseif map == 'map11' then

        slime1:update(dt)
        slime2:update(dt)
        slime3:update(dt)
        slime4:update(dt)
        slime5:update(dt)

        if player.x > VIRTUAL_WIDTH + 16 then
            map = 'map4'
            player.x = 0 + 20
            coll = bump.newWorld()
            coll:add(player, player.x, player.y, player.Width / 1.4, player.Height / 1.4)
            map4:bump_init(coll)
        end

        if player.y > VIRTUAL_HEIGHT + 16 then
            map = 'map12'
            player.y = 0 + 10
            coll = bump.newWorld()
            coll:add(player, player.x, player.y, player.Width / 1.4, player.Height / 1.4)
            map12:bump_init(coll)
        end

    elseif map == 'map12' then

        skeleton2:update(dt)
        skeleton3:update(dt)

        if player.y < 0  then
            map = 'map11'
            player.y = VIRTUAL_HEIGHT - 16
            coll = bump.newWorld()
            coll:add(player, player.x, player.y, player.Width / 1.4, player.Height / 1.4)
            map11:bump_init(coll)
        end
    
    elseif map == 'map13' then

        orc4:update(dt)

        if player.x > VIRTUAL_WIDTH + 16 then
            map = 'map7'
            player.x = 0 + 20
            coll = bump.newWorld()
            coll:add(player, player.x, player.y, player.Width / 1.4, player.Height / 1.4)
            map7:bump_init(coll)
        end
        
        if player.x < 0 + 10 then
            map = 'map14'
            player.x = player.x + VIRTUAL_WIDTH - 10
            coll = bump.newWorld()
            coll:add(player, player.x, player.y, player.Width / 1.4, player.Height / 1.4)
            map14:bump_init(coll)
        end

    elseif map == 'map14' then
        if player.x > VIRTUAL_WIDTH + 16 then
            map = 'map13'
            player.x = 0 + 20
            coll = bump.newWorld()
            coll:add(player, player.x, player.y, player.Width / 1.4, player.Height / 1.4)
            map13:bump_init(coll)
        end

        if player.y < 0 + 16 then
            map = 'map15'
            player.y = VIRTUAL_HEIGHT - 16
            coll = bump.newWorld()
            coll:add(player, player.x, player.y, player.Width / 1.4, player.Height / 1.4)
            map15:bump_init(coll)
        end

    elseif map == 'map15' then
        if player.x > VIRTUAL_WIDTH + 16 and self.key == true then
                map = 'map17'
                player.x = 0 + 70 -- Get player past chains
                coll = bump.newWorld()
                coll:add(player, player.x, player.y, player.Width / 1.4, player.Height / 1.4)
                map17:bump_init(coll)
                music['play']:stop()
                music['boss']:play()
                minotaur.roar:play()
                player.hp = 10 -- Reset Player Health
        end

        if player.y > VIRTUAL_HEIGHT - 16 then
            map = 'map14'
            player.y = 0 + 20
            coll = bump.newWorld()
            coll:add(player, player.x, player.y, player.Width / 1.4, player.Height / 1.4)
            map14:bump_init(coll)
        end

    elseif map == 'map17' then

        minotaur:update(dt)

        if player.x < 0 + 10 then
            map = 'map15'
            player.x = player.x + VIRTUAL_WIDTH - 10
            coll = bump.newWorld()
            coll:add(player, player.x, player.y, player.Width / 1.4, player.Height / 1.4)
            map15:bump_init(coll)
        end
    end

    self:movePlayer(player, dt)
end

function Map:render(dt)
    if map == 'hideout' then
        Hideout:draw()
        bat:render()
        rogue:render()
        cleric:render()
        orcP:render()

    -- elseif elseif elseif elseif elseif elseif elseif, switch case?
    elseif map == 'map2' then
        map2:draw()
        slime:render()

    elseif map == 'map3' then
        map3:draw()
        skeleton:render()
    
    elseif map == 'map4' then
        map4:draw()
        orc:render()
        
    elseif map == 'map5' then
        map5:draw()

    elseif map == 'map6' then
        map6:draw()

    elseif map == 'map7' then
        map7:draw()
        slime6:render()
        slime7:render()
        slime8:render()
        skeleton4:render()

    elseif map == 'map8' then
        map8:draw()
        orc2:render()
        orc3:render()

    elseif map == 'map9' then
        map9:draw()
        skeleton5:render()

    elseif map == 'map10' then
        map10:draw()
        slime9:render()
        slime10:render()
        skeleton1:render()
        orc1:render()

        -- Highlights key
        if self.key == false then
            love.graphics.rectangle('line', 200, 130, 32, 22)
        end

    elseif map == 'map11' then
        map11:draw()
        slime1:render()
        slime2:render()
        slime3:render()
        slime4:render()
        slime5:render()

    elseif map == 'map12' then
        map12:draw()
        skeleton2:render()
        skeleton3:render()

    elseif map == 'map13' then
        map13:draw()
        orc4:render()
        
    elseif map == 'map14' then
        map14:draw()

    elseif map == 'map15' then
        map15:draw()

        if player.x > VIRTUAL_WIDTH + 16 and self.key == false then
            love.graphics.setColor(0, 0, 0, 1)
            love.graphics.printf("The Door is Locked", 10, 40, VIRTUAL_WIDTH, 'center')
            love.graphics.printf("I need the Key", 10, 70, VIRTUAL_WIDTH, 'center')
            love.graphics.setColor(1, 1, 1, 1)
        
        elseif player.x < 0 then -- This is Revenge
            love.graphics.printf("https://www.youtube.com/watch?v=oHg5SJYRHA0", 0, 30, VIRTUAL_WIDTH, 'center')
        end


    elseif map == 'map16' then
        map16:draw()

    elseif map == 'map17' then
        map17:draw()
        minotaur:render()
    end
end

function Map:movePlayer(player, dt)
    local goalX, goalY = player.x + player.dx * dt, player.y + player.dy * dt
    local actualX, actualY, cols, len = coll:move(player, goalX, goalY)
    player.x, player.y = actualX, actualY
end