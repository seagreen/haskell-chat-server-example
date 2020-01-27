module Main where

import Control.Concurrent (forkFinally)
import Control.Monad      (forever)
import Network.Socket     (socketToHandle)
import Network.Simple.TCP (HostPreference(Host), serve)
import System.IO          (IOMode(ReadWriteMode), hClose)
import Text.Printf        (printf)

import Server             (handleClient, newServer)

main :: IO ()
main = do
    server <- newServer
    _ <- printf "Listening on port %d\n" port
    serve (Host "127.0.0.1") (show port) $ \(connectionSocket, remoteAddr) -> do
        _ <- printf "Accepted connection from %s\n" (show remoteAddr)
        handle <- socketToHandle connectionSocket ReadWriteMode
        handleClient handle server
        pure ()

port :: Int
port = 44444

-- The `network` became more low-level over time, so this has changed
-- from the previous code and now uses `network-simple` as well.
-- The original code is below:
--
--
-- main :: IO ()
-- main = withSocketsDo $ do
--     server <- newServer
--     sock <- listenOn (PortNumber (fromIntegral port))
--     _ <- printf "Listening on port %d\n" port
--
--     forever $ do
--         (handle, host, port') <- accept sock
--         _ <- printf "Accepted connection from %s: %s\n" host (show port')
--         forkFinally (handleClient handle server) (\_ -> hClose handle)
