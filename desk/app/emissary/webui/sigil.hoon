::  pals mutual icon, ripped off gleefully for %emissary
::
/-  *emissary
/+  rudder, sigil
::
^-  (page:rudder [(set ship) (map ship status) (set ship) queries] ?(trigger decide query))
|_  [=bowl:gall * *]
++  argue  !!
++  final  !!
++  build
  |=  [arg=(list [k=@t v=@t]) *]
  ^-  reply:rudder
  :+  %xtra
    :~  ['content-type' 'image/svg+xml']
        ['cache-control' 'public, max-age=2592000, immutable']
    ==
  =/  args  (~(gas by *(map @t @t)) arg)
  %.  (slav %p (~(got by args) 'p'))
  %_  sigil
    size    (slav %ud (~(gut by args) 'size' '100'))
    fg      (trip (~(gut by args) 'fg' 'black'))
    bg      (trip (~(gut by args) 'bg' 'white'))
    margin  !(~(has by args) 'no-margin')
    icon    (~(has by args) 'icon')
  ==
--
