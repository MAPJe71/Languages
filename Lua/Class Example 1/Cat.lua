--- Cat.lua
--
-- A simple example of Subclassing using the classes library.
--
-- @author PaulMoore
--
-- Copyright (C) 2011 by Strange Ideas Software
--
-- Permission is hereby granted, free of charge, to any person obtaining a copy
-- of this software and associated documentation files (the "Software"), to deal
-- in the Software without restriction, including without limitation the rights
-- to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
-- copies of the Software, and to permit persons to whom the Software is
-- furnished to do so, subject to the following conditions:
--
-- The above copyright notice and this permission notice shall be included in
-- all copies or substantial portions of the Software.
--
-- THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
-- IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
-- FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
-- AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
-- LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
-- OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
-- THE SOFTWARE.

-- Import the classes library.
local classes = require "classes"
-- Make sure to import the Superclass!
local Animal = require "Animal"

-- Create the Subclass.
local Cat = classes.class(Animal)

--- Constructor.  In addition to a name, it also takes in a cat breed.
--
-- @param breed The breed of the cat.
function Cat:init(name, breed)
	-- Make sure to call the super constructor!
	self.super:init(name)
	-- Next, do some custom instantiation.
	self.breed = breed
end

--- This is an instance method specific to the Cat class.
function Cat:meow ()
	print("meow "..self.name.." meow")
end

--- This is another example of an instance method, also specific to the Cat class.
function Cat:purr ()
	print("purr I'm a "..self.breed.." cat.")
end

--- This is an example of overriding an instance method.
-- When this method is called on a Cat instance, this method is used instead of the one declared in Animal.
-- If we didn't override this method, Animal:makeNoise would be called, and generate an error.
function Cat:makeNoise (noiseNum)
	if noiseNum == Animal.NOISE_1 then
		self:meow()
	elseif noiseNum == Animal.NOISE_2 then
		self:purr()
	else
		error("Unknown noise type: "..noiseNum.." for Cat with id: "..self.id)
	end
end

-- Return the Cat class
return Cat
