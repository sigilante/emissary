/-  *emissary
/+  default-agent, dbug, *emissary
|%
+$  versioned-state
  $%  state-zero
  ==
+$  state-zero
  $:  [%zero patrons=(set ship) delegates=(map ship status) requests=(set ship)]
  ==
+$  card  card:agent:gall
--
%-  agent:dbug
=|  state-zero
=*  state  -
^-  agent:gall
=<
|_  =bowl:gall
+*  this     .
    default  ~(. (default-agent this %|) bowl)
    eng      ~(. +> [bowl ~])
++  on-init
  =^  cards  state
    abet:init:eng
  [cards this]
++  on-save   !>(state)
++  on-load
  |=  =old=vase
  ^-  (quip card _this)
  =^  cards  state
    abet:(load:eng old-vase)
  [cards this]
++  on-poke
  |=  [=mark =vase]
  ^-  (quip card _this)
  =^  cards  state  abet:(poke:eng mark vase)
  [cards this]
::
++  on-peek
  |=  =path
  ^-  (unit (unit cage))
  (peek:eng path)
++  on-arvo   on-arvo:default
++  on-watch
  |=  =path
  ^-  (quip card _this)
  =^  cards  state  abet:(watch:eng path)
  [cards this]
++  on-leave  on-leave:default
++  on-agent
  |=  [=wire =sign:agent:gall]
  ^-  (quip card _this)
  =^  cards  state  abet:(agent:eng wire sign)
  [cards this]
++  on-fail   on-fail:default
--
::
|_  [bol=bowl:gall deck=(list card)]
+*  that  .
++  emit  |=(=card that(deck [card deck]))
++  emil  |=(lack=(list card) that(deck (welp lack deck)))
++  abet
  ^-  (quip card _state)
  [(flop deck) state]
::
++  init
  ^+  that
  that
::
++  load
  |=  vaz=vase
  ^+  that
  ?>  ?=([%zero *] q.vaz)
  that(state !<(state-zero vaz))
::
++  peek
  |=  pol=(pole knot)
  ^-  (unit (unit cage))
  ?+    pol  ~|(%invalid-scry-path !!)
    [%y %delegates ~]        ``emissary-demand+!>([%delegates `(set ship)`(silt `(list ship)`(turn (skim ~(tap by delegates) |=([=ship =status] =(%valid status))) head))])
    [%y %patrons ~]          ``emissary-demand+!>([%patrons patrons])
    [%x %delegate ship=@ ~]  ``emissary-demand+!>([%delegate (~(has by delegates) ship:pol)])
    [%x %patron ship=@ ~]    ``emissary-demand+!>([%patron (~(has in patrons) ship:pol)])
  ==
::
++  watch
  |=  pol=(pole knot)
  ^+  that
  ?+    pol  ~|(%invalid-watch-path !!)
  ::  /request does nothing until the point has made a decision
      [%request ~]
    =^  cards  state
      pa-abet:(pa-watch:(pa-abed:pa patrons requests))
    (emil cards)
  ==
::
++  agent
  |=  [wire=(pole knot) =sign:agent:gall]
  ^+  that
  ?+    wire  ~|(%unknown-wire !!)
      [%des id=@ ~]
    =/  ship  (need (slaw %p id.wire))
    ?-    -.sign
        %kick
      that
      ::
        %fact
      ?>  ?=(%emissary-answer p.cage.sign)
      =/  ans  !<(answer q.cage.sign)
      ?:  =(%accept -.ans)
        that(delegates (~(put by delegates) ship %valid))
      ?>  =(%reject -.ans)
      that(delegates (~(put by delegates) ship %rejected))
      ::
        %poke-ack
      ?~  p.sign
        that
      %-  (slog leaf+"poke failed from {<dap.bol>} on wire {<wire>}" u.p.sign)
      that
      ::
        %watch-ack
      ?~  p.sign
        that
      =/  =tank  leaf+"subscribe failed from {<dap.bol>} on wire {<wire>}"
      %-  (slog tank u.p.sign)
      that
    ==  ::  sign
  ==  ::  wire
::
++  poke
  |=  [=mark =vase]
  ^+  that
  =^  cards  state
   ?+    mark  ~|(%invalid-poke !!)
        %emissary-trigger
      =/  tri  !<(trigger vase)
      de-abet:(de-poke-trigger:(de-abed:de delegates) tri)
      ::
        %emissary-action
      =/  axn  !<(action vase)
      pa-abet:(pa-poke-action:(pa-abed:pa patrons requests) axn)
      ::
        %emissary-response
      =/  res  !<(response vase)
      pa-abet:(pa-poke-response:(pa-abed:pa patrons requests) res)
    ==  ::  mark
  (emil cards)
::  delegates core
++  de
  |_  $:  delegates=(map ship status)
          caz=(list card)
      ==
  +*  de  .
  ++  de-emit  |=(c=card de(caz [c caz]))
  ++  de-emil  |=(lc=(list card) de(caz (welp lc caz)))
  ++  de-abed
    |=  [=(map ship status)]
    de(delegates map)
  ++  de-abet
    ^-  (quip card _state)
    [(flop caz) state(delegates delegates)]
  ++  de-poke-trigger
    |=  tri=trigger
    ^+  de
    ?-    -.tri
        %designate
      ?>  (is-supra our.bol ship.tri)
      ?:  (~(has by delegates) ship.tri)
        =/  status  (~(got by delegates) ship.tri)
        ::  if valid, then don't do anything
        ?:  =(%valid status)  de
        ::  if rejected, then send again
        ?:  =(%rejected status)
          :: build cards
          =.  delegates  (~(put by delegates) ship.tri %pending)
          =/  new-cards
            :~  [%pass /des/(scot %p ship.tri) %agent [ship.tri %emissary] %poke %emissary-action !>([%designate ~])]
                [%pass /des/(scot %p ship.tri) %agent [ship.tri %emissary] %watch /request]
            ==
          (de-emil new-cards)
        ?>  =(%pending status)  de
      =.  delegates  (~(put by delegates) ship.tri %pending)
      =/  new-cards
        :~  [%pass /des/(scot %p ship.tri) %agent [ship.tri %emissary] %poke %emissary-action !>([%designate ~])]
            [%pass /des/(scot %p ship.tri) %agent [ship.tri %emissary] %watch /request]
        ==
      (de-emil new-cards)
    ::
        %revoke
      ?.  (~(has by delegates) ship.tri)  de
      =.  delegates  (~(del by delegates) ship.tri)
      =/  new-cards
        :~  [%pass /des/(scot %p ship.tri) %agent [ship.tri %emissary] %poke %emissary-action !>([%revoke our.bol])]
            [%pass /des/(scot %p ship.tri) %agent [ship.tri %emissary] %leave ~]
        ==
      (de-emil new-cards)
    ::
    ==  ::  %emissary-action
  --  ::  delegates core
::
::  patrons core
++  pa
  |_  $:  patrons=(set ship)
          requests=(set ship)
          caz=(list card)
      ==
  +*  pa  .
  ++  pa-emit  |=(c=card pa(caz [c caz]))
  ++  pa-emil  |=(lc=(list card) pa(caz (welp lc caz)))
  ++  pa-abed
    |=  [p=(set ship) r=(set ship)]
    pa(patrons p, requests r)
  ++  pa-abet
    ^-  (quip card _state)
    [(flop caz) state]
  ++  pa-watch
    |.
    ^+  pa
    ?:  (~(has in patrons) src.bol)
      %-  pa-emil
      :~  [%give %fact ~ %emissary-answer !>([%accept ~])]
      ==
    pa
  ++  pa-poke-action
    |=  axn=action
    ^+  pa
    ?-    -.axn
        %designate
      ?:  (~(has in patrons) src.bol)
        =/  new-cards
          :~  [%give %fact ~[/des/(scot %p our.bol)] %emissary-answer !>([%accept ~])]
          ==
        (pa-emil new-cards)
      =.  requests  (~(put in requests) src.bol)
      pa
    ::
        %revoke
      ?.  (~(has in patrons) src.bol)  (pa-emil ~)
      =.  patrons  (~(del in patrons) src.bol)
      pa
    ::
    ==  ::  %emissary-action
  ++  pa-poke-response
    |=  res=response
    ^+  pa
    ?-    -.res
        %accept
      =.  patrons  (~(put in patrons) ship.res)
      =.  requests  (~(del in requests) ship.res)
      =/  new-cards
        :~  [%give %fact ~[/des/(scot %p our.bol)] %emissary-answer !>([%accept ~])]
            [%give %kick ~[/des/(scot %p our.bol)] `src.bol]
        ==
      (pa-emil new-cards)
      ::
        %reject
      =.  requests  (~(del in requests) ship.res)
      =/  new-cards
        :~  [%give %fact ~[/des/(scot %p our.bol)] %emissary-answer !>([%reject ~])]
            [%give %kick ~[/des/(scot %p our.bol)] `src.bol]
        ==
      (pa-emil new-cards)
    ==  ::  %emissary-response
  --  ::  patrons core
--
