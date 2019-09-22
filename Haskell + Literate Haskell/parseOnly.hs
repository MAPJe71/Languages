{-# LANGUAGE OverloadedStrings #-}

import Control.Applicative
import Control.Arrow (second)
import Control.Monad
import Data.Attoparsec.Char8 as P hiding (skipWhile)
import Data.Attoparsec (skipWhile)
import Data.Function (on)
import Data.List
import Data.Maybe
import Data.Monoid
import Data.Ord
import Numeric.LinearAlgebra -- from the "hmatrix" package

type Point = Vector Double

data Atom = Atom {
    chainID :: Char,
    resSeq  :: Int,
    coord   :: Point }
    deriving (Show)

skip n = void $ P.take n
decimal' = skipSpace >> decimal
double'  = skipSpace >> P.double

pAtom :: Parser Atom
pAtom = do
    string "ATOM  "        -- Must be an "ATOM  " record
    skip 6
    string " CA "          -- Must be an alpha carbon
    satisfy (inClass " A") -- First confirmation (' ' or 'A')
    skip 4
    _chainID <- anyChar
    _resSeq <- decimal'
    skip 1
    x <- double'
    y <- double'
    z <- double'
    skip 26
    endOfLine
    return $ Atom {
        chainID = _chainID,
        resSeq  = _resSeq,
        coord   = fromList [x, y, z] }

pLine = skipWhile (not . isEndOfLine) *> endOfLine

pPDB :: Parser [Atom]
pPDB = catMaybes <$> (    many $ (Just <$> pAtom)
                      <|> (Nothing <$ pLine))

dist :: Point -> Point -> Double
dist v1 v2 = norm2 (v1 - v2)

distA :: Atom -> Atom -> Double
distA = dist `on` coord

type Context = [Atom]
type Cutoff  = Double

for = flip fmap

addContext :: Cutoff -> [Atom] -> [(Atom, Context)]
addContext cutoff as = for as $ \a1 ->
    (a1, filter (\a2 -> distA a1 a2 < cutoff) as)

windows :: Int -> [a] -> [[a]]
windows n = filter (\xs -> length xs == n)
          . map (Prelude.take n)
          . tails

duplicate a1 a2 = chainID a1 == chainID a2
               && resSeq  a1 == resSeq  a2

joinContexts :: [(Atom, Context)] -> ([Atom], Context)
joinContexts ps = (self, nonSelf)
  where self = map fst ps
        context = concat $ map snd ps
        totalContext = nubBy duplicate context
        nonSelf = deleteFirstsBy duplicate totalContext self

sequential a1 a2 = chainID a1     == chainID a2
               && (resSeq  a1 + 1 == resSeq  a2)

type Chain = [Atom]

chains' :: ([Atom] -> [Atom]) -> [Atom] -> [Chain]
chains' c []  = [c [] ]
chains' c [a] = [c [a]]
chains' c (a1:bs@(a2:as))
    | sequential a1 a2 =         chains' c' bs
    | otherwise        = (c' []):chains' id bs
  where c' = c . (a1:)

-- The actual function I use
chains :: [Atom] -> [Chain]
chains = chains' id
       . sortBy (comparing chainID `thenBy` comparing resSeq)
  where thenBy = mappend

type Window = [Atom]

distribute :: (Window, [Chain]) -> [(Window, Chain)]
distribute (x, ys) = map ((,) x) ys

type WindowSize = Int

pairs :: WindowSize -> Cutoff -> [Atom] -> [(Window, Chain)]
pairs windowSize cutoff =
    concat
  . map (distribute . second chains . joinContexts)
  . windows windowSize
  . addContext cutoff