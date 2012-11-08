{-# OPTIONS_HADDOCK hide #-}

module Data.Logic.Propositional.NormalForms
    ( toNNF
    , toCNF
    , toDNF
    ) where

import Data.Logic.Propositional.Core

toNNF :: Expr -> Expr
toNNF expr@(Variable _)                    = expr
toNNF expr@(Negation (Variable _))         = expr
toNNF (Negation (Negation expr))           = expr

toNNF (Conjunction exp1 exp2)              = toNNF exp1 `conj` toNNF exp2
toNNF (Negation (Conjunction exp1 exp2))   = toNNF $ neg exp1 `disj` neg exp2

toNNF (Disjunction exp1 exp2)              = toNNF exp1 `disj` toNNF exp2
toNNF (Negation (Disjunction exp1 exp2))   = toNNF $ neg exp1 `conj` neg exp2

toNNF (Conditional exp1 exp2)              = toNNF $ neg exp1 `disj` exp2
toNNF (Negation (Conditional exp1 exp2))   = toNNF $ exp1 `conj` neg exp2

toNNF (Biconditional exp1 exp2)            = let a = exp1 `conj` exp2
                                                 b = neg exp1 `conj` neg exp2
                                             in toNNF $ a `disj` b
toNNF (Negation (Biconditional exp1 exp2)) = let a = exp1 `disj` exp2
                                                 b = neg exp1 `disj` neg exp2
                                             in toNNF $ a `conj` b

toCNF :: Expr -> Expr
toCNF = toCNF' . toNNF
  where
    toCNF' :: Expr -> Expr
    toCNF' (Conjunction exp1 exp2) = toCNF' exp1 `conj` toCNF' exp2
    toCNF' (Disjunction exp1 exp2) = toCNF' exp1 `dist` toCNF' exp2
    toCNF' expr                    = expr
    
    dist :: Expr -> Expr -> Expr
    dist (Conjunction e11 e12) e2 = (e11 `dist` e2) `conj` (e12 `dist` e2)
    dist e1 (Conjunction e21 e22) = (e1 `dist` e21) `conj` (e1 `dist` e22)
    dist e1 e2                    = e1 `disj` e2

toDNF :: Expr -> Expr
toDNF = toDNF' . toNNF
  where
    toDNF' :: Expr -> Expr
    toDNF' (Conjunction exp1 exp2) = toDNF' exp1 `dist` toDNF' exp2
    toDNF' (Disjunction exp1 exp2) = toDNF' exp1 `disj` toDNF' exp2
    toDNF' expr                    = expr
    
    dist :: Expr -> Expr -> Expr
    dist (Disjunction e11 e12) e2 = (e11 `dist` e2) `disj` (e12 `dist` e2)
    dist e1 (Disjunction e21 e22) = (e1 `dist` e21) `disj` (e1 `dist` e22)
    dist e1 e2                    = e1 `conj` e2

neg :: Expr -> Expr
neg = Negation

disj :: Expr -> Expr -> Expr
disj = Disjunction

conj :: Expr -> Expr -> Expr
conj = Conjunction