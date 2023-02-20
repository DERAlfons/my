# Revision history for my

## 0.0.0.7 -- 2023-02-20

New function in Util:

* `maybeToIO`: Create an `IO` action from a `Maybe` value, which returns `a` in
  case of `Just a` and raises an exception with the given error message in case
  of `Nothing`

## 0.0.0.6 -- 2023-02-18

New function in Util:

* `count`: Counts the number of elements in a list, which satisfy a given predicate

Changed regex engine from TDFA to PCRE

## 0.0.0.5 -- 2023-02-18

New function in Util:

* `groupsOf`: Splits a list into multiple sublists of a given length

## 0.0.0.4 -- 2023-02-10

New functions in Util:

* `sortAsc`: Sorts a list in ascending order. Just a different name for `sort` from `Data.List`
* `sortDesc`: Sorts a list in descending order

## 0.0.0.3 -- 2023-02-07

Parser code refactor:

* use do notation for Maybe in instantiation of Functor and Applicative for Parser
* specify import of Alternative from Control.Applicative

## 0.0.0.2 -- 2023-02-07

Change implementation of parser:

* make Parser an instance of Applicative
* remove obsolete parser functions

## 0.0.0.1 -- 2022-12-14

First version. Contains:

* `explode`: given a separator, splits a list into multiple sublists
* a parser, which works pretty ok, but the implementation is very rough
* `powm`: power modulo function
