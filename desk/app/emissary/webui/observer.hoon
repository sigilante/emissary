  ::  %emissary observer home page
::::
::
/-  *emissary
/+  rudder, sigil-svg=sigil
::
^-  (page:rudder [(set ship) (map ship status) (set ship) (map query quest)] ?(trigger decide query))
|_  [=bowl:gall * [patrons=(set ship) delegates=(map ship status) requests=(set ship) queries=(map query quest)]]
++  argue
  |=  [headers=header-list:http body=(unit octs)]
  ^-  $@(brief:rudder query)
  =/  args=(map @t @t)
    ?~(body ~ (frisk:rudder q.u.body))
  ?~  what=(~(get by args) 'what')
    ~
  ?~  who=(slaw %p (~(gut by args) 'who' ''))
    ~
  ?+    u.what  ~
      %patrons
    [%patron u.who]
    ::
      %delegates
    [%delegate u.who]
  ==
::
++  final  (alert:rudder :((cury cat 3) '/apps/' dap.bowl '/observer') build)
::
++  build
  |=  $:  arg=(list [k=@t v=@t])
          msg=(unit [o=? =@t])
      ==
  ^-  reply:rudder
  |^  [%page page]
  ::
  ++  style
    '''
    body, html {
        font-family: 'Urbit Sans TT SemiBold', sans-serif;
        height: 100%;
        width: 100%;
        margin: 0;
    }
    body {
        display: flex;
        flex-direction: column;
        align-items: center;
        justify-content: center;
    }
    body > div {
        max-width: 320px;
        width: 100%;
    }

    code { font-family: Urbit Sans Mono TT SemiBold, monospace; }

    form { margin: 0.2em; padding: 0.2em; }

    .red { font-weight: bold; color: #dd2222; }
    .green { font-weight: bold; color: #229922; }

    a {
      display: inline-block;
      color: inherit;
      padding: 0;
      margin-top: 0;
    }

    table {
        width: 80%;
    }

    tr:first-of-type {
        font-weight: 700;
        color: #918C84;
    }

    .sigil {
      display: inline-block;
      vertical-align: middle;
      margin: 0 0.5em 0 0;
      padding: 0.2em;
      border-radius: 0.2em;
    }

    .sigil * {
      margin: 0;
      padding: 0;
    }

    .label {
      display: inline-block;
      background-color: #ccc;
      border-radius: 3px;
      margin-right: 0.5em;
      padding: 0.1em;
    }

    .label input[type="text"] {
      max-width: 100px;
    }

    .label span {
      margin: 0 0 0 0.2em;
    }

    button {
      padding: 0.2em 0.5em;
    }

    .index-btn {
      background-color: #2222dd;
      border-radius: 5px;
      color: white;
      padding: 15px 32px;
      display: inline-block;
    }
    '''
  ::
  ++  page
    ^-  manx
    ;html
      ;head
        ;title:"%emissary"
        ;meta(charset "utf-8");
        ;meta(name "viewport", content "width=device-width, initial-scale=1");
        ;style:"{(trip style)}"
      ==
      ;body
        ;h1:"%emissary"
        ;h2:"observer portal"

        `%emissary` allows a star to designate a planet as its representative.
        This is tied to an operating star, not to ownership on Azimuth.

        This observer portal allows you to query the status of a patron or a
        delegate.

        ;a(href "/apps/emissary/index", class "index-btn"):"back to index"

        ;table
          ;form(method "post")
            ;tr(style "font-weight: bold")
              ;td:"sigil"
              ;td:"@p"
              ;td:"status"
            ==
            ;tr
              ;td:""
              ;td
                ;input(type "text", name "who", placeholder "~sampel-palnet");
              ==
              ;td
                ;button(type "submit", name "what", value "patrons"):"patrons?"
              ==
              ;td
                ;button(type "submit", name "what", value "delegates"):"delegates?"
              ==
            ==
          ==
          ;*  valids
          ;*  unaskeds
          ;*  unknowns
        ==
      ==
    ==
  ::
  ++  canceller
    |=  =ship
    ^-  manx
    ;form(method "post")
      ;input(type "hidden", name "who", value "{(scow %p ship)}");
      ;button(type "submit", name "what", value "cancel"):"×"
    ==
  ::
  ++  peers
    |=  [=status pez=(list [query quest])]
    ^-  (list manx)
    %+  turn  pez
    |=  [=query =quest]
    ^-  manx
    ;tr
      ;td
        ;+  (sigil ship.query)
      ==
      ;td
        ; {(scow %p ship.query)}
      ==
      ;+  ?:  ?=(%valid status.quest)
            ?:  ?=(%patron kind.query)
              ;td:"valid patron {<timestamp.quest>}"
            ;td:"valid delegate {<timestamp.quest>}"
          ?:  ?=(%unasked-for status.quest)
            ?:  ?=(%patron kind.query)
              ;td:"unrequested patron {<timestamp.quest>}"
            ;td:"unrequested delegate {<timestamp.quest>}"
          ?>  ?=(%unknown status.quest)
            ?:  ?=(%patron kind.query)
              ;td:"unrequested patron {<timestamp.quest>}"
            ;td:"unrequested delegate {<timestamp.quest>}"
    ==
  ::
  ++  valids
    ^-  (list manx)
    %+  peers  %valid
    %+  skim  (sort ~(tap by queries) dor)
    |=  [=query =quest]
    ?:(=(%valid status.quest) & |)
  ::
  ++  unaskeds
    ^-  (list manx)
    %+  peers  %unasked-for
    %+  skim  (sort ~(tap by queries) dor)
    |=  [=query =quest]
    ?:(=(%unasked-for status.quest) & |)
  ::
  ++  unknowns
    ^-  (list manx)
    %+  peers  %unknown
    %+  skim  (sort ~(tap by queries) dor)
    |=  [=query =quest]
    ?:(=(%unknown status.quest) & |)
  ::
  ++  sigil
    |=  =ship
    ^-  manx
    =/  bg=@ux  (cut 2 [1 6] (add ship eny.bowl))
    =/  fg=tape
      =+  avg=(div (roll (rip 3 bg) add) 3)
      ?:((gth avg 0xc1) "black" "white")
    =/  bg=tape
      ((x-co:co 6) bg)
    ;div.sigil(style "background-color: #{bg}; width: 40px; height: 40px;")
      ;img@"/apps/emissary/sigil.svg?p={(scow %p ship)}&fg={fg}&bg=%23{bg}&icon&size=40";
    ==
  ::
  --
--
