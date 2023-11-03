/-  *emissary, hark
/+  default-agent, dbug, *emissary, rudder
::
/~  pages
    (page:rudder [(set ship) (map ship status) (set ship)] [?(trigger decide)])
    /app/emissary/webui
::
|%
+$  versioned-state
  $%  state-zero
      ::state-one
  ==
+$  state-zero
  $:  %zero
      patrons=(set ship)
      delegates=(map ship status)
      requests=(set ship)
  ==
::
::  $:  %one
::      patron=(set ship)
::      delegates=(map ship status)
::      requests=(set ship)
::      queries=(set ship)
::  ==
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
  ?+    pol  ~|(%invalid-scry-path !!)
    [%y %delegates ~]        ``emissary-demand+!>(`(set ship)`(silt `(list ship)`(turn (skim ~(tap by delegates) |=([=ship =status] =(%valid status))) head)))
    [%y %patrons ~]          ``emissary-demand+!>(patrons)
    [%y %outgoing ~]         ``emissary-demand+!>(`(set ship)`(silt `(list ship)`(turn (skim ~(tap by delegates) |=([=ship =status] =(%pending status))) head)))
    [%y %incoming ~]         ``emissary-demand+!>(requests)
    [%x %delegate ship=@ ~]  ``emissary-demand+!>((~(has by delegates) `@p`(need (slaw %p ship:pol))))
    [%x %patron ship=@ ~]    ``emissary-demand+!>((~(has in patrons) `@p`(need (slaw %p ship:pol))))
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
  ?+    wire  ~|([dap.bol %strange-wire wire] that)
      [%emissary id=@ ~]
    =/  ship  (need (slaw %p id.wire))
    ?-    -.sign
        %kick
      that
      ::
        %fact
      ?+    p.cage.sign  ~|(%invalid-fact that)
          %emissary-response
        =/  res  !<(response q.cage.sign)
        ?:  =(%accept res)
          =^  cards  state
            pa-abet:(pa-agent-response:(pa-abed:pa delegates) res src.bol)
          (emil cards)
        ?>  =(%reject res)
        =^  cards  state
          pa-abet:(pa-agent-response:(pa-abed:pa delegates) res src.bol)
        (emil cards)
        ::
          %tune
        ~&  >>  q.cage.sign
        :: pa-abet:(pa-agent-tune:(pa-abed:pa delegates) res src.bol)
        that
      ==  ::  fact
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
    ?.  ?=(%poke-ack -.sign)  ~|([dap.bol %strange-sign sign] that)
    ?~  p.sign  that
    ((slog '%emissary: failed to notify' u.p.sign) that)
  ==  ::  wire
::
++  arvo
  |=  [wire=(pole knot) =sign-arvo]
  ^+  that
  ?+  sign-arvo  ~|(%bad-arvo-wire that)
    [%eyre %bound *]  that
  ==
::
++  poke
  |=  [=mark =vase]
  ^+  that
  ?+    mark  ~|(%invalid-poke that)
      %emissary-trigger
    ::  from UI
    =^  cards  state
      =/  tri  !<(trigger vase)
      ?>  =(our.bol src.bol)
      pa-abet:(pa-poke-trigger:(pa-abed:pa delegates) tri)
    (emil cards)
    ::
      %emissary-request
    ::  over the wire
    =^  cards  state
      =/  req  !<(request vase)
      ?>  !=(our.bol src.bol)
      de-abet:(de-poke-request:(de-abed:de patrons requests) req src.bol)
    (emil cards)
    ::
      %emissary-decide
    ::  from UI
    =^  cards  state
      =/  dec  !<(decide vase)
      ?>  =(our.bol src.bol)
      de-abet:(de-poke-decide:(de-abed:de patrons requests) dec)
    (emil cards)
    ::  XXX TODO REMOVEME
    ::  %emissary-response
    ::::  over the wire
    ::=^  cards  state
    ::  =/  res  !<(response vase)
    ::  ?>  !=(our.bol src.bol)
    ::  pa-abet:(pa-poke-response:(pa-abed:pa delegates) res src.bol)
    ::(emil cards)
    ::
      %handle-http-request
    =;  out=(quip card _+.state)
      =.  +.state  +.out
      :: flop here so that the kick from rudder isn't first
      (emil (flop -.out))
    %.  [bol !<(order:rudder vase) +.state]
    ::  XXX the following is pretty nasty to satisfy /lib/rudder restrictions
    %-  (steer:rudder _+.state ?(trigger decide))
    :^    pages
        (point:rudder /apps/[dap.bol] & ~(key by pages))
      (fours:rudder +.state)
    |=  val=?(trigger decide)
    ^-  $@(brief:rudder [brief:rudder (list card) _+.state])
    ?-    -.val
        %designate
      =.  that  (poke %emissary-trigger !>(`trigger`[%designate +.val]))
      [%'' deck +.state]
        %revoke
      =.  that  (poke %emissary-trigger !>(`trigger`[%revoke +.val]))
      [%'' deck +.state]
        %accept
      =.  that  (poke %emissary-decide !>(`decide`[%accept +.val]))
      [%'' deck +.state]
        %reject
      =.  that  (poke %emissary-decide !>(`decide`[%reject +.val]))
      [%'' deck +.state]
    ==
  ==  ::  mark
::  patrons core
++  pa
  |_  $:  patrons=(set ship)
          delegates=(map ship status)
          requests=(set ship)
          deck=(list card)
      ==
  +*  pa  .
  ++  pa-emit  |=(c=card pa(deck [c deck]))
  ++  pa-emil  |=(lc=(list card) pa(deck (welp lc deck)))
  ++  pa-abed
    |=  [=(map ship status)]
    pa(delegates map)
  ++  pa-abet
    ^-  (quip card _state)
    [(flop deck) state(delegates delegates)]
  ++  pa-poke-trigger
    |=  tri=trigger
    ^+  pa
    ?-    -.tri
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
            :~  [%pass /emissary/(scot %p ship.tri) %agent [ship.tri %emissary] %poke %emissary-request !>(%designate)]
                [%pass /emissary/(scot %p ship.tri) %agent [ship.tri %emissary] %watch /request]
                [%pass /emissary/fine %grow /outgoing noun+`(set ship)`(silt `(list ship)`(turn (skim ~(tap by delegates) |=([=ship =^status] =(%pending status))) head))]
            ==
          (pa-emil new-cards)
        ::  if still pending, then don't do anything
        ?>  =(%pending status)  pa
      ::  if not yet present, then send
      =.  delegates  (~(put by delegates) ship.tri %pending)
      =/  new-cards
        :~  [%pass /emissary/(scot %p ship.tri) %agent [ship.tri %emissary] %poke %emissary-request !>(%designate)]
            [%pass /emissary/(scot %p ship.tri) %agent [ship.tri %emissary] %watch /request]
            [%pass /emissary/fine %grow /outgoing noun+`(set ship)`(silt `(list ship)`(turn (skim ~(tap by delegates) |=([=ship =status] =(%pending status))) head))]
        ==
      (pa-emil new-cards)
    ::
        %revoke
      ?.  (~(has by delegates) ship.tri)  pa
      =.  delegates  (~(del by delegates) ship.tri)
      =/  new-cards
        :~  [%pass /emissary/(scot %p ship.tri) %agent [ship.tri %emissary] %poke %emissary-request !>(%revoke)]
            [%pass /emissary/(scot %p ship.tri) %agent [ship.tri %emissary] %leave ~]
        ==
      (pa-emil new-cards)
    ::
    ==  ::  %emissary-trigger
  ++  pa-agent-response
    |=  [res=response =ship]
    ?-    res
        %accept
      =.  delegates  (~(put by delegates) ship %valid)
      =/  new-cards
        :~  [%pass /emissary/fine %grow /delegate/(scot %p ship) noun+%.y]
            [%pass /emissary/fine %grow /delegates noun+delegates]
            [%pass /emissary/fine %grow /outgoing noun+`(set ^ship)`(silt `(list ^ship)`(turn (skim ~(tap by delegates) |=([=^ship =status] =(%pending status))) head))]
        ==
      (pa-emil new-cards)
      ::
        %reject
      =.  delegates  (~(put by delegates) ship %rejected)
      =/  new-cards
        :~  [%pass /emissary/fine %grow /delegate/(scot %p ship) noun+%.n]
            [%pass /emissary/fine %grow /delegates noun+delegates]
            [%pass /emissary/fine %grow /outgoing noun+`(set ^ship)`(silt `(list ^ship)`(turn (skim ~(tap by delegates) |=([=^ship =status] =(%pending status))) head))]
        ==
      (pa-emil new-cards)
    ==  ::  %emissary-response
  --  ::  patrons core
::
::  delegates core
++  de
  |_  $:  patrons=(set ship)
          delegates=(map ship status)
          requests=(set ship)
          deck=(list card)
      ==
  +*  de  .
  ++  de-emit  |=(c=card de(deck [c deck]))
  ++  de-emil  |=(lc=(list card) de(deck (welp lc deck)))
  ++  de-abed
    |=  [p=(set ship) r=(set ship)]
    de(patrons p, requests r)
  ++  de-abet
    ^-  (quip card _state)
    [(flop deck) state(patrons patrons, requests requests)]
  ++  de-watch
    |.
    ^+  de
    ?:  (~(has in patrons) src.bol)
      ::  If the patronage has already been accepted, this is redundant;
      ::  simply notify the requester.
      %-  de-emil
      :~  [%give %fact ~ %emissary-response !>(%accept)]
          [%pass /emissary/fine %grow /patron/(scot %p src.bol) emissary-demand+[%patron %.y]]
          [%pass /emissary/fine %grow /patrons emissary-demand+[%patrons patrons]]
          ::  XX formally unnecessary to update /incoming here
      ==
    de
  ++  de-poke-request
    |=  [req=request =ship]
    ^+  de
    ?-    req
        %designate
      ?:  (~(has in patrons) ship)
        ::  If the patronage has already been accepted, this is redundant;
        ::  simply notify the subscribers.
        =/  new-cards
          :~  [%give %fact ~[/request] %emissary-response !>(%accept)]
              [%pass /emissary/fine %grow /patron/(scot %p ship) emissary-demand+[%patron %.y]]
              [%pass /emissary/fine %grow /patrons emissary-demand+[%patrons patrons]]
              ::  XX formally unnecessary to update /incoming here
          ==
        (de-emil new-cards)
      ::  Otherwise, we need to add the patronage request to our list and notify
      ::  the delegate-designee through %hark.
      =.  requests  (~(put in requests) ship)
      =/  new-cards
        ?.  .^(? %gu /(scot %p our.bol)/hark/(scot %da now.bol)/$)  ~
        =/  con=(list content:hark)  [[%ship ship] 'Designation request received.' ~]
        =/  =id:hark      (end 7 (shas %emissary-trigger eny.bol))
        =/  =rope:hark    [~ ~ q.byk.bol /(scot %p ship)/[dap.bol]]
        =/  =action:hark  [%add-yarn & & id rope now.bol con /[dap.bol] ~]
        :~  [%pass /hark %agent [our.bol %hark] %poke %hark-action !>(action)]
            [%pass /emissary/fine %grow /incoming emissary-demand+[%incoming requests]]
        ==
      (de-emil new-cards)
      ::
        %revoke
      ?.  |((~(has in requests) ship) (~(has in patrons) ship))  de
      =.  patrons  (~(del in patrons) ship)
      =.  requests  (~(del in requests) ship)
      =/  new-cards
      :~  [%pass /emissary/fine %grow /patron/(scot %p ship) emissary-demand+[%patron %.n]]
          [%pass /emissary/fine %grow /patrons emissary-demand+[%patrons patrons]]
          [%pass /emissary/fine %grow /incoming emissary-demand+[%incoming requests]]
      ==
    (de-emil new-cards)
    ==  ::  %emissary-request
    ::
  ++  de-poke-decide
    |=  dec=decide
    ^+  de
    ?-    -.dec
        %accept
      =.  patrons  (~(put in patrons) ship.dec)
      =?  requests  (~(has in requests) ship.dec)  (~(del in requests) ship.dec)
      =/  new-cards=(list card)
        :~  [%give %fact ~[/request] %emissary-response !>(%accept)]
            [%give %kick ~[/request] `src.bol]
            [%pass /emissary/fine %grow /patron/(scot %p ship.dec) emissary-demand+[%patron %.y]]
            [%pass /emissary/fine %grow /patrons emissary-demand+[%patrons patrons]]
            [%pass /emissary/fine %grow /incoming emissary-demand+[%incoming requests]]
        ==
      (de-emil (flop new-cards))
      ::
        %reject
      =?  patrons  (~(has in patrons) ship.dec)  (~(del in patrons) ship.dec)
      =?  requests  (~(has in requests) ship.dec)  (~(del in requests) ship.dec)
      =/  new-cards=(list card)
        :~  [%give %fact ~[/request] %emissary-response !>(%reject)]
            [%give %kick ~[/request] `ship.dec]
            [%pass /emissary/fine %grow /patron/(scot %p ship.dec) emissary-demand+[%patron %.n]]
            [%pass /emissary/fine %grow /patrons emissary-demand+[%patrons patrons]]
            [%pass /emissary/fine %grow /incoming emissary-demand+[%incoming requests]]
        ==
      (de-emil (flop new-cards))
    ==  ::  %emissary-response
  --  ::  delegates core
--
