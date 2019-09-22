--- Animal.lua
--
-- A simple example of a base class usng the classes library.
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

-- Create the class, with the default superclass.
local Animal = classes.class()

-- Two 'public' static class variables.
Animal.NOISE_1 = 0
Animal.NOISE_2 = 1

-- A 'private' static class variable.
local numAnimals = 0

--- Constructor.
--
-- @param name The name of this animal.
function Animal:init (name)
	-- This instance of Animal now has its own name!
	self.name = name
	-- There is only one variable 'numAnimals' (it's static), so incrementing it each time we create an Animal gets as a unique id.
	numAnimals = numAnimals + 1
	self.id = numAnimals
end

--- Makes a noise, specific to whatever animal I am.
-- This is an example of an 'abstract' method.
-- We want each Animal to be able to make a noise, but we want each subclass of Animal to decide what that noise is.
--
-- @param noiseNum This is either 0 or 1, we will say that each Animal should be able to produce 2 noises.
function Animal:makeNoise (noiseNum)
	error("I don't know what to do, I'm a generic Animal.  This should be implemented by a subclass of Animal!")
end

--- This method is available to the Animal class, and all Subclasses of Animal as well.
--
-- @return Returns the id of this Animal.
function Animal:getAnimalId ()
	return "Animal<"..self.id..">"
end

--- This is an example of a Class method.  We can't access 'self', because it represents the whole Class, not an instance of this Class.
--
-- @return Returns the total number of Animals.
function Animal.totalAnimals ()
	return numAnimals
end

-- This is important for module loading, the table returned by the 'require' method is the Animal class we created.
return Animal
