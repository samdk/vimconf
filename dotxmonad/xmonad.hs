import XMonad
import XMonad.Hooks.DynamicLog
import XMonad.Hooks.EwmhDesktops
import XMonad.Hooks.ManageDocks
import XMonad.Hooks.ManageHelpers
import XMonad.Layout.NoBorders
import XMonad.Layout.ResizableTile
import XMonad.Util.EZConfig
import XMonad.Util.Run

theLayoutHook =
  -- avoid docks
  avoidStruts
  -- don't draw borders if there's only one thing visible
  $ smartBorders
  -- layouts are almost exactly the same as standard, except ResizableTall
  -- replaces Tall, giving the ability to resize individual panes
  $ tallLayout
    ||| Mirror tallLayout
    ||| Full
  where
    tallLayout = ResizableTall 1 (3/100) (1/2) []

theExtraKeys =
  -- resize individual windows in ResizableTall layout
  [ ("M-a", sendMessage MirrorShrink)
  , ("M-z", sendMessage MirrorExpand)
  ]

theManageHook =
  -- avoid xmobar
  manageDocks
  -- don't show borders if an application is displaying fullscreen
  <+> (isFullscreen --> doFullFloat)
  -- defaults
  <+> manageHook defaultConfig

theEventHook =
  -- layouts get information about fullscreen windows
  fullscreenEventHook
  -- refresh layouts to avoid docks
  <+> docksEventHook
  -- defaults
  <+> handleEventHook defaultConfig

theLogHook xmobarPipe =
  dynamicLogWithPP
  $ xmobarPP
    { ppOutput = hPutStrLn xmobarPipe
    , ppTitle  = xmobarColor "#dbdbdb" ""
    , ppUrgent = xmobarColor "yellow"  ""
    }

theConfig xmobarPipe =
  defaultConfig
    { modMask            = mod1Mask -- Alt
    , terminal           = "gnome-terminal"
    , focusFollowsMouse  = False
    , workspaces         = map show $ [1 .. 9] ++ [0]
    , layoutHook         = theLayoutHook
    , manageHook         = theManageHook
    , borderWidth        = 3
    , normalBorderColor  = "#444444"
    , focusedBorderColor = "#327cf2"
    , handleEventHook    = theEventHook
    , logHook            = theLogHook xmobarPipe
    }
    `removeKeysP` ["M-q"]
    `additionalKeysP` theExtraKeys

run xmobarPipe = xmonad $ ewmh $ theConfig xmobarPipe

setSolidBackground = safeSpawn "xsetroot" ["-solid", "black"]

main =
  do
    () <- setSolidBackground
    xmobarPipe <- spawnPipe ("xmobar ~/.xmonad/xmobarrc")
    run xmobarPipe
  
