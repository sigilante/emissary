# `%herald`

Verified announcement feeds over `%emissary` delegation — and the
reference consumer of `/lib/emissary-observer`.

An **author** (a delegate planet) posts as a **voice** (its patron
star or galaxy). Followers receive posts over ordinary Gall
subscriptions, and `%herald` verifies the delegation through the
observer library: **the mark on a post is live** — computed from
both-sides remote-scry attestations at render time, it holds only
while patron and delegate both attest. Revoke the delegation and
every follower's checkmark dies on their next refresh.

## Usage

Both author and followers install the desk (and the author's voice
must run `%emissary`, since verification reads its published
attestations):

```
:herald|post ~marzod 'The star ~marzod announces...'   :: as author
:herald|follow ~sampel-palnet                          :: as follower
:herald|refresh                                        :: re-verify all
:herald|unfollow ~sampel-palnet
```

The inbox is served at `/apps/herald` (session-authenticated,
auto-refreshing). Marks: `✓` verified (green), `✕` conflict or no
delegation (red), `~` unconfirmed (gold), `·` verifying.

Scries:

```
.^(* %gx /=herald=/inbox/noun)      :: received posts
.^(* %gx /=herald=/feed/noun)       :: our published posts
.^(* %gx /=herald=/verdicts/noun)   :: (map binding verdict)
```

## Security model

- A post's *transport* is authenticated by Ames: a `%fact` is
  accepted only if `author` equals the subscription source, so
  authors cannot be forged in transit.
- A post's *authority* is the delegation: `%herald` never trusts the
  author's claim to speak for the voice. It remote-scries both the
  voice's published delegate set and the author's published patron
  set and requires them to agree. Attestations are point-in-time;
  `:herald|refresh` (or any page load) re-derives the verdict.

## Using the library in your own agent

`/lib/emissary-observer` is standalone (no `/-` or `/+`); vendor the
one file. Integration is ~15 lines:

```hoon
/+  eo=emissary-observer
::  in your state:        =obs:eo
::  to verify a binding:  =^  cards  obs  (~(start go:eo obs bowl) [patron delegate])
::  route signs back in:  ?:  ?=([%emissary-observer *] wire)
::                          ?>  ?=([%ames %sage *] sign-arvo)
::                          `this(obs (~(take go:eo obs bowl) +>.sign-arvo))
::  read a verdict:       (~(verdict go:eo obs bowl) [patron delegate])
```

Verdicts: `%verified` (both attest) / `%conflict` (one attests, one
denies) / `%unconfirmed` (one attests, one unanswered) / `%none`
(both deny) / `%pending` / `%unknown`. `+refresh` re-verifies
everything older than a given age; `+forget` stops tracking. The
library only issues fully-qualified `%da`-case requests and cancels
superseded or abandoned keens with `%yawn` — a pending interest that
can never resolve can wedge a peer's peek flow.
