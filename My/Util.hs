module My.Util (
    for,
    applyN,
    count,
    explode,
    groupsOf,
    sortAsc,
    sortDesc,
    sortAscOn,
    sortDescOn,
    maybeToIO)
where

import Data.Function (on)
import Data.List (sort, sortBy, sortOn)

for :: [a] -> (a -> b) -> [b]
for = flip map

applyN :: Int -> (a -> a) -> a -> a
applyN 0 _ x = x
applyN n f x = applyN (n - 1) f (f x)

count :: (a -> Bool) -> [a] -> Int
count _ [] = 0
count p (b : bs)
    | p b = 1 + count p bs
    | otherwise = count p bs

explode :: Eq a => a -> [a] -> [[a]]
explode _ [] = []
explode sep list = case break (== sep) list of
    (e, []) -> [e]
    (e, _ : rest) -> e : explode sep rest

groupsOf :: Int -> [a] -> [[a]]
groupsOf _ [] = []
groupsOf n bs =
    let (g, rest) = splitAt n bs in
    g : groupsOf n rest

sortAsc :: (Ord a) => [a] -> [a]
sortAsc = sort

sortDesc :: (Ord a) => [a] -> [a]
sortDesc = sortBy (flip compare)

sortAscOn :: (Ord b) => (a -> b) -> [a] -> [a]
sortAscOn = sortOn

sortDescOn :: (Ord b) => (a -> b) -> [a] -> [a]
sortDescOn f = sortBy (flip compare `on` f)

maybeToIO :: String -> Maybe a -> IO a
maybeToIO _ (Just a) = return a
maybeToIO errorMsg Nothing = fail errorMsg