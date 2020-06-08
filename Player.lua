-- Loads all player sprites and handles player actions
Player = Class{}

SPEED = 160

function Player:init()

    self.images = {
        ['ranger'] = love.graphics.newImage("Images/ranger.png"),
        ['fighter'] = love.graphics.newImage("Images/warrior.png"),
        ['mage'] = love.graphics.newImage("Images/mage.png")
    }

    self.sounds = {
        ['walking'] = love.audio.newSource('Sounds/walk.wav', 'static'),
        ['walking2'] = love.audio.newSource('Sounds/walk2.wav', 'static'),
        ['grunt'] = love.audio.newSource('Sounds/grunt.mp3', 'static'),
        ['ranger'] = love.audio.newSource('Sounds/bow.wav', 'static'),
        ['fighter'] = love.audio.newSource('Sounds/sword.wav', 'static'),
        ['mage'] = love.audio.newSource('Sounds/fireball.wav', 'static')
    }

    -- Configure volumes
    self.sounds['walking']:setVolume(0.2)
    self.sounds['walking2']:setVolume(0.9)
    self.walk = false
    self.sounds['grunt']:setVolume(0.5)
    self.moveTimer = 0 -- For oscillation between footsteps

    self.Width = 32
    self.Height = 32
    self.state = 'idle'

    -- Position of Player
    self.x = VIRTUAL_WIDTH / 2
    self.y = VIRTUAL_HEIGHT / 2

    -- Vectors of Players
    self.dx = 0
    self.dy = 0
    self.scaleX = 1
    self.direction = 'right'
    self.movement = false
    self.hp = 10
    self.attackTimer = 0
    self.deathTimer = 0
    self.immunityFrames = 0
    self.damage = false

    -- Remember to access values present inside 
    self.sprites = {
        ['ranger'] = generateQuads(self.images['ranger'], self.Width, self.Height),
        ['fighter'] = generateQuads(self.images['fighter'], self.Width, self.Height),
        ['mage'] = generateQuads(self.images['mage'], self.Width, self.Height)
    }

    -- Idle Animations
    self.animationsI  = { -- Calling on this dictionary uses the Class Animation
        ['ranger'] = Animation {
            texture = self.images['ranger'],
            frames = { -- This is horrible programming. Please don't do this
                self.sprites['ranger'][1], self.sprites['ranger'][2], self.sprites['ranger'][3],
                self.sprites['ranger'][4], self.sprites['ranger'][5], self.sprites['ranger'][6],
                self.sprites['ranger'][7], self.sprites['ranger'][8], self.sprites['ranger'][9],
                self.sprites['ranger'][10]
            },
            interval = 0.25
        },

        ['fighter'] = Animation {
            texture = self.images['fighter'],
            frames = { -- This is horrible programming. Please don't do this
                self.sprites['fighter'][1], self.sprites['fighter'][2], self.sprites['fighter'][3],
                self.sprites['fighter'][4], self.sprites['fighter'][5], self.sprites['fighter'][6],
                self.sprites['fighter'][7], self.sprites['fighter'][8], self.sprites['fighter'][9],
                self.sprites['fighter'][10]
            },
            interval = 0.25
        },

        ['mage'] = Animation {
            texture = self.images['mage'],
            frames = { -- This is horrible programming. Please don't do this
                self.sprites['mage'][1], self.sprites['mage'][2], self.sprites['mage'][3],
                self.sprites['mage'][4], self.sprites['mage'][5], self.sprites['mage'][6],
                self.sprites['mage'][7], self.sprites['mage'][8], self.sprites['mage'][9],
                self.sprites['mage'][10]
            },
            interval = 0.25
        }
    }

    --Walking Animations
    self.animationsW = {
        ['ranger'] = Animation {
            texture = self.images['ranger'],
            frames = { -- This is horrible programming. Please don't do this
                self.sprites['ranger'][21], self.sprites['ranger'][22], self.sprites['ranger'][23],
                self.sprites['ranger'][24], self.sprites['ranger'][25], self.sprites['ranger'][26],
                self.sprites['ranger'][27], self.sprites['ranger'][28], self.sprites['ranger'][29],
                self.sprites['ranger'][30]
            },
            interval = 0.1
        },

        ['fighter'] = Animation {
            texture = self.images['fighter'],
            frames = { -- This is horrible programming. Please don't do this
                self.sprites['fighter'][21], self.sprites['fighter'][22], self.sprites['fighter'][23],
                self.sprites['fighter'][24], self.sprites['fighter'][25], self.sprites['fighter'][26],
                self.sprites['fighter'][27], self.sprites['fighter'][28], self.sprites['fighter'][29],
                self.sprites['fighter'][30]
            },
            interval = 0.1
        },

        ['mage'] = Animation {
            texture = self.images['mage'],
            frames = { -- This is horrible programming. Please don't do this
                self.sprites['mage'][21], self.sprites['mage'][22], self.sprites['mage'][23],
                self.sprites['mage'][24], self.sprites['mage'][25], self.sprites['mage'][26],
                self.sprites['mage'][27], self.sprites['mage'][28], self.sprites['mage'][29],
                self.sprites['mage'][30]
            },
            interval = 0.1
        }
    }

    self.animationsA = {
        ['ranger'] = Animation {
            texture = self.images['ranger'],
            frames = { -- This is horrible programming. Please don't do this
                self.sprites['ranger'][31], self.sprites['ranger'][32], self.sprites['ranger'][33],
                self.sprites['ranger'][34], self.sprites['ranger'][35], self.sprites['ranger'][36],
                self.sprites['ranger'][37], self.sprites['ranger'][38], self.sprites['ranger'][39],
                self.sprites['ranger'][40]
            },
            interval = 0.1
        },

        ['mage'] = Animation {
            texture = self.images['mage'],
            frames = { -- This is horrible programming. Please don't do this
                self.sprites['mage'][31], self.sprites['mage'][32], self.sprites['mage'][33],
                self.sprites['mage'][34], self.sprites['mage'][35], self.sprites['mage'][36],
                self.sprites['mage'][37], self.sprites['mage'][38], self.sprites['mage'][39],
                self.sprites['mage'][40]
            },
            interval = 0.1
        },

        ['fighter'] = Animation {
            texture = self.images['fighter'],
            frames = { -- This is horrible programming. Please don't do this
                self.sprites['fighter'][31], self.sprites['fighter'][32], self.sprites['fighter'][33],
                self.sprites['fighter'][34], self.sprites['fighter'][35], self.sprites['fighter'][36],
                self.sprites['fighter'][37], self.sprites['fighter'][38], self.sprites['fighter'][39],
                self.sprites['fighter'][40]
            },
            interval = 0.1
        }
    }

    self.animationsD = {
        ['ranger'] = Animation {
            texture = self.images['ranger'],
            frames = { -- This is horrible programming. Please don't do this
                self.sprites['ranger'][41], self.sprites['ranger'][42], self.sprites['ranger'][43],
                self.sprites['ranger'][44], self.sprites['ranger'][45], self.sprites['ranger'][46],
                self.sprites['ranger'][47], self.sprites['ranger'][48], self.sprites['ranger'][49],
                self.sprites['ranger'][50]
            },
            interval = 0.2
        },

        ['mage'] = Animation {
            texture = self.images['mage'],
            frames = { -- This is horrible programming. Please don't do this
                self.sprites['mage'][41], self.sprites['mage'][42], self.sprites['mage'][43],
                self.sprites['mage'][44], self.sprites['mage'][45], self.sprites['mage'][46],
                self.sprites['mage'][47], self.sprites['mage'][48], self.sprites['mage'][49],
                self.sprites['mage'][50]
            },
            interval = 0.2
        },

        ['fighter'] = Animation {
            texture = self.images['fighter'],
            frames = { -- This is horrible programming. Please don't do this
                self.sprites['fighter'][41], self.sprites['fighter'][42], self.sprites['fighter'][43],
                self.sprites['fighter'][44], self.sprites['fighter'][45], self.sprites['fighter'][46],
                self.sprites['fighter'][47], self.sprites['fighter'][48], self.sprites['fighter'][49],
                self.sprites['fighter'][50]
            },
            interval = 0.2
        }
    }


end

-- Updates sprites in character select
function Player:supdate(dt)
    self:attack(dt)
    -- Remember states
    if self.state == 'idle' then
        self.animationsI['ranger']:update(dt) -- Animation State needs to be updated
        self.animationsI['fighter']:update(dt)
        self.animationsI['mage']:update(dt)
    end

    if self.state == 'moving' then
        self.animationsW['ranger']:update(dt) -- Animation State needs to be updated
        self.animationsW['fighter']:update(dt)
        self.animationsW['mage']:update(dt)
    end

    if self.state == 'attacking' then
        self.animationsA['ranger']:update(dt) -- Animation State needs to be updated
        self.animationsA['fighter']:update(dt)
        self.animationsA['mage']:update(dt)
    end
       
end
-- Renders character animations and sprites
function Player:select()
    love.graphics.setColor(1, 1, 1, 1)
    love.graphics.draw(self.images['fighter'], self.animationsI['fighter']:getCurrentFrame(), 80, 130)
    love.graphics.draw(self.images['ranger'], self.animationsI['ranger']:getCurrentFrame(), 205, 130)
    love.graphics.draw(self.images['mage'], self.animationsI['mage']:getCurrentFrame(), 320, 130)
end

function Player:render()
    
    self:health()

    -- Set Direction
    if self.direction == 'right' then
        self.scaleX = 1
    else
        self.scaleX = -1
    end 

    if mouseX / 2.55 > player.x then
        self.scaleX = 1
    else
        self.scaleX = -1
    end


    if self.state == 'idle' then 
        love.graphics.draw(self.images[playerClass], self.animationsI[playerClass]:getCurrentFrame(),
        math.floor(self.x - self.Width), math.floor(self.y - self.Height), 
        0,self.scaleX, 1, 
        self.Width / 2, self.Height / 2)

    elseif self.state == 'moving' then
        love.graphics.draw(self.images[playerClass], self.animationsW[playerClass]:getCurrentFrame(), 
            math.floor(self.x - self.Width), math.floor(self.y - self.Height), 
            0, self.scaleX, 1,
            self.Width / 2, self.Height / 2)

    elseif self.state == 'attacking' then
        love.graphics.draw(self.images[playerClass], self.animationsA[playerClass]:getCurrentFrame(), 
            math.floor(self.x - self.Width), math.floor(self.y - self.Height), 
            0, self.scaleX, 1,
            self.Width / 2, self.Height / 2)
    end

    if gameState == 'start' and playerClass ~= 'fighter' then
        projectile:render()
    end

end

-- Controls functionality of the player
function Player:control(dt)

    self.movement = false

    if self.state ~= 'attacking' then
        if love.keyboard.isDown('a') or love.keyboard.isDown('left') then
            self.dx = -SPEED
            self.state = 'moving'
            self.direction = 'left'
            self.movement = true

        elseif love.keyboard.isDown('d') or love.keyboard.isDown('right') then
            self.dx = SPEED
            self.state = 'moving'
            self.direction = 'right'
            self.movement = true
        end

        if love.keyboard.isDown('w') or love.keyboard.isDown('up') then
            self.dy = -SPEED
            self.state = 'moving'
            self.movement = true
        elseif love.keyboard.isDown('s') or love.keyboard.isDown('down') then
            self.dy = SPEED
            self.state = 'moving'
            self.movement = true
        end

        -- Idle Checker
        if self.movement ~= true then
            self.state = 'idle' 
        else
            self.moveTimer = self.moveTimer + dt

            if self.moveTimer <= 0.1 then
                self.sounds['walking']:play()
            elseif self.moveTimer >= 0.2 then
                self.sounds['walking2']:play()
                self.moveTimer = 0
            end
        end
    end
end

-- Updates player Location
function Player:update(dt)
    self.x = self.x + self.dx * dt
    self.y = self.y + self.dy * dt

    self.dx = 0
    self.dy = 0

    if gameState == 'start' and playerClass ~= 'fighter' then
        projectile:update(dt)
    end

    if gameState == 'start' or gameState == 'play' then

        -- Gives Player invinciblity Frames
        if self.damage == true then
            self.immunityFrames = self.immunityFrames + dt
        end

        if self.immunityFrames > 0.4 then
            self.immunityFrames = 0
            self.damage = false
        end
    end
end


function Player:health()
    love.graphics.rectangle('line', 5, 5, 80, 5)
    love.graphics.setColor( 0, 0.8, 50 / 255, 1)
    love.graphics.rectangle('fill', 5, 6, 8 * self.hp, 4)
    love.graphics.setColor(1, 1, 1, 1)
end

-- Controls when player is able to attack
function Player:attack(dt)

    if self.state == 'attacking' and self.attackTimer <= 1 then
        self.attackTimer = self.attackTimer + dt

    elseif self.attackTimer == 0 then
        if love.keyboard.wasPressed('space') or love.mouse.isDown(1) then
            self.state = 'attacking'
            self.soundA = false
        end

    elseif self.attackTimer >= 1 then
        self.attackTimer = self.attackTimer - self.attackTimer
        self.animationsA[playerClass]:reset()
        self.state = 'moving'
    end

    -- Sound effects only occur once per animation
    if self.soundA == false and self.attackTimer >= 0.5 and playerClass ~= 'fighter' then
        self.sounds[playerClass]:play()
        projectile:fire(dt)
        self.soundA = true
    
    elseif self.soundA == false and self.attackTimer >= 0.5 and playerClass == 'fighter' then
        self.sounds[playerClass]:play()
        self.soundA = true
    end
end


function Player:hit()
    if love.keyboard.wasPressed('e') then
        player.hp = player.hp - 1
        self.sounds['grunt']:play()
    end

    if self.damage == false then
        player.hp = player.hp - 1
        self.sounds['grunt']:play()
        self.damage = true
    end

    if player.hp <= 0 then
        music['play']:stop()
        gameState = 'death'
        music['death']:play()
    end
end

function Player:death()
    love.mouse.setVisible(false)
    love.graphics.draw(self.images[playerClass], self.animationsD[playerClass]:getCurrentFrame(), 
            math.floor(self.x - self.Width), math.floor(self.y - self.Height), 
            0, self.scaleX, 1,
            self.Width / 2, self.Height / 2)
    
    love.graphics.printf("Your Ballad Ends Here", 0, 50, VIRTUAL_WIDTH, 'center')

    love.graphics.setFont(text)
    love.graphics.printf("Press Escape to Return to Title Screen", 0, 80, VIRTUAL_WIDTH, 'center')
    love.graphics.setFont(menu_font)
end

function Player:deathUpdate(dt)
    self.deathTimer = self.deathTimer + dt

    if self.deathTimer < 2 then
        player.animationsD[playerClass]:update(dt) -- Animation State needs to be updated
    end
end