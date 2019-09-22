{-# LANGUAGE CPP, Trustworthy #-}

module Control.Console (
    consoleInit,
    consoleGetLine,
    atomicGetOneChar,
    atomicPrintLn
    ) where

{- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
Here begins the system-dependent imports for the primitive operations that the
other operations within this module will depend upon.
-} -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
#ifdef Win32flag
import Control.Console.Win32 (consoleInit, readOneChar)
#else
support for other systems should go here, hashtag-yolo
#endif
{- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
consoleInit and readOneChar must have been somehow imported by now or the rest
of the module, which depends on those two functions, will not compile at all.
-} -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --

-- base
import Control.Concurrent.MVar
import Control.Monad (unless)

{-| Gets one line from the user. There is minimal special support. Use of tab
inserts 4 spaces. Use of C-d will count as the enter key (hopefully).
-}
consoleGetLine = lineGrab ""

{-| Returns a line from the user. The input string is the stack of character
input so far, which gets reversed and returned once the line is completed.
-}
lineGrab :: String -> IO String
lineGrab lookback = do
    c <- readOneChar
    case c of
        '\r' -> putStr "\n" >> return (reverse lookback) -- windows uses \r at the end of lines.
        '\n' -> putStr "\n" >> return (reverse lookback) -- unix uses \n.
        '\EOT' -> putStr "\n" >> return (reverse lookback) -- we will treat C-d as if it was enter.
        '\b' -> if null lookback -- don't backspace earlier than the "start" of the input point.
            then lineGrab []
            else putStr "\b \b" >> lineGrab (drop 1 lookback)
        '\t' -> putStr "    "  >> lineGrab ("    "++lookback)
        _ -> putChar c >> lineGrab (c:lookback)

{-| This is like 'withMVar', but for when your IO action doesn't depend on the
contents of the MVar. All the standard 'withMVar' warning apply of course.
-}
{-# INLINE withMVar_ #-}
withMVar_ :: MVar a -> IO b -> IO b
withMVar_ mvar iob = withMVar mvar (\_ -> iob)

{-| This gets one character of input and then uses the console lock to show
the results appropriately and update the buffer. The result is a possible user
input command.
-}
atomicGetOneChar :: MVar [Char] -> IO (Maybe String)
atomicGetOneChar lock = do
    c <- readOneChar
    modifyMVar lock $ \buffer -> do -- modifyMVar :: MVar [Char] -> ([Char] -> IO ([Char], Maybe String)) -> IO (Maybe String)
        case c of
            '\r' -> putStr "\n" >> return ([], Just $ reverse buffer) -- windows uses \r at the end of lines.
            '\n' -> putStr "\n" >> return ([], Just $ reverse buffer) -- unix uses \n.
            '\EOT' -> putStr "\n" >> return ([], Just $ reverse buffer) -- we will treat C-d as if it was enter.
            '\b' -> if null buffer -- don't backspace earlier than the "start" of the input point.
                then return ([], Nothing)
                else putStr "\b \b" >> return (drop 1 buffer, Nothing)
            '\t' -> putStr "    "  >> return ("    "++buffer,Nothing)
            _ -> putChar c >> return (c:buffer,Nothing)

{-| performs a putStrLn action while holding the lock given and with special
processing to attempt to keep the buffered text working properly.
-}
atomicPrintLn :: MVar [Char] -> String -> IO ()
atomicPrintLn lock message = withMVar lock $ \buffer -> do
    -- clear the currently displayed buffer text
    putStr (take (length buffer) $ repeat '\b')
    putStr (take (length buffer) $ repeat ' ')
    putStr (take (length buffer) $ repeat '\b')
    -- print the message
    putStrLn message
    -- restore the displayed buffer
    putStr (reverse buffer)
