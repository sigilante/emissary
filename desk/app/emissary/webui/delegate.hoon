  ::  %emissary delegate home page
::::
::
/-  *emissary
/+  rudder, sigil-svg=sigil
::
^-  (page:rudder [(set ship) (map ship status) (set ship)] [trigger])
|_  [=bowl:gall * [patrons=(set ship) delegates=(map ship status) requests=(set ship)]]
++  argue
  |=  [headers=header-list:http body=(unit octs)]
  ^-  $@(brief:rudder trigger)
  =/  args=(map @t @t)
    ?~(body ~ (frisk:rudder q.u.body))
  ?~  what=(~(get by args) 'what')
    ~
  ?~  who=(slaw %p (~(gut by args) 'who' ''))
    ~
  ?+    u.what  ~
      %accept
    [%accept u.who]
    ::
      %reject
    [%reject u.who]
  ==
::
++  final  (alert:rudder :((cury cat 3) '/apps/' dap.bowl '/delegate') build)
::
++  build
  |=  $:  arg=(list [k=@t v=@t])
          msg=(unit [o=? =@t])
      ==
  ^-  reply:rudder
  |^  [%page page]
  ::
  ++  icon-color  "black"
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
        ;h2:"delegate portal"

        `%emissary` allows a star to designate a planet as its representative.
        This is tied to an operating star, not to ownership on Azimuth.

        This delegate portal allows you to review, accept, or reject delegation
        to you from a star.

        Your current patrons are:

        ;table#pals
          ;form(method "post")
            ;tr(style "font-weight: bold")
              ;td:"sigil"
              ;td:"@p"
              ;td:"action"
            ==
            ;tr
              ;td:""
              ;td
                ;input(type "text", name "who", placeholder "~sampel-palnet");
              ==
              ;td
                ;button(type "submit", name "what", value "reject"):"✗"
              ==
            ==
          ==
          ;*  patronizeds
        ==

        Your outstanding requests are:

        ;table#pals
          ;form(method "post")
            ;tr(style "font-weight: bold")
              ;td:"sigil"
              ;td:"@p"
              ;td:"action"
            ==
            ;tr
              ;td:""
              ;td
                ;input(type "text", name "who", placeholder "~sampel-palnet");
              ==
              ;td
                ;button(type "submit", name "what", value "accept"):"✓"
                ;button(type "submit", name "what", value "reject"):"✗"
              ==
            ==
          ==
          ;*  awaiteds
        ==
      ==
    ==
  ::
  ++  accepter
    |=  =ship
    ^-  manx
    ;form(method "post")
      ;input(type "hidden", name "who", value "{(scow %p ship)}");
      ;button(type "submit", name "what", value "accept"):"✓"
    ==
  ::
  ++  rejecter
    |=  =ship
    ^-  manx
    ;form(method "post")
      ;input(type "hidden", name "who", value "{(scow %p ship)}");
      ;button(type "submit", name "what", value "reject"):"✗"
    ==
  ::
  ++  awaiteds
  ^-  (list manx)
  %-  peers-consider
  (sort ~(tap in requests) dor)
  ::
  ++  patronizeds
  ^-  (list manx)
  %-  peers-rejecter
  (sort ~(tap in patrons) dor)
  ::
  ++  peers-consider
    |=  pez=(list ship)
    ^-  (list manx)
    %+  turn  pez
    |=  =ship
    ^-  manx
    ;tr
      ;td
        ;+  (sigil ship)
      ==
      ;td
        ; {(scow %p ship)}
      ==
      ;td
        ;+  (accepter ship)
        ;+  (rejecter ship)
      ==
    ==
  ::
  ++  peers-rejecter
    |=  pez=(list ship)
    ^-  (list manx)
    %+  turn  pez
    |=  =ship
    ^-  manx
    ;tr
      ;td
        ;+  (sigil ship)
      ==
      ;td
        ; {(scow %p ship)}
      ==
      ;td
        ;+  (rejecter ship)
      ==
    ==
  ::
  ++  sigil
    |=  =ship
    ^-  manx
    =/  bg=@ux  (cut 2 [1 6] eny.bowl)
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
