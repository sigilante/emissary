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
  $?  %pending      ::  for trigger
      %valid        ::  for response/demand
      %rejected     ::  for response/demand
      %unasked-for  ::  for query
      %unknown      ::  for query
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
::  queries
::  (~(has by (~(has by queries) ~zod) %patron))
::  (~(has bi queries) ~zod %patron)
::  ->  [%valid ~2023.11.7 [~ {~zod ~bud ~nec}]]
::  ->  [%unknown ~2023.11.7 ~]
+$  kind  ?(%patron %delegate)
+$  quests  (map kind quest)
+$  queries  (map ship quests)
+$  query  [=kind =ship]
+$  quest  [=status timestamp=@da ships=(unit (set ship))]
--
