# Revision history for my

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
