module My.Util (
    explode,
    sortAsc,
    sortDesc)
where

import Data.List (sort, sortBy)

explode :: Eq a => a -> [a] -> [[a]]
explode _ [] = []
explode sep list = case break (== sep) list of
    (e, []) -> [e]
    (e, _ : rest) -> e : explode sep rest

sortAsc :: (Ord a) => [a] -> [a]
sortAsc = sort

sortDesc :: (Ord a) => [a] -> [a]
sortDesc = sortBy (flip compare)