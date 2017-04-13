-- https://gist.github.com/amonks/d271f618cf0c52515e0b5b71a5dcf8ca

print([[


HYPER

## install

Use karabiner-elements to bind capslock to F18

install hammerspoon

save this file as ~/.hammerspoon/hyper.lua

add `require 'hyper'` to ~/.hammerspoon/init.lua

## use

press capslock by itself to send escape.

or use it as a modifier:

It acts like command+option+ctrl+shift. All
the modifiers at once.

It's hard to type all the modifiers at once, so
app keyboard shortcuts almost never require you
to.

But it's still allowed in set-your-own-shortcut
fields!

You now have an extra modifier key _and_ an
extra escape key. Go nuts.
]])

-- A variable for the Hyper Mode
local k = hs.hotkey.modal.new({}, 'F17')

-- All of the keys, from here:
-- https://github.com/Hammerspoon/hammerspoon/blob/f3446073f3e58bba0539ff8b2017a65b446954f7/extensions/keycodes/internal.m
-- except with ' instead of " (not sure why but it didn't work otherwise)
-- and the function keys greater than F12 removed.
local keys = {
  "a",
  "b",
  "c",
  "d",
  "e",
  "f",
  "g",
  "h",
  "i",
  "j",
  "k",
  "l",
  "m",
  "n",
  "o",
  "p",
  "q",
  "r",
  "s",
  "t",
  "u",
  "v",
  "w",
  "x",
  "y",
  "z",
  "0",
  "1",
  "2",
  "3",
  "4",
  "5",
  "6",
  "7",
  "8",
  "9",
  "`",
  "=",
  "-",
  "]",
  "[",
  "\'",
  ";",
  "\\",
  ",",
  "/",
  ".",
  -- "§",
  "f1",
  "f2",
  "f3",
  "f4",
  "f5",
  "f6",
  "f7",
  "f8",
  "f9",
  "f10",
  "f11",
  "f12",
  "pad.",
  "pad*",
  "pad+",
  "pad/",
  "pad-",
  "pad=",
  "pad0",
  "pad1",
  "pad2",
  "pad3",
  "pad4",
  "pad5",
  "pad6",
  "pad7",
  "pad8",
  "pad9",
  "padclear",
  "padenter",
  "return",
  "tab",
  "space",
  "delete",
  "help",
  "home",
  "pageup",
  "forwarddelete",
  "end",
  "pagedown",
  "left",
  "right",
  "down",
  "up"
}

local printIsdown = function(b) return b and 'down' or 'up' end

-- sends a key event with all modifiers
-- bool -> string -> void -> side effect
local hyper = function(isdown)
  return function(key)
    return function()
      k.triggered = true
      local event = hs.eventtap.event.newKeyEvent(
	{'cmd', 'alt', 'shift', 'ctrl'},
	key, 
	isdown
      )
      event:post()
    end
  end
end

local hyperDown = hyper(true)
local hyperUp = hyper(false)

-- actually bind a key
local hyperBind = function(key)
  k:bind('', key, msg, hyperDown(key), hyperUp(key), nil)
end

-- bind all the keys in the huge keys table
for index, key in pairs(keys) do hyperBind(key) end

-- Enter Hyper Mode when F18 (Hyper/Capslock) is pressed
local pressedF18 = function()
  k.triggered = false
  k:enter()
end

-- Leave Hyper Mode when F18 (Hyper/Capslock) is pressed,
--   send ESCAPE if no other keys are pressed.
local releasedF18 = function()
  k:exit()
  if not k.triggered then
    hs.eventtap.keyStroke({}, 'ESCAPE')
  end
end

-- Bind the Hyper key
local f18 = hs.hotkey.bind({}, 'F18', pressedF18, releasedF18)

