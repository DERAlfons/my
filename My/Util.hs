module My.Util (
    count,
    explode,
    groupsOf,
    sortAsc,
    sortDesc)
where

import Data.List (sort, sortBy)

count :: Eq a => (a -> Bool) -> [a] -> Int
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