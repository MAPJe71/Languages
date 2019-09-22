sum' :: [Int] -> IO ()
sum' xs = do
    putStr $ show xs ++ " "
    print $ sum xs

main = do
    sum' [1, 2]
    sum' [1, 2, 3]

    let nums = [1, 2, 3, 4]
    sum' nums
