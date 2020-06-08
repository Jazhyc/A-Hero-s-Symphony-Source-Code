-- Module handling selection of classes
PlayerSelect = Class{}

local RECTANGLE_WIDTH = 100
local RECTANGLE_HEIGHT = 120

function PlayerSelect:init()
    self.pointer = 1
    self.pointers = {'fighter', 'ranger', 'mage'}

    self.options = {
        ['fighter'] = 1,
        ['ranger'] = 2,
        ['mage'] = 3
    }

    self.images = {
        ['warriorBG'] = love.graphics.newImage("Images/warriorBG.png"),
        ['rangerBG'] = love.graphics.newImage("Images/rangerBG.png"),
        ['mageBG'] = love.graphics.newImage("Images/mageBG.jpg")
    }

end


function PlayerSelect:select()

     -- Menu Controls
     if gameState == 'PlayerSelect' then
        if love.keyboard.wasPressed('d') or love.keyboard.wasPressed('right') then
            if self.pointer ~= 3 then
                self.pointer = self.pointer + 1
                menu.sounds['select']:play()
            end
        end

        if love.keyboard.wasPressed('a') or love.keyboard.wasPressed('left') then
            if self.pointer ~= 1 then
                self.pointer = self.pointer - 1
                menu.sounds['select']:play()
            end
        end

        if (love.keyboard.wasPressed('return') or love.keyboard.wasPressed('space')) and self.pointer == 3 then
            menu.sounds['lock']:play()
            playerClass = 'mage'
            projectile = Projectile('mage')
            map1 = Map()
            gameState = 'start'
            music['title']:stop()
            music['play']:play()

        elseif (love.keyboard.wasPressed('return') or love.keyboard.wasPressed('space')) and self.pointer == 2 then
            menu.sounds['lock']:play()
            playerClass = 'ranger'
            projectile = Projectile('ranger')
            map1 = Map()
            gameState = 'start'
            music['title']:stop()
            music['play']:play()

        elseif (love.keyboard.wasPressed('return') or love.keyboard.wasPressed('space')) and self.pointer == 1 then
            menu.sounds['lock']:play()
            playerClass = 'fighter'
            map1 = Map()
            gameState = 'start'
            music['title']:stop()
            music['play']:play()
        end
    end
end

-- Renders the Class selection screen
function PlayerSelect:render()
    love.graphics.clear(30 / 255, 30 / 255, 45 / 255, 255 / 255)

    love.graphics.draw(self.images['warriorBG'], 50, 50, 0,
        0.132, 0.282)

    love.graphics.draw(self.images['rangerBG'], 170, 50, 0,
        0.155, 0.25)
            
    love.graphics.draw(self.images['mageBG'], 290, 50, 0,
        0.078, 0.116)

    love.graphics.printf("Choose Your Class", 0, 10, VIRTUAL_WIDTH, 'center')
    love.graphics.printf("Fighter", 55, 180, VIRTUAL_WIDTH, 'left')
    love.graphics.printf("Ranger", 10, 180, VIRTUAL_WIDTH, 'center')
    love.graphics.printf("Mage", -55, 180, VIRTUAL_WIDTH, 'right')

    love.graphics.setColor(1, 1, 1, 1)
    love.graphics.rectangle('line', 50 + (self.pointer - 1) * 120, 50, RECTANGLE_WIDTH, RECTANGLE_HEIGHT)
end