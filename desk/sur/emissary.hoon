  ::  /sur/emissary
::::  Version ~2023.10.6
::    ~lagrev-nocfep
::
|%
+$  rank  ?(%galaxy %star %planet %moon %comet)
::
::  trigger = on star, start action to inferior point
::            on planet, confirmation or rejection of delegation
+$  trigger
  $%  [%designate =ship]
      [%revoke =ship]
      [%accept =ship]
      [%reject =ship]
  ==
::  response = answer
+$  response
  $%  [%designate =ship]
      [%revoke =ship]
      [%accept =ship]
      [%reject =ship]
  ==
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
      [%requests p=(set ship)]
      [%delegate p=?]
      [%patron p=?]
  ==
--
