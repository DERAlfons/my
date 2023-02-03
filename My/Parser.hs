module My.Parser (
    Parser (Parser),
    parser,
    parserL,
    parserRegex,
    parserList,
    run)
where

import Data.Maybe
import Control.Monad
import Text.Regex.TDFA ((=~), mrSubList, mrAfter)

newtype Parser a = Parser (String -> Maybe (a, String))

instance Semigroup (Parser a) where
    (Parser p1) <> (Parser p2) = Parser (\s -> mplus (p1 s) (p2 s))

instance Monoid (Parser a) where
    mempty = Parser (const Nothing)

instance Functor Parser where
    fmap f (Parser p) = Parser (\s -> case p s of
        Just (a, rest) -> Just (f a, rest)
        Nothing -> Nothing)

run :: Parser a -> String -> Maybe a
run (Parser p) = (fmap fst) . p

parserRegex :: String -> ([String] -> a) -> Parser a
parserRegex regex f = Parser (\s ->
    if s =~ ("\\`" ++ regex)
    then
        let mr = s =~ ("\\`" ++ regex)
        in Just (f $ mrSubList mr, mrAfter mr)
    else
        Nothing)

parser :: [(String, [String] -> a)] -> String -> a
parser rules s = fromJust $ msum $ do
    (regex, fn) <- rules
    guard $ s =~ regex
    return $ Just $ fn $ mrSubList $ s =~ regex

parserList :: String -> String -> String -> Parser a -> Parser [a]
parserList opn sep cls (Parser parse) = Parser $ Just . parserL opn sep cls (fromJust . parse)

parserL :: String -> String -> String -> (String -> (a, String)) -> String -> ([a], String)
parserL opn sep cls parse s = loop [] s
    where
    loop es = parser [
        ("\\`(" ++ opn ++ ")?(" ++ cls ++ ")(.*)\\'", \[_, _, s] -> (reverse es, s)),
        ("\\`(" ++ opn ++ "|" ++ sep ++ ")(.*)\\'", \[_, s] ->
            let (e, rest) = parse s
            in loop (e : es) rest)]