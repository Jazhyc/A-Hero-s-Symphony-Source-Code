Entity = Class{}

function Entity:init(x, y, width, height, image)
    -- Coordinates of the object
    self.x = x
    self.y = y
    self.Width = width
    self.Height = height
    self.state = 'idle'
    self.id = image

    self.sprite = love.graphics.newImage('Images/' .. image)
    self.frames = generateQuads(self.sprite, self.Width, self.Height)

    self.animations = {
        ['idle'] = Animation {
            texture = self.sprites,
            frames = {
                self.frames[1], self.frames[2], self.frames[3], self.frames[4], self.frames[5],
                self.frames[6], self.frames[7], self.frames[8], self.frames[9], self.frames[10]
            },
            interval = 0.25
        }
    }
end

function Entity:update(dt)
    self.animations['idle']:update(dt)
end

function Entity:render()
    -- Set Direction
    if self.id == 'minotaur.png' then
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

    if self.state == 'idle' then 
        love.graphics.draw(self.sprite, self.animations['idle']:getCurrentFrame(),
        math.floor(self.x - self.Width), math.floor(self.y - self.Height + 5), 
        0,self.scaleX, 1, 
        self.Width / 2, self.Height / 2)
    end
end
