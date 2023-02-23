module My.Parser (
    Parser (Parser),
    run,
    parserRegex,
    parserList)
where

import Data.Foldable (asum)
import Control.Applicative (Alternative (..))
import Control.Monad (mplus)
import Text.Regex.PCRE ((=~), mrSubList, mrAfter)

newtype Parser a = Parser (String -> Maybe (a, String))

instance Functor Parser where
    fmap f (Parser p) = Parser (\s -> do
        (a, rest) <- p s
        return (f a, rest))

instance Applicative Parser where
    pure a = Parser (\s -> Just (a, s))

    (Parser pf) <*> (Parser pa) = Parser (\s -> do
        (f, rest1) <- pf s
        (a, rest2) <- pa rest1
        return (f a, rest2))

instance Alternative Parser where
    empty = Parser (const Nothing)

    (Parser p1) <|> (Parser p2) = Parser (\s -> mplus (p1 s) (p2 s))

run :: Parser a -> String -> Maybe a
run (Parser p) = (fmap fst) . p

parserRegex :: String -> ([String] -> a) -> Parser a
parserRegex regex f = Parser (\s ->
    if s =~ ("(?-m)^" ++ regex) then
        let mr = s =~ ("(?-m)^" ++ regex) in
        Just (f $ mrSubList mr, mrAfter mr)
    else
        Nothing)

parserList :: String -> String -> String -> Parser a -> Parser [a]
parserList opn sep cls p =
    parserRegex opn (const ()) *>
    asum [
        (:) <$> p <*> many (parserRegex sep (const ()) *> p),
        pure []] <*
    parserRegex cls (const ())