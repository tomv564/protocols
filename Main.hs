module Main where

import Network
import System.IO
import System.IO.Error
-- import Data.DateTime
import Control.Concurrent

main :: IO ()
main = withSocketsDo $ do
    sock <- listenOn $ PortNumber 4000
    putStrLn "Listening on port 4000..."
    listenLoop sock

listenLoop :: Socket -> IO ()
listenLoop sock = do
    (handle, _, _) <- accept sock
    hSetBuffering handle NoBuffering
    forkIO $ sendMOTD handle
    listenLoop sock

sendMOTD :: Handle -> IO ()
sendMOTD handle = hPutStrLn handle "yo yo yo - Edward Scissorhands"

-- sendDateTime :: Handle -> IO ()
-- sendDateTime handle = do
--     time <- getCurrentTime
--     hPutStrLn handle $ formatDateTime "%c" time

echoLoop :: Handle -> IO ()
echoLoop handle = do
    input <- tryIOError (hGetLine handle)
    case input of
         Left e ->
             if isEOFError e
                then return ()
                else ioError e
         Right text -> do
            hPutStrLn handle text
            echoLoop handle
