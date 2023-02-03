module My.Numbertheory (
    powm)
where

powm :: Integral a => a -> a -> a -> a
powm m b e = loop b e 1
    where
    loop b 1 acc = (b * acc) `mod` m
    loop b e acc
        | even e = loop ((b * b) `mod` m) (e `div` 2) acc
        | odd e = loop ((b * b) `mod` m) (e `div` 2) ((acc * b) `mod` m)