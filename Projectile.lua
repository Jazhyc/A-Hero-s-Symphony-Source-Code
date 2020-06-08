Projectile = Class{}

local PROJECTILE_SPEED = 125
local suit = require 'suit'

function Projectile:init(playerClass)
    -- Initial position of the arrow
    self.x = player.x
    self.y = player.y
    self.timer = 0
    
    if playerClass == 'ranger' then
        self.multiplier = 2
    else
        self.multiplier = 1
    end

    -- TableplayerClass projectiles
    self.classProjectiles = {
        ['ranger'] = {'arrow.png', 32, 32},
        ['mage'] = {'fireball.png', 32, 32},
        ['fighter'] = 'none'
    }

    self.sounds = {
        ['ranger'] = love.audio.newSource('Sounds/arrowHit.wav', 'static'),
        ['mage'] = love.audio.newSource('Sounds/fireballHit.wav', 'static')
    }

    projectiles = {} -- Table of all Projectiles

    self.Width = self.classProjectiles[playerClass][2]
    self.Height = self.classProjectiles[playerClass][3]

    if playerClass ~= 'fighter' then
        self.image = love.graphics.newImage('Images/' .. tostring(self.classProjectiles[playerClass][1]))
        self.frames = generateQuads(self.image, self.Width, self.Height)

        self.animation = Animation {
            texture = self.image,
            frames = {
                self.frames[1], self.frames[2], self.frames[3], self.frames[4]
            },
            interval = 0.1
        }
    end
end

-- Renders arrows or fireballs
function Projectile:render()

    for i, v in ipairs(projectiles) do
        love.graphics.draw(self.image, self.animation:getCurrentFrame(),
            math.floor(v.x), math.floor(v.y),
            v.rotation, 1, 1)
    end
end

-- Updates projectiles present in the table, deletes them if they go offscreen
function Projectile:update(dt)
    for i,v in ipairs(projectiles) do
        v.x = v.x + v.dx * dt
        v.y = v.y + v.dy * dt
        self.animation:update(dt)

        if v.x < 0 or v.x >= 420 then
            table.remove(projectiles, i)
            self.sounds[playerClass]:play()
        end

        if v.y < 0 or v.y >= 243 then
            table.remove(projectiles, i)
            self.sounds[playerClass]:play()
        end
    end
end

-- Responsible for firing projectile, this must be one of Satan's abominations
function Projectile:fire(dt)
    local startX = player.x + player.Width / 2
    local startY = player.y + player.Height / 2 
    local mouseX = love.mouse.getX()
    local mouseY = love.mouse.getY()

    local inclination = math.atan2((mouseY / 2.22 - startY), (mouseX / 2.22 - startX)) -- Inclination of Image
    local angle = math.atan2((mouseY / 2.22 - startY), (mouseX / 2.22 - startX)) -- Angle of Trajectory

    if mouseX / 2.5 < player.x then
        startY = player.y + 64
        startX = player.x + 32
    end

    if mouseY / 2.5 > player.y then
        startY = startY - 16
        startX = startX + 16
    end 

    local bulletDx = PROJECTILE_SPEED * math.cos(angle) * self.multiplier
    local bulletDy = PROJECTILE_SPEED * math.sin(angle) * self.multiplier

    table.insert(projectiles, {x = startX - 65, y = startY - 70, dx = bulletDx, dy = bulletDy, rotation = angle})
end