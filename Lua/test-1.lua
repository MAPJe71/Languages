
-- Single Line Comment Examples

--  Single line comment     function ShouldNotShow_SLC_1() end
--- Single line comment     function ShouldNotShow_SLC_2() end
--[ Single line comment     function ShouldNotShow_SLC_3() end



-- Multi Line / Block Comment Examples

--[[        <- start-of-comment-block indicator
    function ShouldNotShow_MLC_1() end
]]       -- <- end-of-comment-block indicator

    --[[    <- start-of-comment-block indicator indented
        function ShouldNotShow_MLC_2() end
    ]]   -- <- end-of-comment-block indicator indented

    --[[    <- start-of-comment-block indicator indented
        function ShouldNotShow_MLC_3() end
]]       -- <- end-of-comment-block indicator not indented

--[[        <- start-of-comment-block indicator not indented
        function ShouldNotShow_MLC_4() end
    ]]   -- <- end-of-comment-block indicator indented

--[[        <- start-of-comment-block indicator
    function ShouldNotShow_MLC_5() end
--]]     -- <- end-of-comment-block indicator, leading dashes part of comment

---[[       <- start-of-comment-block indicator changed into single line comment by adding a single dash
    function ShouldShow_MLC_6() end
--]]     -- <- end-of-comment-block indicator w/ leading dashes automatically interpreted as single line comment

--[=[
    function ShouldNotShow_MLC_7() end
]=]



