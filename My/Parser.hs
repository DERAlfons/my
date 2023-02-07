module My.Parser (
    run,
    parserRegex,
    parserList)
where

import Data.Foldable (asum)
import Control.Applicative
import Control.Monad (mplus)
import Text.Regex.TDFA ((=~), mrSubList, mrAfter)

newtype Parser a = Parser (String -> Maybe (a, String))

instance Functor Parser where
    fmap f (Parser p) = Parser (\s -> case p s of
        Just (a, rest) -> Just (f a, rest)
        Nothing -> Nothing)

instance Applicative Parser where
    pure a = Parser (\s -> Just (a, s))

    (Parser pf) <*> (Parser pa) = Parser (\s -> case pf s of
        Just (f, rest) -> case pa rest of
            Just (a, rest2) -> Just (f a, rest2)
            Nothing -> Nothing
        Nothing -> Nothing)

instance Alternative Parser where
    empty = Parser (const Nothing)

    (Parser p1) <|> (Parser p2) = Parser (\s -> mplus (p1 s) (p2 s))

run :: Parser a -> String -> Maybe a
run (Parser p) = (fmap fst) . p

parserRegex :: String -> ([String] -> a) -> Parser a
parserRegex regex f = Parser (\s ->
    if s =~ ("\\`" ++ regex) then
        let mr = s =~ ("\\`" ++ regex) in
        Just (f $ mrSubList mr, mrAfter mr)
    else
        Nothing)

parserList :: String -> String -> String -> Parser a -> Parser [a]
parserList opn sep cls p =
    parserRegex opn (const ()) *>
    asum [
        (:) <$> p <*> many (parserRegex sep (const ()) *> p),
        pure []] <*
    parserRegex cls (const())