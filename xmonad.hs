import XMonad
import XMonad.Config.Desktop
import XMonad.Config.Gnome
import XMonad.Hooks.ManageHelpers
import XMonad.Layout.Accordion
import XMonad.Layout.Column
import XMonad.Layout.Tabbed
import XMonad.Layout.Gaps
import XMonad.Layout.Grid
import XMonad.Layout.NoBorders
import XMonad.Prompt
import XMonad.Prompt.AppendFile
import XMonad.Prompt.Man
import XMonad.Prompt.Shell
import XMonad.Util.EZConfig
import XMonad.Layout.SubLayouts
import XMonad.Layout.WindowNavigation
import XMonad.Layout.BoringWindows


myTiled = subTabbed $ windowNavigation $ smartBorders $ boringWindows $ desktopLayoutModifiers $ tiled
  where
    tiled = Tall nmaster delta ratio -- partitions the screen into two panes
    nmaster = 1 -- default number of windows in the master pane
    ratio = 1/2 -- default proportion of screen occupied by master pane
    delta = 3/100 -- percent of screen to increment by when resizing panes

myTabbed = windowNavigation $ smartBorders $ boringWindows $ desktopLayoutModifiers $ simpleTabbed

main = xmonad $ gnomeConfig
    { modMask = mod4Mask -- Windows Key
    , borderWidth = 1
    , layoutHook = myTiled ||| myTabbed
    , manageHook = composeAll $
        [ manageHook gnomeConfig
        , resource =? "Do" --> doIgnore  --gnome do
        , isFullscreen --> doFullFloat  --don't interfere with fullscreen video
        , className =? "Unity-2d-panel" --> doIgnore
        , className =? "Unity-2d-shell" --> doIgnore
        ]
    , terminal = "~/.xmonad/gnome-terminal-wrapper -e ~/.xmonad/tmux-open"
    }
    `additionalKeysP`
    [ ("M-C-h", sendMessage $ pullGroup L)
    , ("M-C-l", sendMessage $ pullGroup R)
    , ("M-C-k", sendMessage $ pullGroup U)
    , ("M-C-j", sendMessage $ pullGroup D)
    , ("M-j", focusDown)
    , ("M-k", focusUp)
    ]
