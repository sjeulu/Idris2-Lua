module LuaCommon


import Core.Core

import Data.Strings
import Data.String.Extra as StrExtra
import Data.Vect
import Utils.Hex


namespace Data.List
  export
  unzip : (xs : List (a, b)) -> (List a, List b)
  unzip ((l, r) :: xs) = 
    let (ls, rs) = unzip xs in
        (l :: ls, r :: rs)
  unzip [] = ([], [])      


public export
validateIdentifier : String -> String
validateIdentifier str = concat $ validate <$> unpack str
  where
    validate : Char -> String
    validate ':' = "col"
    validate ';' = "semicol"
    validate ',' = "comma"
    validate '+' = "plus"
    validate '-' = "minus"
    validate '*' = "mult"
    validate '\\' = "bslash"
    validate '/' = "fslash"
    validate '=' = "eq"
    validate '.' = "dot"
    validate '?' = "what"
    validate '|' = "pipe"
    validate '&' = "and"
    validate '>' = "gt"
    validate '<' = "lt"
    validate '!' = "exclam"
    validate '@' = "at"
    validate '$' = "dollar"
    validate '%' = "percent"
    validate '^' = "arrow"
    validate '~' = "tilde"
    validate '#' = "hash"
    validate ' ' = "_"
    validate '(' = "lpar"
    validate ')' = "rpar"
    validate '[' = "lbrack"
    validate ']' = "rbrack"
    validate '{' = "lbrace"
    validate '}' = "rbrace"
    validate '\'' = "prime"
    validate '"' = "quote"
    validate s = cast s




public export
indent : Nat -> String
indent n = StrExtra.replicate (2 * n) ' '

public export
sepBy : List String -> String -> String
sepBy [] _ = ""
sepBy (x :: []) _ = x
sepBy (x :: xs) sep = x ++ sep ++ sepBy xs sep


public export
sepBy' : Vect n String -> String -> String
sepBy' [] _ = ""
sepBy' (x :: []) _ = x
sepBy' (x :: xs) sep = x ++ sep ++ sepBy' xs sep


public export
escapeString : String -> String
escapeString s = concatMap okchar (unpack s)
  where
    okchar : Char -> String
    okchar c = if (c >= ' ') && (c /= '\\') && (c /= '"') && (c /= '\'') && (c <= '~')
                  then cast c
                  else case c of
                            '\0' => "\\0"
                            '\'' => "\\'"
                            '"' => "\\\""
                            '\r' => "\\r"
                            '\n' => "\\n"
                            other => "\\u{" ++ asHex (cast {to=Int} c) ++ "}"

export
lift : Maybe (Core a) -> Core (Maybe a)
lift Nothing = pure Nothing
lift (Just x) = x >>= pure . Just
