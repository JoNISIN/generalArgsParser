module ArgParse (
    setParser
    , setDefaultFromList
    , setDefault
    , parseArgsList
    , parsedSeq
    , parsedKey
    , parsedArgOf
    , isTrigger
) where

import System.Environment (getArgs)
import qualified Data.Map as M

data ArgParsed = ArgParsed (M.Map String Int) (M.Map String (Maybe [String])) [String]

setParser :: [(String, Int)] -> ArgParsed
setParser configl = ArgParsed m (M.map (const Nothing) m) []
    where m = M.fromList configl

setDefaultFromList (ArgParsed conf def lst) l = ArgParsed conf def' lst
    where def' = foldr (\(k,a) m -> M.adjust (const a) k m) def l

setDefault (ArgParsed conf def lst) (k,a) = ArgParsed conf def' lst
    where def' = M.adjust (const a) k def

parseList' (ArgParsed conf def lst) [] = ArgParsed conf def $ reverse lst
parseList' (ArgParsed conf def lst) (x:xs)
    | x `M.member` conf = let argc = conf M.! x
        in parseList' (ArgParsed conf (M.adjust (const $ Just (take argc xs)) x def) lst) $ drop argc xs
    | otherwise = parseList' (ArgParsed conf def (x:lst)) xs
parseArgsList x l = parseList' x l

parsedSeq (ArgParsed _ _ lst) = lst
parsedKey (ArgParsed _ def _) k = 
    case M.lookup k def of
        Nothing -> Nothing
        Just x  -> x
parsedArgOf arg k = 
    case fmap head $ parsedKey arg k of
        (Just x) -> x
        Nothing  -> ""
isTrigger arg k = 
    case parsedKey arg k of
        Nothing -> False
        Just x  -> True

main = do
    putStrLn "Auto Test"
    args <- getArgs
    let parser  = setParser [("-v",0),("--echo",1)]
    let parser1 = setDefaultFromList parser [("-v",Nothing),("--echo",Just ["Hello, workd!"])]
    let parsed = parseArgsList parser1 args
    print $ parsedSeq parsed
    print $ isTrigger parsed "-v"
    print $ parsedArgOf parsed "hi"
    print $ parsedArgOf parsed "--echo"