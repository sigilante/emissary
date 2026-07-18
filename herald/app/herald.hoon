::  /app/herald
::::  Verified announcement feeds over %emissary delegation.
::
::    An author (a delegate planet) posts as a voice (its patron).
::    Followers receive posts over ordinary subscriptions and verify
::    the delegation through /lib/emissary-observer — the mark on a
::    post is live: it holds only while both sides attest.
::
/-  herald
/+  dbug,
    default-agent,
    eo=emissary-observer,
    schooner
::
|%
+$  versioned-state
  $%  state-zero
  ==
+$  state-zero
  $:  %zero
      feed=(list post:herald)      ::  our published posts, newest first
      follows=(set ship)
      inbox=(list post:herald)     ::  received posts, newest first
      =obs:eo
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
    go       ~(. go:eo obs bowl)
++  on-init
  ^-  (quip card _this)
  :_  this
  [%pass /eyre/connect %arvo %e %connect [~ /apps/[dap.bowl]] dap.bowl]~
++  on-save  !>(state)
++  on-load
  |=  =old=vase
  ^-  (quip card _this)
  =/  old  !<(versioned-state old-vase)
  ?-  -.old
    %zero  `this(state old)
  ==
++  on-poke
  |=  [=mark =vase]
  ^-  (quip card _this)
  ?+    mark  (on-poke:default mark vase)
      %herald-action
    =/  act  !<(action:herald vase)
    ?>  =(our.bowl src.bowl)
    ?-    -.act
        %post
      =/  =post:herald  [voice.act our.bowl body.act now.bowl]
      =.  feed  [post feed]
      :_  this
      [%give %fact ~[/feed] %herald-update !>(`update:herald`[%post post])]~
    ::
        %follow
      =.  follows  (~(put in follows) ship.act)
      :_  this
      [%pass /feed/(scot %p ship.act) %agent [ship.act %herald] %watch /feed]~
    ::
        %unfollow
      =.  follows  (~(del in follows) ship.act)
      :_  this
      [%pass /feed/(scot %p ship.act) %agent [ship.act %herald] %leave ~]~
    ::
        %refresh
      =^  cards  obs  (refresh:go ~s0)
      [cards this]
    ==
  ::
      %handle-http-request
    =+  !<([id=@ta req=inbound-request:eyre] vase)
    ?.  authenticated.req
      [(response:schooner id 303 ~ [%login-redirect url.request.req]) this]
    [(response:schooner id 200 ~ [%html (page bowl)]) this]
  ==
++  on-watch
  |=  =path
  ^-  (quip card _this)
  ?+    path  (on-watch:default path)
      [%http-response *]  `this
      [%feed ~]
    ::  backlog: recent posts to the new subscriber, oldest first
    :_  this
    %+  turn  (flop (scag 20 feed))
    |=  p=post:herald
    ^-  card
    [%give %fact ~ %herald-update !>(`update:herald`[%post p])]
  ==
++  on-agent
  |=  [=wire =sign:agent:gall]
  ^-  (quip card _this)
  ?+    wire  (on-agent:default wire sign)
      [%feed her=@ ~]
    =/  her  (slav %p i.t.wire)
    ?-    -.sign
        %fact
      ?.  =(%herald-update p.cage.sign)  `this
      =/  upd  !<(update:herald q.cage.sign)
      ?>  ?=(%post -.upd)
      ::  authorial integrity: a fact must come from its own author
      ?.  =(author.post.upd src.bowl)  `this
      =.  inbox  [post.upd inbox]
      =^  cards  obs  (start:go [voice.post.upd author.post.upd])
      [cards this]
    ::
        %kick
      :_  this
      [%pass /feed/(scot %p her) %agent [her %herald] %watch /feed]~
    ::
        %watch-ack
      ?~  p.sign  `this
      ((slog leaf+"%herald: subscribe to {<her>} failed" u.p.sign) `this)
    ::
        %poke-ack  `this
    ==
  ==
++  on-arvo
  |=  [=wire =sign-arvo]
  ^-  (quip card _this)
  ?:  ?=([%emissary-observer *] wire)
    ?>  ?=([%ames %sage *] sign-arvo)
    `this(obs (take:go +>.sign-arvo))
  ?:  ?=([%eyre %bound *] sign-arvo)  `this
  (on-arvo:default wire sign-arvo)
++  on-peek
  |=  =path
  ^-  (unit (unit cage))
  ?+  path  (on-peek:default path)
    [%x %inbox ~]     ``noun+!>(inbox)
    [%x %feed ~]      ``noun+!>(feed)
    [%x %verdicts ~]  ``noun+!>(all:go)
  ==
++  on-leave  on-leave:default
++  on-fail   on-fail:default
--
::
::  helpers, below the agent core proper
::
|%
::  +page: the inbox, server-rendered; the verification mark on each
::  post is computed live from the observer library at render time
::
++  page
  |=  =bowl:gall
  ^-  @t
  =/  gob  ~(. go:eo obs bowl)
  =/  rows=@t
    ?:  =(~ inbox)
      '<p class="empty">nothing yet &#8212; :herald|follow an author.</p>'
    %+  rap  3
    %+  turn  inbox
    |=  p=post:herald
    ^-  @t
    =/  v  (verdict:gob [voice.p author.p])
    =/  mk=[glyph=@t klass=@t label=@t]
      ?-  v
        %verified     ['&#10003;' 'ok' 'verified']
        %conflict     ['&#10007;' 'bad' 'conflict &#8212; delegation disputed']
        %none         ['&#10007;' 'bad' 'no delegation']
        %unconfirmed  ['~' 'mid' 'unconfirmed']
        %pending      ['&#183;' 'dim' 'verifying&#8230;']
        %unknown      ['&#183;' 'dim' 'unverified']
      ==
    %+  rap  3
    :~  '<div class="post"><div class="meta"><span class="mark '
        klass.mk  '">'  glyph.mk  '</span> <b>'  (scot %p voice.p)
        '</b> <span class="via">via '  (scot %p author.p)
        ' &#183; '  label.mk  '</span></div><div class="body">'
        (escape body.p)  '</div></div>'
    ==
  %+  rap  3
  :~  '<!doctype html><html><head><meta charset="utf-8">'
      '<meta http-equiv="refresh" content="10">'
      '<meta name="viewport" content="width=device-width, initial-scale=1">'
      '<title>%herald</title><style>'
      'body{background:#2f3019;color:#f7f1d2;font-family:ui-monospace,monospace;'
      'max-width:640px;margin:2.5rem auto;padding:0 1rem;line-height:1.5}'
      'h1{font-weight:400}h1 span{color:#fed107}'
      '.sub{color:rgba(247,241,210,.55);font-size:.8rem;margin-bottom:2rem}'
      '.post{border:1px solid rgba(247,241,210,.25);padding:.8rem 1rem;margin-bottom:1rem}'
      '.meta{font-size:.85rem;margin-bottom:.4rem}'
      '.via{color:rgba(247,241,210,.55);font-size:.8rem}'
      '.mark{display:inline-block;width:1.4rem;text-align:center;border:1px solid;padding:0 .1rem}'
      '.ok{color:#5dbf8d}.bad{color:#f05826}.mid{color:#fed107}'
      '.dim{color:rgba(247,241,210,.5)}'
      '.empty{color:rgba(247,241,210,.45)}'
      '</style></head><body>'
      '<h1><span>%</span>herald</h1>'
      '<p class="sub">verified announcements &#183; the mark is live: it holds '
      'only while both sides of the delegation attest &#183; auto-refreshes</p>'
      rows
      '</body></html>'
  ==
++  escape
  |=  t=@t
  ^-  @t
  %-  crip
  %-  zing
  %+  turn  (trip t)
  |=  c=@tD
  ^-  tape
  ?:  =('<' c)  "&lt;"
  ?:  =('>' c)  "&gt;"
  ?:  =('&' c)  "&amp;"
  ?:  =('"' c)  "&quot;"
  [c]~
--
