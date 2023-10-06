  ::  /sur/emissary
::::  Version ~2023.10.6
::    ~lagrev-nocfep
::
|%
+$  rank  ?(%galaxy %star %planet %moon %comet)
::
::  trigger = on star, start action to inferior point
+$  trigger
  $%  [%designate =ship]
      [%revoke =ship]
  ==
::  action = superior point to inferior point
+$  action
  $%  [%designate ~]
      [%revoke ~]
  ==
::  response = confirmation or rejection from poke or front-end
+$  response
    $%  [%accept =ship]
        [%reject =ship]
    ==
::  answer = confirmation/acknowledgement
+$  answer
  $%  [%accept ~]
      [%reject ~]
  ==
::  status = current state of designation
+$  status
  $?  %pending
      %valid
      %rejected
      ::%revoked
  ==
::  demand scries
+$  demand
  $%  [%delegates p=(set ship)]
      [%patrons p=(set ship)]
      [%delegate p=?]
      [%patron p=?]
  ==
--
