

-- use fallback to do inheritance dispatch
function Inherit(object, field)
   if field == "parent" then return nil end
   if type(object.parent) ~= "table" then return nil end
   return object.parent[field]
end
setfallback("index", Inherit)

makeShape = function()
   return {
      x = newx,
      y = newy,

      -- accessors for x & y
      getX = function (self) return self.x end,
      getY = function (self) return self.y end,
      setX = function (self, newx) self.x = newx end,
      setY = function (self, newy) self.y = newy end,

      -- move the x & y position of the object
      moveTo = function (self, newx, newy)
         self:setX(newx)
         self:setY(newy)
      end,
      rMoveTo = function (self, deltax, deltay)
         self:moveTo(self:getX() + deltax, self:getY() + deltay)
      end,

      -- virtual draw method
      draw = function (self) end
   }
end

function makeRectangle(newx, newy, newwidth, newheight)
   return {
      parent = makeShape(newx, newy),
      width = newwidth,
      height = newheight,

      -- accessors for the width & height
      getWidth = function (self) return self.width end,
      getHeight = function (self) return self.height end,
      setWidth = function (self, newwidth) self.width = newwidth end,
      setHeight = function (self, newheight) self.height = newheight end,

      -- draw the rectangle
      draw = function (self)
         write(format("Drawing a Rectangle at:(%d,%d), width %d, height %d\n",
            self:getX(), self:getY(), self:getWidth(), self:getHeight()))
      end
   }
end

function makeCircle(newx, newy, newradius)
   return {
      parent = makeShape(newx, newy),
      radius = newradius,

      -- accessors for the radius
      getRadius = function (self) return self.radius end,
      setRadius = function (self, newradius) self.radius = newradius end,

      -- draw the circle
      draw = function (self)
         write(format("Drawing a Circle at:(%d,%d), radius %d\n",
            self:getX(), self:getY(), self:getRadius()))
      end
   }
end

--[[Double-dashes immediately followed by double left square bracket
    Begin a multi-line comment
    function NotDisplayed()
    end  ]]

function TryMe()
   -- set up some shape instances
   scribble = {makeRectangle(10, 20, 5, 6), makeCircle(15, 25, 8)}

   -- iterate through the array and handle shapes polymorphically
   local i = 0
   while i < 2 do
      i = i + 1
      scribble[i]:draw()
      scribble[i]:rMoveTo(100, 100)
      scribble[i]:draw()
   end

   -- access a rectangle specific function
   arect = makeRectangle(0, 0, 15, 15)
   arect:setWidth(30)
--   arect:draw()
end



TryMe()