::  /lib/emissary-observer
::::  Standalone both-sides verification of %emissary bindings.
::
::    Self-contained interop library: no /- or /+ dependencies.  The
::    remote scry path format and the %emissary-demand payload shape
::    are the wire contract with the %emissary desk
::    (https://github.com/sigilante/emissary).
::
::    A binding [patron=~marzod delegate=~sampel-palnet] is VERIFIED
::    only when both sides attest: ~marzod's published delegate set
::    contains ~sampel-palnet AND ~sampel-palnet's published patron
::    set contains ~marzod.  This library issues both remote scries,
::    absorbs the answers, and produces verdicts.
::
::  usage, in a Gall agent:
::
::    /+  eo=emissary-observer
::    ::  keep an `obs:eo` in your state
::    ::
::    ::  begin (or re-run) verification of a binding:
::    =^  cards  obs.state
::      (~(start go:eo obs.state bowl) [patron delegate])
::    ::  route %sage signs back in from +on-arvo:
::    ?:  ?=([%emissary-observer *] wire)
::      ?>  ?=([%ames %sage *] sign-arvo)
::      `this(obs.state (~(take go:eo obs.state bowl) +>.sign-arvo))
::    ::  read a verdict at any time:
::    (~(verdict go:eo obs.state bowl) [patron delegate])
::
|%
+$  binding  [patron=ship delegate=ship]
::  stance: one side's answer so far
::    %pending   asked, no answer yet (first contact can take ~30s)
::    %answered  a published set arrived (see ships)
::    %absent    answered with nothing bound or tombstoned
+$  stance  ?(%pending %answered %absent)
+$  side    [=stance ships=(set ship) when=(unit @da)]
+$  record  [p-side=side d-side=side asked=@da]
+$  obs     (map binding record)
::  verdict
::    %verified     both sides attest
::    %conflict     one side attests, the other denies
::    %unconfirmed  one side attests, the other has not answered
::    %none         both sides deny
::    %pending      no positive evidence yet
::    %unknown      binding was never started
+$  verdict  ?(%verified %conflict %unconfirmed %none %pending %unknown)
::  demand mirrors /sur/emissary (wire contract)
+$  demand
  $%  [%delegates p=(set ship)]
      [%patrons p=(set ship)]
      [%outgoing p=(set ship)]
      [%incoming p=(set ship)]
      [%delegate p=?]
      [%patron p=?]
  ==
+$  card  card:agent:gall
++  go
  |_  [=obs =bowl:gall]
  ::  +start: begin (or refresh) verification of a binding.
  ::  emits two gall %keen tasks; answers arrive as %sage signs on
  ::  wires prefixed /emissary-observer.
  ::
  ++  start
    |=  =binding
    ^-  [(list card) _obs]
    =/  rec=record
      %+  fall  (~(get by obs) binding)
      [[%pending ~ ~] [%pending ~ ~] now.bowl]
    =.  rec
      %=  rec
        asked            now.bowl
        stance.p-side    %pending
        stance.d-side    %pending
      ==
    :_  (~(put by obs) binding rec)
    :~  (keen patron.binding /delegates)
        (keen delegate.binding /patrons)
    ==
  ::  +refresh: re-verify every binding asked longer ago than max-age.
  ::  attestations are point-in-time; call this on a timer or on user
  ::  action to keep verdicts current.
  ::
  ++  refresh
    |=  max-age=@dr
    ^-  [(list card) _obs]
    =/  stale=(list [=binding =record])
      %+  skim  ~(tap by obs)
      |=([=binding =record] (gth now.bowl (add asked.record max-age)))
    =|  cards=(list card)
    |-  ^-  [(list card) _obs]
    ?~  stale  [cards obs]
    =^  caz  obs  (start binding.i.stale)
    $(stale t.stale, cards (weld cards caz))
  ::  +forget: stop tracking a binding
  ::
  ++  forget
    |=  =binding
    ^-  _obs
    (~(del by obs) binding)
  ::  +take: absorb a %sage sign routed by the host agent.
  ::  one answer may settle a side of many tracked bindings.
  ::
  ++  take
    |=  [[=ship =path] gage=$@(~ [p=mark q=*])]
    ^-  _obs
    =/  what=(unit ?(%delegates %patrons))
      ?~  path  ~
      ?:  =(%delegates (rear path))  `%delegates
      ?:  =(%patrons (rear path))    `%patrons
      ~
    ?~  what  obs
    =/  new=side
      ?~  gage  [%absent ~ `now.bowl]
      ?.  =(%emissary-demand p.gage)  [%absent ~ `now.bowl]
      =/  dem  ((soft demand) q.gage)
      ?:  ?=([~ %delegates *] dem)  [%answered p.u.dem `now.bowl]
      ?:  ?=([~ %patrons *] dem)    [%answered p.u.dem `now.bowl]
      [%absent ~ `now.bowl]
    %-  ~(urn by obs)
    |=  [=binding =record]
    ^-  ^record
    ?:  &(?=(%delegates u.what) =(ship patron.binding))
      record(p-side new)
    ?:  &(?=(%patrons u.what) =(ship delegate.binding))
      record(d-side new)
    record
  ::  +verdict: the both-sides-agree rule
  ::
  ++  verdict
    |=  =binding
    ^-  ^verdict
    ?~  rec=(~(get by obs) binding)  %unknown
    =/  p-at  (attests p-side.u.rec delegate.binding)
    =/  d-at  (attests d-side.u.rec patron.binding)
    =/  p-de  (denies p-side.u.rec delegate.binding)
    =/  d-de  (denies d-side.u.rec patron.binding)
    ?:  &(p-at d-at)  %verified
    ?:  |(&(p-at d-de) &(d-at p-de))  %conflict
    ?:  |(p-at d-at)  %unconfirmed
    ?:  &(p-de d-de)  %none
    %pending
  ::  +state-of: verdict plus the raw record
  ::
  ++  state-of
    |=  =binding
    ^-  [=^verdict rec=(unit record)]
    [(verdict binding) (~(get by obs) binding)]
  ::  +all: verdicts for every tracked binding
  ::
  ++  all
    ^-  (map binding ^verdict)
    %-  ~(urn by obs)
    |=([=binding *] (verdict binding))
  ::  +keen: gall %keen for a ship's emissary namespace, latest-as-of-now.
  ::  never request a numeric revision you have not confirmed exists: a
  ::  keen for an unbindable case pends forever and can wedge the peer
  ::  flow.  %da cases are always answerable.
  ::
  ++  keen
    |=  [who=ship what=path]
    ^-  card
    :+  %pass  /emissary-observer/(scot %p who)/(scot %da now.bowl)
    [%keen %.n who (welp /g/x/(scot %da now.bowl)/emissary//1 what)]
  --
++  attests
  |=  [=side member=ship]
  ^-  ?
  &(?=(%answered stance.side) (~(has in ships.side) member))
++  denies
  |=  [=side member=ship]
  ^-  ?
  ?|  ?=(%absent stance.side)
      &(?=(%answered stance.side) !(~(has in ships.side) member))
  ==
--
