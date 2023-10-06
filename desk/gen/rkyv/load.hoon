/-  *rkyv
:-  %say
|=  [* [=path ~] *]
:-  %rkyv-batch
:-  %create-many
|^
?~  path  !!
=/  files   .^((list ^path) %ct path)
=/  paths   (turn files |=(file=^path `^path`:(weld ~[&1:path] ~[&2:path] ~[&3:path] file)))
=/  values  `(list value)`(turn paths path-to-file)
=/  keys    `(list key)`(strip-keys files)
`(list (pair key value))`(zip keys values)
++  path-to-term
  |=  =^path
  ^-  @tas
  =|  =tape
  |-
  ?~  path  (crip (scag (sub (lent tape) 6) tape))
  $(path t.path, tape :(weld tape (trip i.path) "-"))
++  path-to-file
  |=  =^path
  ^-  value
  :-  %txt
  (of-wain:format .^(wain %cx path))
++  zip
  |=  [lhs=(list term) rhs=(list value)]
  ^-  (list (pair key value))
  =|  kv=(list (pair key value))
  |-  ^-  (list (pair key value))
  ?~  lhs  (flop kv)
  ?~  rhs  (flop kv)
  $(lhs t.lhs, rhs t.rhs, kv [[i.lhs i.rhs] kv])
++  strip-keys
  |=  =(list ^path)
  ^-  (^list key)
  =|  keys=(^list key)
  |-
  ?~  list  (flop keys)
  =/  key  `term`(snag (dec (dec (lent i.list))) i.list)
  $(list t.list, keys [key keys])
--
