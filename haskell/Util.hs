module Util where

import System.IO
import System.Console.ANSI
import System.Process(callCommand)
import Control.Concurrent (threadDelay)
import System.IO.Unsafe (unsafePerformIO)

limpaTela :: IO()
limpaTela = callCommand "clear"

delay :: IO ()
delay = threadDelay (1 * 1000000) -- 1.0 segundo

leCaractere :: IO Char
leCaractere = do
    hSetBuffering stdin NoBuffering
    hSetEcho stdin False
    char <- getChar
    hSetEcho stdin True
    hSetBuffering stdin LineBuffering
    return char