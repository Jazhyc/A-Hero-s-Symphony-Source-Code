WINDOW_WIDTH, WINDOW_HEIGHT = love.window.getDesktopDimensions()

VIRTUAL_WIDTH = 432
VIRTUAL_HEIGHT = 243

TILE_WIDTH = 16
TILE_HEIGHT = 16

MAP_WIDTH = 27
MAP_HEIGHT = 15

push = require 'push'
Class = require 'class'
sti = require 'sti'

-- I hate collsion detection
bump = require 'bump'

-- Classes Galore
require 'Util'
require 'Animation'
require 'Menu'
require 'Player'
require 'PlayerSelect'
require 'Map'
require 'Entity'
require 'Projectile'
require 'Enemy'
require 'Boss'

function love.load()

    gameState = 'title'

    crosshair = love.mouse.getSystemCursor('crosshair')
    love.mouse.setVisible(false)

    menu = Menu()
    player = Player()
    playerSelect = PlayerSelect()

    music = {
        ['title'] = love.audio.newSource('Sounds/Soliloquy.mp3', 'static'),
        ['play'] = love.audio.newSource('Sounds/awesomeness.wav', 'static'),
        ['boss'] = love.audio.newSource('Sounds/boss.ogg', 'static'),
        ['death'] = love.audio.newSource('Sounds/Retro_No hope.wav', 'static')
    }

    playerClass = 'null'

    text = love.graphics.newFont('Fonts/EightBitDragon-anqx.ttf', 12)
    menu_font = love.graphics.newFont('Fonts/EightBitDragon-anqx.ttf', 24)

    love.window.setTitle("A Hero's Symphony")

    love.graphics.setDefaultFilter('nearest', 'nearest')

    push:setupScreen(VIRTUAL_WIDTH, VIRTUAL_HEIGHT, WINDOW_WIDTH, WINDOW_HEIGHT, {
        fullscreen = false,
        vsync = true,
        resizeable = false 
    })

    love.keyboard.keysPressed = {}
    
    music['title']:setLooping(true)
    music['play']:setLooping(true)
    music['boss']:setLooping(true)
    music['title']:setVolume(0.4)
    music['play']:setVolume(0.4)
    music['boss']:setVolume(0.4)
    music['title']:play()
end

function love.keyboard.wasPressed(key) -- Can't use keyPressed outside main
    return love.keyboard.keysPressed[key]
end


function love.keypressed(key)

    if gameState == 'title' or gameState == 'credits' or gameState == 'start' then
        if key == 'escape' then
            love.event.quit()
        end

    elseif gameState == 'PlayerSelect' then
        if key == 'escape' then
            gameState = 'title'
            menu.sounds['select']:play()
        end

    -- Return from death
    elseif gameState == 'death' or gameState == 'end' then
        if key == 'escape' or key == 'return' then
            gameState = 'title'
            player.hp = 10
            player.deathTimer = 0
            player.x = VIRTUAL_WIDTH / 2
            player.y = VIRTUAL_HEIGHT / 2
            music['death']:stop()
            music['title']:play()
            return
        end
    end

    love.keyboard.keysPressed[key] = true
end


function love.update(dt)

    mouseX = love.mouse.getX()
    mouseY = love.mouse.getY()

    -- First menus of the game
    if gameState == 'title' or gameState == 'credits' or gameState == 'PlayerSelect' then
        menu:select()
        playerSelect:select()
    end

    if gameState == 'PlayerSelect' or gameState == 'start' then
        player:supdate(dt)
        player:update(dt)

    end

    if gameState == 'start' then
        love.mouse.setVisible(true)
        love.mouse.setCursor(crosshair)
        map1:update(dt)
        player:control(dt)

    end

    if gameState == 'death' then
        player:deathUpdate(dt)
        map = 'hideout'
        coll = bump.newWorld()
        coll:add(player, player.x, player.y, player.Width / 1.5, player.Height / 2)
        Hideout:bump_init(coll)
    end

    if gameState == 'end' then
        love.mouse.setVisible(false)
        gameEnd(dt)
    end
    
    love.keyboard.keysPressed = {} -- Order Matters

end

-- Draws Textures on screen depending on gamestate
function love.draw(dt)
    push:apply('start')

    if gameState == 'title' or gameState == 'credits' then
        menu:render()
    end

    if gameState == 'PlayerSelect' then
        playerSelect:render()
        player:select()
    end

    if gameState == 'start' then
        map1:render(dt)

        player:render()
        
    end

    if gameState == 'death' then
        player:death()
    end

    if gameState == 'end' then
        gameEndRender()
    end

    push:apply('end')
    displayFPS()
end

function displayFPS()
    love.graphics.setColor(0, 1, 0, 1)
    love.graphics.print('FPS: ' .. tostring(love.timer.getFPS()), 10, VIRTUAL_HEIGHT * 3) -- .. is a concatenation operator
    love.graphics.setColor(1, 1, 1, 1)
end

function gameEnd(dt)
    if minotaur.deathTimer < 2.9 then
        minotaur.animations['death']:update(dt)
        minotaur.deathTimer = minotaur.deathTimer + dt
    end
end

function gameEndRender()
    love.graphics.draw(minotaur.sprite, minotaur.animations['death']:getCurrentFrame(),
        math.floor(minotaur.x - minotaur.Width), math.floor(minotaur.y - minotaur.Height + 5), 
        0, minotaur.scaleX, 1, 
        minotaur.Width / 2, minotaur.Height / 2)

        if minotaur.deathTimer > 2.9 then
            -- End Fluff Text
            love.graphics.setFont(text)
            love.graphics.printf("You have Slain the Dark Lord", 0, 20, VIRTUAL_WIDTH, 'center')
            love.graphics.printf("Without his guidance, his amassed armies disperse into chaos", 0, 40, VIRTUAL_WIDTH, 'center')
            love.graphics.printf("Having overcome the vigorous trial of the dungeon,", 0, 60, VIRTUAL_WIDTH, 'center')
            love.graphics.printf("you leave this God Forsaken Place", 0, 80, VIRTUAL_WIDTH, 'center')
            love.graphics.printf("Your Song will be sung for eons to come", 0, 100, VIRTUAL_WIDTH, 'center')
            love.graphics.printf("Congratulations, you have completed the Game", 0, 180, VIRTUAL_WIDTH, 'center')
            love.graphics.printf("Press Escape to return to the Title Screen", 0, 200, VIRTUAL_WIDTH, 'center')
        end
end