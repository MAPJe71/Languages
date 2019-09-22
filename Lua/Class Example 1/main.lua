--- main.lua
--
-- A simple program to test the functionality of the classes library.
--
-- @author Paul Moore
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
-- Import the Animal class.
local Animal = require "Animal"
-- Import the Cat class.
local Cat = require "Cat"

-- Create an instance of the Animal class.
local spider = Animal.new("Charlotte")

-- Create some instances of the Cat class.
local cat1 = Cat.new("Mio", "Orange Tabby")
local cat2 = Cat.new("Quill", "Maine Coon")

-- As you can see, each instance has its own set of instance variables.
-- Also note how the Cat class 'inherits' the Animal:getAnimalId() method from its Superclass, Animal.
print("The spider's name is: "..spider.name.." and id: "..spider:getAnimalId())
print("The first cat's name is: "..cat1.name.." and id: "..cat1:getAnimalId())
print("The second cat's name is: "..cat2.name.." and id: "..cat2:getAnimalId())
print()

-- This will generate an error!  Because spider is an instance of Animal and not Cat, Animal:makeNoise will be used
-- instead of Cat:makeNoise, thus producing an error.
--spider:makeNoise(Animal.NOISE_1)
--spider:makeNoise(Animal.NOISE_2)
--print()

-- This will not generate an error, because we have overriden the 'makeNoise' method for Cats.
cat1:makeNoise(Animal.NOISE_1)
cat1:makeNoise(Animal.NOISE_2)
print()

-- Because cat1 and cat2 are different instances of the Cat Class, we will get different results by calling the method on the other cat.
cat2:makeNoise(Animal.NOISE_1)
cat2:makeNoise(Animal.NOISE_2)
print()

-- This will generate an error, because by using '.' instead of ':', we are not giving the Cat instance reference to 'self'.
--cat1.makeNoise(Animal.NOISE_1)

-- This is a static method, thus it is called with a '.' and not a ':'.
print("The total number of Animals created is: "..Animal.totalAnimals())
print()

-- Returns 'yes', a Cat is a Cat.
print("Is cat1 an instance of the Cat class? "..tostring(cat1:instanceOf(Cat)))
-- Returns 'yes', a Cat is an Animal.
print("Is cat1 an instance of the Animal class? "..tostring(cat1:instanceOf(Animal)))
-- Returns 'true', an Animal is an Animal.
print("Is spider an instance of the Animal class? "..tostring(spider:instanceOf(Animal)))
-- Returns 'false', an Animal is not a Cat.
print("Is spider an instance of the Cat class? "..tostring(spider:instanceOf(Cat)))
-- Returns 'true', a Cat is an Object.
print("Is cat1 an instance of the root Object class? "..tostring(cat1:instanceOf(classes.Object)))
-- Returns 'true', a Spider is also an Object.
print("Is spider an instance of the root Object class? "..tostring(spider:instanceOf(classes.Object)))
