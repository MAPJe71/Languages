
module Main where

-- base
import Control.Concurrent (threadDelay)
import Control.Concurrent.MVar (MVar, newMVar)
-- async
import Control.Concurrent.Async (withAsync)
-- galaxy-break
import Control.Console (consoleInit, atomicGetOneChar, atomicPrintLn)

-- counts off a number every 1 second.
counter :: MVar [Char] -> IO ()
counter lock = counter' 0 where
    counter' n = do
        threadDelay 1000000 -- 1 second
        atomicPrintLn lock (show n)
        counter' (n+1)

main :: IO ()
main = do
    consoleInit
    theLock <- newMVar [] -- the console's buffer starts empty
    atomicPrintLn theLock "I will count, you can also say things for me to say."
    let loop = do
            result <- atomicGetOneChar theLock
            case result of
                Nothing -> loop
                Just line -> do
                    atomicPrintLn theLock $ "Input:" ++ line
                    if null line
                        then atomicPrintLn theLock $ "Exiting."
                        else loop
    withAsync (counter theLock) $ \_ -> loop
-- fin
