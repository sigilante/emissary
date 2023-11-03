  ::  %emissary home page
::::
::
/-  *emissary
/+  rudder, sigil-svg=sigil
::
^-  (page:rudder [(set ship) (map ship status) (set ship)] [?(trigger decide)])
|_  [=bowl:gall * [patrons=(set ship) delegates=(map ship status) requests=(set ship)]]
++  argue  !!
++  final  !!
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
      display: inline;
    }

    .patron-btn {
      background-color: #229922;
      border-radius: 5px;
      color: white;
      padding: 15px 32px;
      display: inline-block;
    }

    .delegate-btn {
      background-color: #dd2222;
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

        `%emissary` allows a star to designate a planet as its representative.
        This is tied to an operating star, not to ownership on Azimuth.

        Are you acting as a patron or a delegate from this point today?

        ;a(href "/apps/emissary/patron", class "patron-btn"):"patron"
        ;a(href "/apps/emissary/delegate", class "delegate-btn"):"delegate"
      ==
    ==
  ::
  ++  revoker
    |=  =ship
    ^-  manx
    ;form(method "post")
      ;input(type "hidden", name "who", value "{(scow %p ship)}");
      ;button(type "submit", name "what", value "revoke"):"×"
    ==
  ::
  ++  peers
    |=  [=status pez=(list [ship status])]
    ^-  (list manx)
    %+  turn  pez
    |=  [=ship =^status]
    ^-  manx
    ;tr
      ;td
        ;+  (sigil ship)
      ==
      ;td
        ; {(scow %p ship)}
      ==
      ;+  ?:  ?=(%valid status)
            ;td
              ;+  (revoker ship)
            ==
          ?:  ?=(%pending status)
            ;td
              ;+  (revoker ship)
            ==
          ?>  ?=(%rejected status)
          ;td
            ;p.red:"rejected"
          ==
    ==
  ::
  ++  valids
    ^-  (list manx)
    %+  peers  %valid
    %+  skim  (sort ~(tap by delegates) dor)
    |=  [=ship =status]
    ?:(=(%valid status) & |)
  ::
  ++  pendings
    ^-  (list manx)
    %+  peers  %pending
    %+  skim  (sort ~(tap by delegates) dor)
    |=  [=ship =status]
    ?:(=(%pending status) & |)
  ::
  ++  rejecteds
    ^-  (list manx)
    %+  peers  %rejected
    %+  skim  (sort ~(tap by delegates) dor)
    |=  [=ship =status]
    ?:(=(%rejected status) & |)
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
