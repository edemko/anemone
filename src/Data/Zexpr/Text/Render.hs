{-# LANGUAGE GADTs #-}

module Data.Zexpr.Text.Render
  ( crapDisplay -- DEBUG
  ) where

import Prelude hiding (exp)

import Data.Zexpr.Zexpr (Zexpr(..), Atom(..), Combine(..))

import Data.List (intercalate)
import Data.Symbol (unintern)

import qualified Data.Text as T

crapDisplay :: Zexpr -> String
crapDisplay (ZAtom _ (Sym x)) = unintern x
crapDisplay (ZAtom _ (Int n)) = show n
crapDisplay (ZAtom _ (Str s)) = show $ T.unpack s
crapDisplay (ZCombo _ Round es) = concat ["(", intercalate " " (crapDisplay <$> es), ")"]
crapDisplay (ZCombo _ Square es) = concat ["[", intercalate " " (crapDisplay <$> es), "]"]
-- crapDisplay (ZCombo _ Curly es) = concat ["{", intercalate " " (crapDisplay <$> es), "}"]
crapDisplay (ZCombo _ ConsDot (es, e')) = concat ["(", intercalate " " (crapDisplay <$> es), " . ", crapDisplay e', ")"]
crapDisplay (ZCombo _ LensField (e, _, f)) = concat [crapDisplay e, ".", unintern f]
crapDisplay (ZCombo _ LensIndex (e, ix)) = concat [crapDisplay e, "[", crapDisplay ix, "]"]
crapDisplay (ZCombo _ FloatLit (sig, 10, exp)) = concat [show sig, "e", show exp]
crapDisplay (ZCombo _ MakeInt (e, _, n)) = concat [crapDisplay e, ".", show n]
crapDisplay (ZCombo _ MakeFloat (e, _, (sig, 10, exp))) = concat [crapDisplay e, ".", show sig, "e", show exp]
crapDisplay (ZCombo _ MakeStr (e, _, s)) = concat [crapDisplay e, show $ T.unpack s]
crapDisplay (ZCombo _ Dollar ()) = "$"
crapDisplay (ZCombo _ Tick (_, e)) = concat ["'", crapDisplay e]
crapDisplay (ZCombo _ Backtick (_, e)) = concat ["`", crapDisplay e]
crapDisplay (ZCombo _ Comma (_, e)) = concat [",", crapDisplay e]
crapDisplay (ZCombo _ CommaAt (_, e)) = concat [",@", crapDisplay e]
crapDisplay (ZCombo _ QualName xs) = intercalate ":" (unintern . snd <$> xs)
