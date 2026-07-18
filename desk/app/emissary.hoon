/-  *emissary,
    hark
/+  dbug,
    default-agent,
    *emissary,
    *mip,
    rudder,
    schooner,
    server,
    sigil-svg=sigil
::
/~  pages
    (page:rudder [(set ship) (map ship status) (set ship) queries (map path @ud)] ?(trigger decide query))
    /app/emissary/webui
::
|%
+$  versioned-state
  $%  state-zero
      state-one
      state-two
      state-three
  ==
+$  state-zero
  $:  %zero
      patrons=(set ship)
      delegates=(map ship status)
      requests=(set ship)
  ==
+$  state-one
  $:  %one
      patrons=(set ship)
      delegates=(map ship status)
      requests=(set ship)
      queries=queries
  ==
+$  state-two
  $:  %two
      patrons=(set ship)
      delegates=(map ship status)
      requests=(set ship)
      =queries
  ==
::  pubs: last published revision per scry path, mirroring gall's
::  farm numbering (monotonic +1 per %grow, preserved across %cull)
+$  state-three
  $:  %three
      patrons=(set ship)
      delegates=(map ship status)
      requests=(set ship)
      =queries
      pubs=(map path @ud)
  ==
+$  card  card:agent:gall
--
%-  agent:dbug
=|  state-three
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
  =/  old  state
  =^  cards  state  abet:(poke:eng mark vase)
  =?  cards  !=(old state)
    (snoc cards `card`[%give %fact ~[/web/state] %json !>(state-json:eng)])
  [cards this]
::
++  on-peek
  |=  =path
  ^-  (unit (unit cage))
  (peek:eng path)
++  on-arvo
  |=  [=wire =sign-arvo]
  ^-  (quip card _this)
  =/  old  state
  =^  cards  state  abet:(arvo:eng wire sign-arvo)
  =?  cards  !=(old state)
    (snoc cards `card`[%give %fact ~[/web/state] %json !>(state-json:eng)])
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
  =/  old  state
  =^  cards  state  abet:(agent:eng wire sign)
  =?  cards  !=(old state)
    (snoc cards `card`[%give %fact ~[/web/state] %json !>(state-json:eng)])
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
      [%pass /eyre/connect %arvo %e %connect [~ /apps/[dap.bol]/observer] dap.bol]
  ==
::
++  init
  ^+  that
  =/  keys  [%pass /jael/pubs %arvo %j %public-keys ~]
  (emil [keys connect])
::
++  load
  |=  =old=vase
  ^+  that
  =/  old  !<(versioned-state old-vase)
  ?-    -.old
      %zero
    that(state [%three patrons.old delegates.old requests.old *^queries scan-pubs])
      %one
    ::  okay to lose old queries at this point, so just bunt
    that(state [%three patrons.old delegates.old requests.old *^queries scan-pubs])
      %two
    that(state [%three patrons.old delegates.old requests.old queries.old scan-pubs])
      %three
    ~&  >  '%emissary loaded'
    that(state old)
  ==
::  +scan-pubs: recover published-revision counters from gall's farm
::
++  scan-pubs
  ^-  (map path @ud)
  =/  base=path  /(scot %p our.bol)/[dap.bol]/(scot %da now.bol)//1
  %-  malt
  %+  turn  .^((list path) %gt base)
  |=  pax=path
  [pax +:.^([%ud @ud] %gw (welp base pax))]
::  +sieve: delegates with a given status
::
++  sieve
  |=  [dels=(map ship status) wanted=status]
  ^-  (set ship)
  %-  silt
  %+  turn
    (skim ~(tap by dels) |=([=ship =status] =(wanted status)))
  head
::  +bind-cards: publish new revisions, culling stale ones
::
++  bind-cards
  |=  [pubs=(map path @ud) bins=(list [pax=path pag=page])]
  ^-  [(list card) (map path @ud)]
  =|  cards=(list card)
  |-  ^-  [(list card) (map path @ud)]
  ?~  bins  [(flop cards) pubs]
  ::  tombstone (not cull) the prior revision: a tombed case stays
  ::  in the farm as a hash, while a culled case can never be bound
  ::  or answered again — hazardous to racing observers
  =/  cur=@ud  (~(gut by pubs) pax.i.bins 0)
  =?  cards  (gth cur 0)
    [[%pass /emissary/fine %tomb ud+cur pax.i.bins] cards]
  =.  cards  [[%pass /emissary/fine %grow pax.i.bins pag.i.bins] cards]
  =.  pubs   (~(put by pubs) pax.i.bins +(cur))
  $(bins t.bins)
::  +iso: @da as ISO-8601 UTC cord
::
++  iso
  |=  da=@da
  ^-  @t
  =/  yr  (yore da)
  =/  pad
    |=  [w=@ud n=@ud]
    ^-  tape
    =/  t  (a-co:co n)
    (weld (reap (sub w (min w (lent t))) '0') t)
  %-  crip
  ;:  weld
    (pad 4 y.yr)  "-"  (pad 2 m.yr)  "-"  (pad 2 d.t.yr)
    "T"  (pad 2 h.t.yr)  ":"  (pad 2 m.t.yr)  ":"  (pad 2 s.t.yr)  "Z"
  ==
::  +state-json: the /api/v1/state document (see docs/dashboard-api.md)
::
++  state-json
  ^-  json
  =*  ej  enjs:format
  =/  all=(set ship)
    =/  s  (~(put in (~(uni in patrons) requests)) our.bol)
    =.  s
      %+  roll  ~(tap by delegates)
      |=([[p=ship *] a=_s] (~(put in a) p))
    %+  roll  ~(tap by queries)
    |=  [[p=ship qs=quests] a=_s]
    =.  a  (~(put in a) p)
    %+  roll  ~(tap by qs)
    |=  [[* q=quest] b=_a]
    ?~  ships.q  b
    (~(uni in b) u.ships.q)
  %-  pairs:ej
  :~  :-  'ship'  s+(scot %p our.bol)
      :-  'delegates'
      %-  pairs:ej
      %+  turn  ~(tap by delegates)
      |=([p=ship t=status] [(scot %p p) s+t])
      :-  'patrons'   a+(turn ~(tap in patrons) |=(p=ship s+(scot %p p)))
      :-  'incoming'  a+(turn ~(tap in requests) |=(p=ship s+(scot %p p)))
      :-  'queries'
      %-  pairs:ej
      %+  turn  ~(tap by queries)
      |=  [p=ship qs=quests]
      :-  (scot %p p)
      %-  pairs:ej
      %+  turn  ~(tap by qs)
      |=  [k=kind q=quest]
      :-  k
      %-  pairs:ej
      :~  ['status' s+status.q]
          ['timestamp' ?:(=(*@da timestamp.q) ~ s+(iso timestamp.q))]
          :-  'ships'
          ?~  ships.q  ~
          a+(turn ~(tap in u.ships.q) |=(w=ship s+(scot %p w)))
      ==
      :-  'keys'
      %-  pairs:ej
      %+  turn  ~(tap in all)
      |=  p=ship
      :-  (scot %p p)
      =/  lyf  .^((unit @ud) %j /(scot %p our.bol)/lyfe/(scot %da now.bol)/(scot %p p))
      =/  ryf  .^((unit @ud) %j /(scot %p our.bol)/ryft/(scot %da now.bol)/(scot %p p))
      %-  pairs:ej
      :~  ['life' (numb:ej (fall lyf 0))]
          ['rift' (numb:ej (fall ryf 0))]
      ==
  ==
::  +spout: emit an http response
::
++  spout
  |=  [id=@ta status=@ud hed=headers:schooner res=resource:schooner]
  ^+  that
  ::  pre-flop: +emil prepends without reversing, so +abet's flop
  ::  would otherwise emit these response cards in reverse order
  (emil (flop (response:schooner id status hed res)))
::  +serve-octs: raw payload with exact length; schooner's as-octs
::  would truncate binaries that end in zero bytes (both fonts do)
::
++  serve-octs
  |=  [id=@ta typ=@t dat=octs]
  ^+  that
  %-  emil  %-  flop
  %+  give-simple-payload:app:server  id
  [[200 ~[['content-type' typ] ['cache-control' 'public, max-age=604800']]] `dat]
::  +dash: serve the dashboard page out of clay
::
++  dash
  |=  ord=order:rudder
  ^+  that
  ?.  authenticated.ord
    (spout id.ord 303 ~ [%login-redirect url.request.ord])
  %:  spout  id.ord  200  ~
    :-  %html
    .^(@t %cx /(scot %p our.bol)/[q.byk.bol]/(scot %da now.bol)/app/emissary/webui/dashboard/html)
  ==
::  +fnt: serve desk fonts
::
++  fnt
  |=  [ord=order:rudder rest=(pole @t)]
  ^+  that
  =/  base=path  /(scot %p our.bol)/[q.byk.bol]/(scot %da now.bol)/fnt
  ?+    rest  (spout id.ord 404 ~ [%plain "not found"])
      [%urbit-sans ~]
    (serve-octs id.ord 'font/woff2' .^(octs %cx (welp base /urbit-sans/woff2)))
      [%space-mono ~]
    (serve-octs id.ord 'font/ttf' .^(octs %cx (welp base /space-mono/ttf)))
  ==
::  +api: /apps/emissary/api/v1 dispatch
::
++  api
  |=  [ord=order:rudder rest=(pole @t)]
  ^+  that
  =/  id  id.ord
  ?.  authenticated.ord
    (spout id 401 ~ [%plain "unauthorized"])
  ?+    rest  (spout id 404 ~ [%plain "not found"])
      [%state ~]
    ?.  =(%'GET' method.request.ord)
      (spout id 405 ~ [%plain "method not allowed"])
    (spout id 200 ~ [%json state-json])
  ::
      [%sigil w=@ ~]
    ?.  =(%'GET' method.request.ord)
      (spout id 405 ~ [%plain "method not allowed"])
    ?~  who=(slaw %p w.rest)
      (spout id 400 ~ [%plain "bad ship"])
    ?.  ?=(?(%czar %king %duke) (clan:title u.who))
      (spout id 404 ~ [%plain "no sigil for moons or comets"])
    =/  svg=manx
      %.  u.who
      %_  sigil-svg
        fg  "#f7f1d2"
        bg  "#2f3019"
      ==
    %:  spout  id  200
      ['cache-control'^'public, max-age=86400']~
      [%image-svg (crip (en-xml:html svg))]
    ==
  ::
      [%action ~]
    ?.  =(%'POST' method.request.ord)
      (spout id 405 ~ [%plain "method not allowed"])
    =/  bod  body.request.ord
    ?~  bod  (spout id 400 ~ [%plain "empty body"])
    =/  jon=(unit json)  (de:json:html q.u.bod)
    ?.  ?=([~ %o *] jon)
      (spout id 400 ~ [%plain "malformed json"])
    =/  act  ~(tap by p.u.jon)
    ?.  ?=([[@ *] ~] act)
      (spout id 400 ~ [%plain "expected exactly one action"])
    =/  key  p.i.act
    =/  obj  q.i.act
    ?.  ?=([%o *] obj)
      (spout id 400 ~ [%plain "malformed action"])
    =/  shp=(unit @p)
      ?~  s=(~(get by p.obj) 'ship')  ~
      ?.  ?=([~ %s *] s)  ~
      (slaw %p p.u.s)
    ?~  shp  (spout id 400 ~ [%plain "bad ship"])
    =/  kin=(unit kind)
      ?~  k=(~(get by p.obj) 'kind')  ~
      ?.  ?=([~ %s *] k)  ~
      ?.  ?=(?(%delegate %patron) p.u.k)  ~
      `p.u.k
    =^  done=?  that
      ?+    key  [| that]
          %designate
        [& (poke %emissary-trigger !>(`trigger`[%designate u.shp]))]
          %revoke
        [& (poke %emissary-trigger !>(`trigger`[%revoke u.shp]))]
          %accept
        [& (poke %emissary-decide !>(`decide`[%accept u.shp]))]
          %reject
        [& (poke %emissary-decide !>(`decide`[%reject u.shp]))]
          %query
        ?~  kin  [| that]
        [& (poke %emissary-query !>(`query`[u.kin u.shp]))]
      ==
    ?.  done  (spout id 400 ~ [%plain "unknown action"])
    (spout id 204 ~ [%none ~])
  ==
::
++  peek
  |=  pol=(pole knot)
  ^-  (unit (unit cage))
  ?+  pol  ~|(%invalid-scry-path !!)
    [%y %delegates ~]        ``[%emissary-demand !>([%delegates `(set ship)`(silt `(list ship)`(turn (skim ~(tap by delegates) |=([=ship =status] =(%valid status))) head))])]
    [%y %patrons ~]          ``[%emissary-demand !>([%patrons patrons])]
    [%y %outgoing ~]         ``[%emissary-demand !>([%outgoing `(set ship)`(silt `(list ship)`(turn (skim ~(tap by delegates) |=([=ship =status] =(%pending status))) head))])]
    [%y %incoming ~]         ``[%emissary-demand !>([%requests requests])]
    [%x %delegate ship=@ ~]  ``[%emissary-demand !>([%delegate (~(has by delegates) `@p`(need (slaw %p ship:pol)))])]
    [%x %patron ship=@ ~]    ``[%emissary-demand !>([%patron (~(has in patrons) `@p`(need (slaw %p ship:pol)))])]
  ==  ::  path
::
++  watch
  |=  pol=(pole knot)
  ^+  that
  ?+    pol  ~|(%invalid-watch-path !!)
  ::
      [%http-response *]
    that
  ::  /web/state: full-state json stream; every fact is a whole document
      [%web %state ~]
    (emit [%give %fact ~ %json !>(state-json)])
  ::  /request does nothing until the point has made a decision
      [%request ~]
    =^  cards  state
      de-abet:(de-watch:(de-abed:de patrons requests pubs))
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
            pa-abet:(pa-agent-response:(pa-abed:pa delegates pubs) res src.bol)
          (emil cards)
        ?>  =(%reject res)
        =^  cards  state
          pa-abet:(pa-agent-response:(pa-abed:pa delegates pubs) res src.bol)
        (emil cards)
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
  ?+    sign-arvo  ~|(%bad-arvo-sign that)
      [%eyre %bound *]
    that
    ::
      [%ames %sage *]
    =^  cards  state
      ob-abet:(ob-arvo-sage:(ob-abed:ob queries) +>:sign-arvo)
    (emil cards)
    ::
      [%jael %public-keys *]
    ?.  ?=(%breach -.public-keys-result.sign-arvo)
      that
    ::  someone breached
    =/  =ship  who.public-keys-result.sign-arvo
    ?.  ?|  (~(has in patrons) ship)
            (~(has by delegates) ship)
            (~(has in requests) ship)
            (~(has by queries) ship)
        ==
      that
    =.  that  (poke %emissary-trigger !>(`trigger`[%revoke ship]))
    =.  that  (poke %emissary-decide !>(`decide`[%reject ship]))
    ::  cancel any in-flight keens toward the breached ship: they can
    ::  never resolve and would wedge the peer's peek flow
    =.  that
      %-  emil
      %+  murn  ~(tap by (~(gut by queries) ship *quests))
      |=  [=kind q=quest]
      ^-  (unit card)
      ?.  (ob-pending:ob q)  ~
      `(ob-yawn:ob ship kind timestamp.q)
    =.  queries  (~(del by queries) ship)
    =.  requests  (~(del in requests) ship)
    %-  emil
    ^-  (list card)
    ?.  .^(? %gu /(scot %p our.bol)/hark/(scot %da now.bol)/$)  ~
    =/  con=(list content:hark)  [[%ship ship] ' breached; removed from %emissary.' ~]
    =/  =id:hark      (end 7 (shas %emissary-trigger eny.bol))
    =/  =rope:hark    [~ ~ q.byk.bol /(scot %p ship)/[dap.bol]]
    =/  =action:hark  [%add-yarn & & id rope now.bol con /[dap.bol] ~]
    ~[[%pass /hark %agent [our.bol %hark] %poke %hark-action !>(action)]]
  ==
::
++  poke
  |=  [=mark =vase]
  ^+  that
  ?+    mark  ~|(%invalid-poke that)
      %emissary-trigger
    =^  cards  state
      =/  tri  !<(trigger vase)
      ::  from UI
      ?>  =(our.bol src.bol)
      pa-abet:(pa-poke-trigger:(pa-abed:pa delegates pubs) tri)
    (emil cards)
    ::
      %emissary-request
    =^  cards  state
      =/  req  !<(request vase)
      ::  over the wire
      ?>  !=(our.bol src.bol)
      de-abet:(de-poke-request:(de-abed:de patrons requests pubs) req src.bol)
    (emil cards)
    ::
      %emissary-decide
    =^  cards  state
      =/  dec  !<(decide vase)
      ::  from UI
      ?>  =(our.bol src.bol)
      de-abet:(de-poke-decide:(de-abed:de patrons requests pubs) dec)
    (emil cards)
    ::
      %emissary-query
    =^  cards  state
      =/  que  !<(query vase)
      ::  from UI
      ?>  =(our.bol src.bol)
      ob-abet:(ob-poke-query:(ob-abed:ob queries) que)
    (emil cards)
    ::
      %handle-http-request
    =/  ord  !<(order:rudder vase)
    =/  lyn  (parse-request-line:server url.request.ord)
    ?:  =(~['apps' 'emissary' 'api' 'v1'] (scag 4 site.lyn))
      (api ord (slag 4 site.lyn))
    ?:  =(~['apps' 'emissary' 'fnt'] (scag 3 site.lyn))
      (fnt ord (slag 3 site.lyn))
    ?:  ?&  =(%'GET' method.request.ord)
            ?|  =(~['apps' 'emissary'] site.lyn)
                ?&  =(~['apps' 'emissary' 'observer'] site.lyn)
                    ?=(^ args.lyn)
        ==  ==  ==
      (dash ord)
    =;  out=(quip card _+.state)
      =.  +.state  +.out
      :: flop here so that the kick from rudder isn't first
      (emil (flop -.out))
    %.  [bol ord +.state]
    %-  (steer:rudder _+.state ?(trigger decide query))
    :^    pages
        (point:rudder /apps/[dap.bol] & ~(key by pages))
      (fours:rudder +.state)
    |=  val=?(trigger decide query)
    ^-  $@(brief:rudder [brief:rudder (list card) _+.state])
    ::  XXX the following is pretty nasty to satisfy /lib/rudder restrictions
    ?-    -.val  ::~|(%unexpected-query-from-frontend !!)
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
        %patron
      =.  that  (poke %emissary-query !>(`query`[%patron +.val]))
      [%'' deck +.state]
        %delegate
      =.  that  (poke %emissary-query !>(`query`[%delegate +.val]))
      [%'' deck +.state]
    ==
  ==  ::  mark
::  patrons core
++  pa
  |_  $:  delegates=(map ship status)
          pubs=(map path @ud)
          deck=(list card)
      ==
  +*  pa  .
  ++  pa-emit  |=(c=card pa(deck [c deck]))
  ++  pa-emil  |=(lc=(list card) pa(deck (welp lc deck)))
  ++  pa-abed
    |=  [dels=(map ship status) pub=(map path @ud)]
    pa(delegates dels, pubs pub)
  ++  pa-abet
    ^-  (quip card _state)
    [(flop deck) state(delegates delegates, pubs pubs)]
  ++  pa-bind
    |=  bins=(list [pax=path pag=page])
    ^+  pa
    =^  cards  pubs  (bind-cards pubs bins)
    (pa-emil cards)
  ++  pa-poke-trigger
    |=  tri=trigger
    ^+  pa
    ?-    -.tri
        %designate
      ::?>  ~|(%cannot-designate-superior (is-supra our.bol ship.tri))
      =/  stat  (~(get by delegates) ship.tri)
      ::  if already valid or pending, nothing to do
      ?:  |(=(`%valid stat) =(`%pending stat))  pa
      ::  fresh or previously rejected: (re)send the request
      =.  delegates  (~(put by delegates) ship.tri %pending)
      =.  pa
        %-  pa-emil
        :~  [%pass /emissary/(scot %p ship.tri) %agent [ship.tri %emissary] %poke %emissary-request !>(%designate)]
            [%pass /emissary/(scot %p ship.tri) %agent [ship.tri %emissary] %watch /request]
        ==
      (pa-bind [/outgoing [%emissary-demand %outgoing (sieve delegates %pending)]]~)
    ::
        %revoke
      ?.  (~(has by delegates) ship.tri)  pa
      =.  delegates  (~(del by delegates) ship.tri)
      =.  pa
        %-  pa-emil
        :~  [%pass /emissary/(scot %p ship.tri) %agent [ship.tri %emissary] %poke %emissary-request !>(%revoke)]
            [%pass /emissary/(scot %p ship.tri) %agent [ship.tri %emissary] %leave ~]
        ==
      %-  pa-bind
      :~  [/delegate/(scot %p ship.tri) [%emissary-demand %delegate %.n]]
          [/delegates [%emissary-demand %delegates (sieve delegates %valid)]]
          [/outgoing [%emissary-demand %outgoing (sieve delegates %pending)]]
      ==
    ==  ::  %emissary-trigger
  ++  pa-agent-response
    |=  [res=response =ship]
    ^+  pa
    =.  delegates
      (~(put by delegates) ship ?:(=(%accept res) %valid %rejected))
    %-  pa-bind
    :~  [/delegate/(scot %p ship) [%emissary-demand %delegate =(%accept res)]]
        [/delegates [%emissary-demand %delegates (sieve delegates %valid)]]
        [/outgoing [%emissary-demand %outgoing (sieve delegates %pending)]]
    ==
  --  ::  patrons core
::
::  delegates core
++  de
  |_  $:  patrons=(set ship)
          requests=(set ship)
          pubs=(map path @ud)
          deck=(list card)
      ==
  +*  de  .
  ++  de-emit  |=(c=card de(deck [c deck]))
  ++  de-emil  |=(lc=(list card) de(deck (welp lc deck)))
  ++  de-abed
    |=  [p=(set ship) r=(set ship) pub=(map path @ud)]
    de(patrons p, requests r, pubs pub)
  ++  de-abet
    ^-  (quip card _state)
    [(flop deck) state(patrons patrons, requests requests, pubs pubs)]
  ++  de-bind
    |=  bins=(list [pax=path pag=page])
    ^+  de
    =^  cards  pubs  (bind-cards pubs bins)
    (de-emil cards)
  ++  de-watch
    |.
    ^+  de
    ?:  (~(has in patrons) src.bol)
      ::  If the patronage has already been accepted, this is redundant;
      ::  simply notify the requester.
      (de-emit [%give %fact ~ %emissary-response !>(%accept)])
    de
  ++  de-poke-request
    |=  [req=request =ship]
    ^+  de
    ?-    req
        %designate
      ?:  (~(has in patrons) ship)
        ::  If the patronage has already been accepted, this is redundant;
        ::  simply notify the subscribers.
        (de-emit [%give %fact ~[/request] %emissary-response !>(%accept)])
      ::  Otherwise, record the request and publish; notify through
      ::  %hark where available.
      =.  requests  (~(put in requests) ship)
      =.  de  (de-bind [/incoming [%emissary-demand %incoming requests]]~)
      ?.  .^(? %gu /(scot %p our.bol)/hark/(scot %da now.bol)/$)  de
      =/  con=(list content:hark)  [[%ship ship] 'Designation request received.' ~]
      =/  =id:hark      (end 7 (shas %emissary-trigger eny.bol))
      =/  =rope:hark    [~ ~ q.byk.bol /(scot %p ship)/[dap.bol]]
      =/  =action:hark  [%add-yarn & & id rope now.bol con /[dap.bol] ~]
      (de-emit [%pass /hark %agent [our.bol %hark] %poke %hark-action !>(action)])
      ::
        %revoke
      ?.  |((~(has in requests) ship) (~(has in patrons) ship))  de
      =.  patrons   (~(del in patrons) ship)
      =.  requests  (~(del in requests) ship)
      %-  de-bind
      :~  [/patron/(scot %p ship) [%emissary-demand %patron %.n]]
          [/patrons [%emissary-demand %patrons patrons]]
          [/incoming [%emissary-demand %incoming requests]]
      ==
    ==  ::  %emissary-request
  ++  de-poke-decide
    |=  dec=decide
    ^+  de
    =/  acc  ?=(%accept -.dec)
    =?  patrons  acc   (~(put in patrons) ship.dec)
    =?  patrons  !acc  (~(del in patrons) ship.dec)
    =.  requests  (~(del in requests) ship.dec)
    =.  de
      %-  de-emil
      :~  [%give %fact ~[/request] %emissary-response !>(?:(acc %accept %reject))]
          [%give %kick ~[/request] `ship.dec]
      ==
    %-  de-bind
    :~  [/patron/(scot %p ship.dec) [%emissary-demand %patron acc]]
        [/patrons [%emissary-demand %patrons patrons]]
        [/incoming [%emissary-demand %incoming requests]]
    ==  ::  %emissary-decide
  --  ::  delegates core
::
::  observer core
++  ob
  |_  $:  =^queries
          deck=(list card)
      ==
  +*  ob  .
  ++  ob-emit  |=(c=card ob(deck [c deck]))
  ++  ob-emil  |=(lc=(list card) ob(deck (welp lc deck)))
  ++  ob-abed
    |=  =^^queries
    ob(queries queries)
  ++  ob-abet
    ^-  (quip card _state)
    [(flop deck) state(queries queries)]
  ::  +ob-what: the published path a query kind reads
  ++  ob-what
    |=  =kind
    ?:(?=(%patron kind) %patrons %delegates)
  ::  +ob-yawn: cancel an in-flight keen; wire and path must
  ::  reconstruct the original request exactly (same %da case)
  ++  ob-yawn
    |=  [=ship =kind ts=@da]
    ^-  card
    :+  %pass  /emissary/fine/(scot %da ts)
    [%arvo %a %yawn ship /g/x/(scot %da ts)/emissary//1/[(ob-what kind)]]
  ::  +ob-pending: a quest is in flight when %unknown with a real
  ::  request timestamp recorded
  ++  ob-pending
    |=  q=quest
    &(?=(%unknown status.q) !=(*@da timestamp.q))
  ++  ob-poke-query
    |=  que=query
    ^+  ob
    ::  a superseded in-flight keen is cancelled, not abandoned:
    ::  unresolvable pending interests can wedge the peer's peek flow
    =/  old  (~(get bi queries) ship.que kind.que)
    =?  ob  &(?=(^ old) (ob-pending u.old))
      (ob-emit (ob-yawn ship.que kind.que timestamp.u.old))
    =.  queries
      (~(put bi queries) ship.que kind.que [%unknown now.bol ~])
    %-  ob-emit
    :+  %pass  /emissary/fine/(scot %da now.bol)
    :+  %keen  %.n
    `spar:ames`[ship.que /g/x/(scot %da now.bol)/emissary//1/[(ob-what kind.que)]]
  ++  ob-arvo-sage
    |=  [[=ship =path] =gage:mess:ames]
    ^+  ob
    ::  if no value then just post a cleared value
    ?~  gage
      =?  queries  (~(has bi queries) ship %patron)
        (~(put bi queries) ship %patron [%unasked-for now.bol ~])
      =?  queries  (~(has bi queries) ship %delegate)
        (~(put bi queries) ship %delegate [%unasked-for now.bol ~])
      ob
    ::  if a value then unpack it and update the appropriate queries
    ?>  =(%emissary-demand p.gage)
    =+  ;;(data=demand q.gage)
    =?  queries  &(?=(%patrons -.data) (~(has bi queries) ship %patron))
      (~(put bi queries) ship %patron [%valid now.bol `p.data])
    =?  queries  &(?=(%delegates -.data) (~(has bi queries) ship %delegate))
      (~(put bi queries) ship %delegate [%valid now.bol `p.data])
    ob
  --  ::  observer core
--
