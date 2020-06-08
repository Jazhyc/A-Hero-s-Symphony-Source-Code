Enemy = Class{}

function Enemy:init(x, y, width, height, image)
    -- Coordinates of the object
    self.x = x
    self.y = y
    self.Width = width
    self.Height = height
    self.state = 'moving'
    self.id = image
    self.moveTimer = 0
    self.attackTimer = 0
    self.deathTimer = 0
    self.immunityFrames = 0
    self.hit = false

    self.sprite = love.graphics.newImage('Images/' .. image .. '.png')
    self.frames = generateQuads(self.sprite, self.Width, self.Height)

    -- Couldn't access the projectile object in code
    self.warriorSound = love.audio.newSource('Sounds/arrowHit.wav', 'static')

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
            interval = 0.15
        },

        ['deathS'] = Animation { -- Slime Death
            texture = self.sprites,
            frames = {
                self.frames[50], self.frames[49], self.frames[48], self.frames[47], self.frames[46],
                self.frames[45], self.frames[44], self.frames[43], self.frames[42], self.frames[41]
            },
            interval = 0.15
        },

        ['death'] = Animation { -- Slime Death
            texture = self.sprites,
            frames = {
                self.frames[41], self.frames[42], self.frames[43], self.frames[44], self.frames[45],
                self.frames[46], self.frames[47], self.frames[48], self.frames[49], self.frames[50]
            },
            interval = 0.15
        }
    }


    self.soundM = love.audio.newSource('Sounds/' .. image .. '.wav', 'static')
    self.soundA = love.audio.newSource('Sounds/' .. image .. 'A.wav', 'static')
    
    if self.id == 'slime' then
        self.hp = 3

    elseif self.id == 'skeleton' then
        self.hp = 4

    elseif self.id == 'orc' then
        self.hp = 5
    end


end

function Enemy:update(dt)
    -- Update Animations
    if self.state == 'idle' then
        self.animations['idle']:update(dt)
    
    elseif self.state == 'moving' then
        self.animations['moving']:update(dt)

    elseif self.state == 'attacking' then
        self.animations['attacking']:update(dt)
    
    elseif self.state == 'death' then

        if self.id == 'slime' then
            if self.deathTimer < 1.4 then
                self.animations['deathS']:update(dt)
                self.deathTimer = self.deathTimer + dt
            end
        else
            if self.deathTimer < 1.4 then
                self.animations['death']:update(dt)
                self.deathTimer = self.deathTimer + dt
            end
        end
    end

    if self.hp <= 0 then
        self.state = 'death'
    end
    

    -- AI

    if self.id == 'slime' then
        self.dx = 40
        self.dy = 30

        -- Movement of Slime
        if self.state == 'moving' then
            self.moveTimer = self.moveTimer + dt

            if self.moveTimer > 0.2 and self.moveTimer < 1.3 then

                if self.x > player.x then
                    self.x = self.x - self.dx * dt

                else
                    self.x = self.x + self.dx * dt
                end

                if self.y > player.y then
                    self.y = self.y - self.dy * dt

                else
                    self.y = self.y + self.dy * dt
                end

            end

            if self.moveTimer > 1.4 then
                self.moveTimer = 0
                self.soundM:play()
            end

            -- Check if Player is near slime
            if (self.x >= player.x - 32 and self.x <= player.x + 32)
                and (self.y >= player.y - 32 and self.y <= player.y + 32)  then
                self.state = 'attacking'
                self.soundA:play()
            end
        
        elseif self.state == 'attacking' then
            self.attackTimer = self.attackTimer + dt

            -- If Player is still present, then they take damage
            if self.attackTimer > 0.2 and self.attackTimer < 0.7 then

                if (self.x >= player.x - 32 and self.x <= player.x + 32)
                and (self.y >= player.y - 32 and self.y <= player.y + 32)  then
                    player:hit()
                end
            end

            --Return to moving after attack is done
            if self.attackTimer > 1.5 then
                self.attackTimer = 0
                self.state = 'moving'
            end
        end
    end

    if self.id == 'skeleton' then
        self.dx = 45
        self.dy = 45

        if self.state == 'moving' then
            if self.x > player.x then
                self.x = self.x - self.dx * dt

            else
                self.x = self.x + self.dx * dt
            end

            if self.y > player.y then
                self.y = self.y - self.dy * dt

            else
                self.y = self.y + self.dy * dt
            end
            self.soundM:play()

            -- Check if Player is near skeleton
            if (self.x >= player.x - 32 and self.x <= player.x + 32)
            and (self.y >= player.y - 32 and self.y <= player.y + 32)  then
                self.state = 'attacking'
                self.soundA:play()
            end

        elseif self.state == 'attacking' then
            self.attackTimer = self.attackTimer + dt
        -- If Player is still present, then they take damage
            if self.attackTimer > 0.5 and self.attackTimer < 1.2 then

                if (self.x >= player.x - 32 and self.x <= player.x + 32)
                and (self.y >= player.y - 32 and self.y <= player.y + 32)  then
                    player:hit()
                end
            end

            --Return to moving after attack is done
            if self.attackTimer > 1.5 then
                self.attackTimer = 0
                self.state = 'moving'
            end
        end
    end

    if self.id == 'orc' then
        self.dx = 100
        self.dy = 20

        if self.state == 'moving' then
            if self.x > player.x then
                self.x = self.x - self.dx * dt

            else
                self.x = self.x + self.dx * dt
            end

            if self.y > player.y then
                self.y = self.y - self.dy * dt

            else
                self.y = self.y + self.dy * dt
            end
            self.soundM:play()

             -- Check if Player is near orc
            if (self.x >= player.x - 32 and self.x <= player.x + 32)
            and (self.y >= player.y - 32 and self.y <= player.y + 32)  then
                self.state = 'attacking'
                self.soundA:play()
            end
 
        elseif self.state == 'attacking' then
            self.attackTimer = self.attackTimer + dt
            -- If Player is still present, then they take damage
            if self.attackTimer > 0.5 and self.attackTimer < 1.2 then

                if (self.x >= player.x - 32 and self.x <= player.x + 32)
                and (self.y >= player.y - 32 and self.y <= player.y + 32)  then
                    player:hit()
                end
            end

            --Return to moving after attack is done
            if self.attackTimer > 1.5 then
                self.attackTimer = 0
                self.state = 'moving'
            end
        end
    end

    -- Collision System with Projectiles
    if self.state ~= 'death' then
        if playerClass ~= 'fighter' then
            for i, v in ipairs(projectiles) do
                if (v.x  > self.x - 80 and v.x < self.x + self.Width - 20) and
                    (v.y > self.y - 50 and v.y < self.y + self.Width + 10) then

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
                if (self.x >= player.x - 32 and self.x <= player.x + 32)
                and (self.y >= player.y - 32 and self.y <= player.y + 32)  then
                    self.hp = self.hp - 3
                    self.warriorSound:play()
                    self.hit = true
                end
            end
        end

        if self.hit == true then
            self.immunityFrames = self.immunityFrames + dt

            if self.immunityFrames >= 0.6 then
                self.hit = false
                self.immunityFrames = 0
            end
        end
    end
end

function Enemy:render()
    -- Set Direction
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

    if self.state == 'idle' then 
        love.graphics.draw(self.sprite, self.animations['idle']:getCurrentFrame(),
        math.floor(self.x - self.Width), math.floor(self.y - self.Height + 5), 
        0,self.scaleX, 1, 
        self.Width / 2, self.Height / 2)

    elseif self.state == 'moving' then 
        love.graphics.draw(self.sprite, self.animations['moving']:getCurrentFrame(),
        math.floor(self.x - self.Width), math.floor(self.y - self.Height + 5), 
        0,self.scaleX, 1, 
        self.Width / 2, self.Height / 2)
    
    elseif self.state == 'attacking' then 
        love.graphics.draw(self.sprite, self.animations['attacking']:getCurrentFrame(),
        math.floor(self.x - self.Width), math.floor(self.y - self.Height + 5), 
        0,self.scaleX, 1, 
        self.Width / 2, self.Height / 2)
    
    elseif self.state == 'death' then -- Decides which string of frames to play
        if self.id == 'slime' then 
            love.graphics.draw(self.sprite, self.animations['deathS']:getCurrentFrame(),
            math.floor(self.x - self.Width), math.floor(self.y - self.Height + 5), 
            0,self.scaleX, 1, 
            self.Width / 2, self.Height / 2)
        else
            love.graphics.draw(self.sprite, self.animations['death']:getCurrentFrame(),
            math.floor(self.x - self.Width), math.floor(self.y - self.Height + 5), 
            0,self.scaleX, 1, 
            self.Width / 2, self.Height / 2)
        end
    end
end
