  ::  /lib/emissary
::::  Version ~2023.10.6
::    ~lagrev-nocfep
::
/-  *emissary
|%
::
++  ship-to-rank
  |=  =ship
  ^-  rank
  =/  clan  (clan:title ship)
  ?-  clan
    %czar  %galaxy
    %king  %star
    %duke  %planet
    %earl  %moon
    %pawn  %comet
  ==
::
++  rank-to-weight
  |=  =rank
  ^-  @
  ?-  rank
    %galaxy  0
    %star    1
    %planet  2
    %moon    3
    %comet   4
  ==
::
++  is-supra
  |=  [p=ship q=ship]
  ^-  ?
  (lth (rank-to-weight (ship-to-rank p)) (rank-to-weight (ship-to-rank q)))
::
++  is-infra
  |=  [p=ship q=ship]
  ^-  ?
  (gth (rank-to-weight (ship-to-rank p)) (rank-to-weight (ship-to-rank q)))
::
--
