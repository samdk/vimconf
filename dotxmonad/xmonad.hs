-- default desktop configuration for Fedora

import System.Posix.Env
import Data.Maybe
import System.IO

import XMonad
import XMonad.Config.Desktop
import XMonad.Hooks.EwmhDesktops
import XMonad.Util.EZConfig
import XMonad.Util.Run
import XMonad.Hooks.DynamicLog
import XMonad.Hooks.ManageDocks
import XMonad.Layout.ResizableTile
import XMonad.Layout.NoBorders

-- roughly the same as the default, except slightly better
theLayoutHook =
  avoidStruts
  $ tallLayout
    ||| Mirror tallLayout
    ||| noBorders Full
  where
    tallLayout = ResizableTall 1 (3/100) (1/2) []

theExtraKeys =
  [ ("M-a", sendMessage MirrorShrink)
  , ("M-z", sendMessage MirrorExpand)
  ]

theConfig xmobarPipe =
  defaultConfig
    { modMask            = mod1Mask
    , terminal           = "gnome-terminal"
    , focusFollowsMouse  = False
    , workspaces         = map show $ [1 .. 9] ++ [0]
    , layoutHook         = theLayoutHook
    , manageHook         = manageDocks <+> manageHook defaultConfig
    , borderWidth        = 3
    , normalBorderColor  = "#444444"
    , focusedBorderColor = "#327cf2"
    , handleEventHook    = handleEventHook defaultConfig <+> fullscreenEventHook <+> docksEventHook
    , logHook            = dynamicLogWithPP $ xmobarPP
                            { ppOutput = hPutStrLn xmobarPipe
                            , ppTitle  = xmobarColor "#77bbff" ""
                            , ppOrder  = \(ws:l:t:_) -> [ws, l, t]
                            , ppUrgent = xmobarColor "yellow" "red" . xmobarStrip
                            }
    }
    `removeKeysP` ["M-q"]
    `additionalKeysP` theExtraKeys

run xmobarPipe = xmonad $ ewmh $ theConfig xmobarPipe

main =
  do
    session <- getEnv "DESKTOP_SESSION"
    xmobarPipe <- spawnPipe ("xmobar ~/.xmonad/xmobarrc")
    run xmobarPipe
  
