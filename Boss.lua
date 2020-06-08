-- Boss Class
-- An Enemy Class with some tweaks
Boss = Class{}

function Boss:init(x, y, width, height, image)
    -- Coordinates of the object
    self.x = x
    self.y = y

    -- Other Characteristics
    self.Width = width
    self.Height = height
    self.state = 'moving'
    self.id = image
    self.moveTimer = 0
    self.attackTimer = 0
    self.deathTimer = 0
    self.immunityFrames = 0
    self.hit = false
    self.hp = 50
    self.dx = 80
    self.dy = 80

    -- Phase Counter
    self.phase = 1

    self.sprite = love.graphics.newImage('Images/' .. image .. '.png')
    self.frames = generateQuads(self.sprite, self.Width, self.Height)

    -- Couldn't access the projectile object in code
    self.warriorSound = love.audio.newSource('Sounds/arrowHit.wav', 'static')

    self.soundM = love.audio.newSource('Sounds/' .. image .. '.mp3', 'static') -- Exception
    self.soundA = love.audio.newSource('Sounds/' .. image .. 'A.wav', 'static')
    self.roar = love.audio.newSource('Sounds/' .. image .. '_roar.wav', 'static')

    self.animations = {
        ['idle'] = Animation { -- Still here for some reason
            texture = self.sprites,
            frames = {
                self.frames[1], self.frames[2], self.frames[3], self.frames[4], self.frames[5],
                self.frames[6], self.frames[7], self.frames[8], self.frames[9], self.frames[10]
            },
            interval = 0.25
        },

        ['moving'] = Animation {
            texture = self.sprites,
            frames = {
                self.frames[21], self.frames[22], self.frames[23], self.frames[24], self.frames[25],
                self.frames[26], self.frames[27], self.frames[28], self.frames[29], self.frames[30]
            },
            interval = 0.15
        },

        ['attacking'] = Animation {
            texture = self.sprites,
            frames = {
                self.frames[31], self.frames[32], self.frames[33], self.frames[34], self.frames[35],
                self.frames[36], self.frames[37], self.frames[38], self.frames[39], self.frames[40]
            },
            interval = 0.11
        },


        ['death'] = Animation {
            texture = self.sprites,
            frames = {
                self.frames[41], self.frames[42], self.frames[43], self.frames[44], self.frames[45],
                self.frames[46], self.frames[47], self.frames[48], self.frames[49], self.frames[50]
            },
            interval = 0.3
        }
    }
end


function Boss:render()

    -- Set Direction, kept the segregation here for the future
    if self.state ~= 'death' then
        if self.id == 'minotaur' then
            if player.x < self.x then
                self.scaleX = 1
            else
                self.scaleX = -1
            end
    
        else
            if player.x > self.x then
                self.scaleX = 1
            else
                self.scaleX = -1
            end 
        end
    end

    -- If minotaur is in its third phase, make it red
    if self.phase == 3 and gameState ~= 'end' then
        love.graphics.setColor(200 / 255, 0.1, 0.1, 1)
    end

    -- Draws sprites, idle is never used
    if self.state == 'idle' then 
        love.graphics.draw(self.sprite, self.animations['idle']:getCurrentFrame(),
        math.floor(self.x - self.Width), math.floor(self.y - self.Height + 5), 
        0, self.scaleX, 1, 
        self.Width / 2, self.Height / 2)

    elseif self.state == 'moving' then 
        love.graphics.draw(self.sprite, self.animations['moving']:getCurrentFrame(),
        math.floor(self.x - self.Width), math.floor(self.y - self.Height + 5), 
        0, self.scaleX, 1, 
        self.Width / 2, self.Height / 2)
    
    elseif self.state == 'attacking' then -- Decides which string of frames to play
        love.graphics.draw(self.sprite, self.animations['attacking']:getCurrentFrame(),
        math.floor(self.x - self.Width), math.floor(self.y - self.Height + 5), 
        0, self.scaleX, 1, 
        self.Width / 2, self.Height / 2)
    
    elseif self.state == 'death' then
        love.graphics.draw(self.sprite, self.animations['death']:getCurrentFrame(),
        math.floor(self.x - self.Width), math.floor(self.y - self.Height + 5), 
        0, self.scaleX, 1, 
        self.Width / 2, self.Height / 2)
    end

    love.graphics.setColor(1, 1, 1, 1)

    -- Boss Health bar
    if self.hp > 0 then
        love.graphics.setFont(text)
        love.graphics.printf("The Dark Lord", 0, 195, VIRTUAL_WIDTH, 'center')
        love.graphics.rectangle('line', 50, 210, 330, 10)
        love.graphics.setColor(1, 0, 0, 1)
        love.graphics.rectangle('fill', 51, 211, 6.56 * self.hp, 8)
        love.graphics.setColor(1, 1, 1, 1)
    end
end


function Boss:update(dt)

    -- Boss States
    if self.hp <= 25 and self.phase == 1 then
        self.roar:play()
        self.dx = 100
        self.dy = 100
        self.phase = 2
    end

    if self.hp <= 10 and self.phase == 2 then
        self.roar:play()
        self.dx = 180
        self.dy = 180
        self.phase = 3
    end

    -- Update Animations
    if self.state == 'idle' then
        self.animations['idle']:update(dt)
    
    elseif self.state == 'moving' then
        self.animations['moving']:update(dt)

    elseif self.state == 'attacking' then
        self.animations['attacking']:update(dt)
        
    -- I need to edit this later
    elseif self.state == 'death' then
        if self.deathTimer < 1.4 then
            self.animations['death']:update(dt)
            self.deathTimer = self.deathTimer + dt
        end
    end

    if self.hp <= 0 and gameState ~= 'end' then
        self.state = 'death'
        gameState = 'end'
        music['play']:stop()
        music['boss']:stop()
        music['title']:play()
    end

    if self.state == 'moving' then

        if self.x > player.x then
            self.x = math.floor(self.x - self.dx * dt)
        else
            self.x = math.floor(self.x + self.dx * dt)
        end

        if self.y > player.y then
            self.y = math.floor(self.y - self.dy * dt)
        else
            self.y = math.floor(self.y + self.dy * dt)
        end
        self.soundM:play()

         -- Check if Player is near orc
        if (self.x >= player.x - 32 and self.x <= player.x + 32)
        and (self.y >= player.y - 32 and self.y <= player.y + 32)  then
            self.state = 'attacking'
        end
    
    elseif self.state == 'attacking' then
        self.attackTimer = self.attackTimer + dt

        -- If Player is still present, then they take damage
        if self.attackTimer > 0.8 and self.attackTimer < 1 then

            if (self.x >= player.x - 64 and self.x <= player.x + 64)
            and (self.y >= player.y - 64 and self.y <= player.y + 64)  then
                player:hit()
            end

            -- Play sound effect when flail is front of the sprite
            if self.attackTimer >= 1 and self.attackTimer < 1.1 then
                self.soundA:play()
            end
        end

        --Return to moving after attack is done
        if self.attackTimer > 1.1 then
            self.attackTimer = 0
            self.state = 'moving'
        end
    end


    -- Collision System with Projectiles
    if self.state ~= 'death' then
        if playerClass ~= 'fighter' then
            for i, v in ipairs(projectiles) do
                if (v.x  > self.x - 80 and v.x < self.x) and
                    (v.y > self.y - 50 and v.y < self.y) then

                        -- Differing results based on class
                        if playerClass == 'ranger' then
                            self.hp = self.hp - 1
                        else
                            self.hp = self.hp - 2
                        end

                        projectile.sounds[playerClass]:play()
                        table.remove(projectiles, i)
                end
            end
        end

        -- Exception for the fighter class which does not use projectiles
        if playerClass == 'fighter' and self.hit == false then
            if player.state == 'attacking' then
                if (self.x >= player.x - 48 and self.x <= player.x + 48)
                and (self.y >= player.y - 48 and self.y <= player.y + 48)  then
                    self.hp = self.hp - 3
                    self.warriorSound:play()
                    self.hit = true
                end
            end
        end

        if self.hit == true then
            self.immunityFrames = self.immunityFrames + dt

            if self.immunityFrames >= 0.8 then
                self.hit = false
                self.immunityFrames = 0
            end
        end
    end
end