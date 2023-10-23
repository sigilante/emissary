/-  *emissary, hark
/+  default-agent, dbug, *emissary, rudder
::
/~  pages  (page:rudder [(set ship) (map ship status) (set ship)] trigger)  /app/emissary/webui
::/~  delegate-pages  (page:rudder [(set ship) (map ship status) (set ship)] trigger)  /app/emissary/webui/delegate
::
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
++  on-arvo
  |=  [=wire =sign-arvo]
  ^-  (quip card _this)
  =^  cards  state  abet:(arvo:eng wire sign-arvo) 
  [cards this]
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
++  connect
  ^-  (list card)
  :~  [%pass /eyre/connect %arvo %e %connect [~ /apps/[dap.bol]] dap.bol]
      [%pass /eyre/connect %arvo %e %connect [~ /apps/[dap.bol]/patron] dap.bol]
      [%pass /eyre/connect %arvo %e %connect [~ /apps/[dap.bol]/delegate] dap.bol]
  ==
::
++  init
  ^+  that
  (emil connect)
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
  ~&  >  pol
  ?+    pol  ~|(%invalid-scry-path !!)
    [%y %delegates ~]        ``noun+!>(`(set ship)`(silt `(list ship)`(turn (skim ~(tap by delegates) |=([=ship =status] =(%valid status))) head)))
    [%y %patrons ~]          ``noun+!>(patrons)
    [%y %requests ~]         ``noun+!>(requests)
    [%x %delegate ship=@ ~]  ``noun+!>((~(has by delegates) `@p`(need (slaw %p ship:pol))))
    [%x %patron ship=@ ~]    ~&  `@p`(need (slaw %p ship:pol))  ``noun+!>((~(has in patrons) `@p`(need (slaw %p ship:pol))))
  ==
::
++  watch
  |=  pol=(pole knot)
  ^+  that
  ?+    pol  ~|(%invalid-watch-path !!)
  ::
      [%http-response *]
    that
  ::  /request does nothing until the point has made a decision
      [%request ~]
    =^  cards  state
      de-abet:(de-watch:(de-abed:de patrons requests))
    (emil cards)
  ==
::
++  agent
  |=  [wire=(pole knot) =sign:agent:gall]
  ^+  that
  ?+    wire  ~&([dap.bol %strange-wire wire] that)
      [%emissary id=@ ~]
    =/  ship  (need (slaw %p id.wire))
    ?-    -.sign
        %kick
      that
      ::
        %fact
      ?>  ?=(%emissary-response p.cage.sign)
      ~&  >  [p.cage.sign our.bol src.bol]
      =/  ans  !<(response q.cage.sign)
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
    ::
      [%hark ~]
    ?.  ?=(%poke-ack -.sign)  ~&([dap.bol %strange-sign sign] that)
    ?~  p.sign  that
    ((slog '%emissary: failed to notify' u.p.sign) that)
  ==  ::  wire
::
++  arvo
  |=  [wire=(pole knot) =sign-arvo]
  ^+  that
  ~&  >  wire
  ?+  sign-arvo  ~|(%bad-arvo-wire !!)
    [%eyre %bound *]  that
  ==
::
++  poke
  |=  [=mark =vase]
  ^+  that
  ?+    mark  ~|(%invalid-poke !!)
      %emissary-trigger
    =^  cards  state
    =/  tri  !<(trigger vase)
    ?-    -.tri
        ?(%designate %revoke)
      ?:  =(our.bol src.bol)
        pa-abet:(pa-poke:(pa-abed:pa delegates) tri)
      de-abet:(de-poke:(de-abed:de patrons requests) tri)
        ?(%accept %reject)
      de-abet:(de-poke:(de-abed:de patrons requests) tri)
    ==
    (emil cards)
    ::
      %emissary-response
    =^  cards  state
    =/  res  !<(response vase)
    de-abet:(de-poke:(de-abed:de patrons requests) res)
    (emil cards)
    ::
      %handle-http-request
    =;  out=(quip card _+.state)
      =.  +.state  +.out
      :: flop here so that the kick from rudder isn't first
      (emil (flop -.out))
    %.  [bol !<(order:rudder vase) +.state]
    %-  (steer:rudder _+.state trigger)
    :^    pages
        (point:rudder /apps/[dap.bol] & ~(key by pages))
      (fours:rudder +.state)
    |=  tri=trigger
    ^-  $@(brief:rudder [brief:rudder (list card) _+.state])
    =.  that  (poke %emissary-trigger !>(tri))
    [%'' deck +.state]
  ==  ::  mark
::  patrons core
++  pa
  |_  $:  patrons=(set ship)
          delegates=(map ship status)
          requests=(set ship)
          caz=(list card)
      ==
  +*  pa  .
  ++  pa-emit  |=(c=card pa(caz [c caz]))
  ++  pa-emil  |=(lc=(list card) pa(caz (welp lc caz)))
  ++  pa-abed
    |=  [=(map ship status)]
    pa(delegates map)
  ++  pa-abet
    ^-  (quip card _state)
    [(flop caz) state(delegates delegates)]
  ++  pa-poke
    |=  tri=trigger
    ^+  pa
    ~&  >>  tri
    ?+    -.tri  pa
        %designate
      ::?>  ~|(%cannot-designate-superior (is-supra our.bol ship.tri))
      ?:  (~(has by delegates) ship.tri)
        =/  status  (~(got by delegates) ship.tri)
        ::  if valid, then don't do anything
        ?:  =(%valid status)  pa
        ::  if rejected, then send again
        ?:  =(%rejected status)
          :: build cards
          =.  delegates  (~(put by delegates) ship.tri %pending)
          =/  new-cards
            :~  [%pass /emissary/(scot %p ship.tri) %agent [ship.tri %emissary] %poke %emissary-trigger !>([%designate our.bol])]
                [%pass /emissary/(scot %p ship.tri) %agent [ship.tri %emissary] %watch /request]
            ==
          (pa-emil new-cards)
        ::  if still pending, then don't do anything
        ?>  =(%pending status)  pa
      ::  if not yet present, then send
      =.  delegates  (~(put by delegates) ship.tri %pending)
      =/  new-cards
        :~  [%pass /emissary/(scot %p ship.tri) %agent [ship.tri %emissary] %poke %emissary-trigger !>([%designate our.bol])]
            [%pass /emissary/(scot %p ship.tri) %agent [ship.tri %emissary] %watch /request]
        ==
      (pa-emil new-cards)
    ::
        %revoke
      ?.  (~(has by delegates) ship.tri)  pa
      =.  delegates  (~(del by delegates) ship.tri)
      =/  new-cards
        :~  [%pass /emissary/(scot %p ship.tri) %agent [ship.tri %emissary] %poke %emissary-trigger !>([%revoke our.bol])]
            [%pass /emissary/(scot %p ship.tri) %agent [ship.tri %emissary] %leave ~]
        ==
      (pa-emil new-cards)
    ::
    ==  ::  %emissary-response
  --  ::  patrons core
::
::  delegates core
++  de
  |_  $:  patrons=(set ship)
          delegates=(map ship status)
          requests=(set ship)
          caz=(list card)
      ==
  +*  de  .
  ++  de-emit  |=(c=card de(caz [c caz]))
  ++  de-emil  |=(lc=(list card) de(caz (welp lc caz)))
  ++  de-abed
    |=  [p=(set ship) r=(set ship)]
    de(patrons p, requests r)
  ++  de-abet
    ^-  (quip card _state)
    [(flop caz) state(patrons patrons, requests requests)]
  ++  de-watch
    |.
    ^+  de
    ?:  (~(has in patrons) src.bol)
      %-  de-emil
      :~  [%give %fact ~ %emissary-response !>([%accept ~])]
      ==
    de
  ++  de-poke
    |=  tri=trigger
    ^+  de
    ~&  >  tri
    ?-    -.tri
        %designate
      ?:  (~(has in patrons) src.bol)
        =/  new-cards
          :~  [%give %fact ~[/request] %emissary-response !>([%accept ~])]
          ==
        (de-emil new-cards)
      =.  requests  (~(put in requests) src.bol)
      ~&  >>>  requests
      =/  new-cards
        ?.  .^(? %gu /(scot %p our.bol)/hark/(scot %da now.bol)/$)  ~
        =/  con=(list content:hark)  [[%ship src.bol] 'Designation request received.' ~]
        =/  =id:hark      (end 7 (shas %emissary-trigger eny.bol))
        =/  =rope:hark    [~ ~ q.byk.bol /(scot %p src.bol)/[dap.bol]]
        =/  =action:hark  [%add-yarn & & id rope now.bol con /[dap.bol] ~]
        :~  [%pass /hark %agent [our.bol %hark] %poke %hark-action !>(action)]
        ==
      (de-emil new-cards)
    ::
        %revoke
      ?.  (~(has in patrons) ship.tri)  de
      =.  patrons  (~(del in patrons) ship.tri)
      de
    ::
        %accept
      =.  patrons  (~(put in patrons) ship.tri)
      =?  requests  (~(has in requests) ship.tri)  (~(del in requests) ship.tri)
      =/  new-cards=(list card)
        :~  [%give %fact ~[/request] %emissary-response !>([%accept ~])]
            [%give %kick ~[/request] `src.bol]
        ==
      (de-emil (flop new-cards))
      ::
        %reject
      =?  patrons  (~(has in patrons) ship.tri)  (~(del in patrons) ship.tri)
      =?  requests  (~(has in requests) ship.tri)  (~(del in requests) ship.tri)
      =/  new-cards=(list card)
        :~  [%give %fact ~[/request] %emissary-response !>([%reject ~])]
            [%give %kick ~[/request] `ship.tri]
        ==
      (de-emil (flop new-cards))
    ==  ::  %emissary-response
  --  ::  delegates core
--
