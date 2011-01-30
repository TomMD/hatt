{-# OPTIONS_HADDOCK hide #-}

module Logic.Propositional.Tables
    ( truthTable
    ) where

import Logic.Propositional.Core

import Data.Map (fold)

-- | The 'truthTable' function produces a truth table for the given expression.
truthTable :: Expr -> String
truthTable expr = unlines [header, separator, body]
  where
    header    = unwords vs ++ " | " ++ show expr
    body      = unlines $ map (showAssignment expr) as
    separator = concat $ replicate sepLength "-"
    sepLength = length vs * 2 + length (show expr) + 2
    as        = assignments expr
    vs        = variables   expr

showAssignment :: Expr -> Mapping -> String
showAssignment expr a = showVarValues ++ " | " ++ showExprValue
  where
    showVarValues = unwords $ fold ((:) . showBool) [] a
    showExprValue = showBool $ interpret expr a

showBool :: Bool -> String
showBool True  = "T"
showBool False = "F"
