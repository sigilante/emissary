::  /sur/herald
::::  Verified announcement feeds over %emissary delegation.
::
::    A post is written by an author (a delegate) speaking as a
::    voice (its patron).  Subscribers verify the voice through
::    /lib/emissary-observer: the mark on a post is live — it holds
::    only while both sides of the delegation attest.
::
|%
+$  post
  $:  voice=ship     ::  the patron being spoken for
      author=ship    ::  the delegate that wrote it
      body=@t
      sent=@da
  ==
+$  action
  $%  [%post voice=ship body=@t]   ::  publish (author = our ship)
      [%follow =ship]              ::  subscribe to an author's feed
      [%unfollow =ship]
      [%refresh ~]                 ::  re-verify all tracked bindings
  ==
+$  update
  $%  [%post =post]
  ==
--
