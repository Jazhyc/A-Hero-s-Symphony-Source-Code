Menu = Class{}

--Traditional arrays don't exist in lua. Instead we use Tables which start at 1
function Menu:init()
    self.pointer = 1
    self.pointers = {'start', 'continue', 'quit'}

    -- Indexing positions of menu highlighters
    self.options = {
        ['start'] = function() love.graphics.rectangle('fill', VIRTUAL_WIDTH / 2 - 70, 88, 135, 25) end,
        ['continue'] = function() love.graphics.rectangle('fill', VIRTUAL_WIDTH / 2 - 70, 128, 135, 25) end,
        ['quit'] = function() love.graphics.rectangle('fill', VIRTUAL_WIDTH / 2 - 70, 168, 135, 25) end
    }

    self.sounds = {
        ['select'] = love.audio.newSource("Sounds/select.wav", 'static'),
        ['lock'] = love.audio.newSource("Sounds/lock.wav", 'static')
    }
    self.sounds['select']:setVolume(0.3)

    self.images = {
        ['background'] = love.graphics.newImage("Images/menu.png")
    }
    self.menuWidth = self.images['background']:getWidth()
    self.menuHeight = self.images['background']:getHeight()
end


function Menu:select()

    -- Menu Controls
    if gameState == 'title' then
        if love.keyboard.wasPressed('s') or love.keyboard.wasPressed('down') then
            if self.pointer ~= 3 then
                self.pointer = self.pointer + 1
                self.sounds['select']:play()
            end
        end

        if love.keyboard.wasPressed('w') or love.keyboard.wasPressed('up') then
            if self.pointer ~= 1 then
                self.pointer = self.pointer - 1
                self.sounds['select']:play()
            end
        end
    end

    -- Returns player to title screen after credits
    if gameState == 'credits' then
        if love.keyboard.wasPressed('return') or love.keyboard.wasPressed('space') then
            gameState = 'title'
            self.sounds['select']:play()
            return -- Prevents interruptions with below events
        end
    end

    -- Menu events, some events contradict each other    
    if gameState == 'title' then
        if (love.keyboard.wasPressed('return') or love.keyboard.wasPressed('space')) and self.pointer == 3 then
            self.sounds['lock']:play()
            love.event.quit()

        elseif (love.keyboard.wasPressed('return') or love.keyboard.wasPressed('space')) and self.pointer == 2 then
            gameState = 'credits'
            self.sounds['lock']:play()

        elseif (love.keyboard.wasPressed('return') or love.keyboard.wasPressed('space')) and self.pointer == 1 then
            gameState = 'PlayerSelect'
            self.sounds['lock']:play()
            love.keyboard.keysPressed = {}
        end
    end
end


function Menu:render()
    if gameState == 'title' then
        love.graphics.draw(self.images['background'], 0, 0, 0,
            VIRTUAL_WIDTH / self.menuWidth, VIRTUAL_HEIGHT / self.menuHeight)
        updateMenu()

        love.graphics.setColor(0, 0, 0, 1)
        love.graphics.setFont(menu_font)
        love.graphics.printf("A Hero's Symphony", 0, 25, VIRTUAL_WIDTH, 'center')

        love.graphics.printf("New Game", 0, 90, VIRTUAL_WIDTH, 'center')
        love.graphics.printf("Credits", 0, 130, VIRTUAL_WIDTH, 'center')
        love.graphics.printf("Quit", 0, 170, VIRTUAL_WIDTH, 'center')
    end

    if gameState == 'credits' then

        love.graphics.clear(150 / 255, 45 / 255, 60 / 255, 255 / 255)
        love.graphics.setFont(text)
        love.graphics.printf("Programming by JazHyc", 0, 10, VIRTUAL_WIDTH, 'center')
        love.graphics.printf("Sprites by Calciumtrice", 0, 40, VIRTUAL_WIDTH, 'center')
        love.graphics.printf("Title Theme by Mathew Pablo", 0, 70, VIRTUAL_WIDTH, 'center')
        love.graphics.printf("Battle Theme by mrpoly", 0, 100, VIRTUAL_WIDTH, 'center')
        love.graphics.printf("Boss Theme by 3xBlast", 0, 130, VIRTUAL_WIDTH, 'center')
        love.graphics.printf("Death Theme by Cleyton Xavier", 0, 160, VIRTUAL_WIDTH, 'center')
        love.graphics.printf("Sound Effects by Denizens of the Internet", 0, 190, VIRTUAL_WIDTH, 'center')
        love.graphics.printf("Thank You cs50", 0, 220, VIRTUAL_WIDTH, 'center')
    end
end

-- Updates choice in menu, self is not working for some reason
function updateMenu()
    love.graphics.setColor(1, 1, 1, 0.2)
    menu.options[menu.pointers[menu.pointer]]()
    love.graphics.setColor(1, 1, 1, 1)
end