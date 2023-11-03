  ::  /sur/emissary
::::  Version ~2023.10.6
::    ~lagrev-nocfep
::
|%
+$  rank  ?(%galaxy %star %planet %moon %comet)
::
::  trigger = patron requests or revokes delegation
+$  trigger
  $%  [%designate =ship]
      [%revoke =ship]
  ==
::  request = over-the-wire request to a particular ship
+$  request  ?(%designate %revoke)
::  decide = delegate confirms or rejects delegation
+$  decide
  $%  [%accept =ship]
      [%reject =ship]
  ==
::  response = answer
+$  response  ?(%accept %reject)
::  status = current state of designation
+$  status
  $?  %pending
      %valid
      %rejected
      ::%revoked  ::  XX nice to have
  ==
::  demand scries
+$  demand
  $%  [%delegates p=(set ship)]
      [%patrons p=(set ship)]
      [%outgoing p=(set ship)]
      [%incoming p=(set ship)]
      [%delegate p=?]
      [%patron p=?]
  ==
--
