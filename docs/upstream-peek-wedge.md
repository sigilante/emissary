# Draft upstream report: namespace peek flows wedge permanently after unresolvable or churned keens

**Target:** urbit/urbit issues. Status: draft — not yet filed.
**Environment:** urbit runtime 4.6 (canonical release binary, macOS arm64), zuse 408 (urbit-v4.6.pill from bootstrap.urbit.org), fake ships on loopback.

## Summary

Remote scries of a Gall agent's `%grow` namespace (`%keen` → `%sage`)
between fake ships stop resolving — permanently — for specific peer
pairs, while pokes/subscriptions between the same pair continue to work.
Once wedged, the pair's peek flow does not recover after: agent `|nuke`
+ `|revive` on the requester, restart of either runtime, `|hi`
(re-established poke contact), `%yawn` attempts from a different duct,
or even **a full pier rebuild of the requesting ship** (same identity;
suggests the server side holds the poisoned state). Fresh ship pairs
performing the identical operations work correctly, including through
cull/republish cycles on the publisher.

## Two apparent triggers

1. **Unresolvable keens.** A `%keen` for a case that can never be
   bound (observed with `%ud` revision `0`; farm numbering starts
   at 1) registers a pending interest that never resolves. After a
   pair has exchanged such keens (and subsequently migrated
   fine→mesa), later well-formed peeks between that pair hang.

2. **Keen/cull churn.** A publisher that repeatedly grows and culls
   revisions of the same paths while serving `%da`-case peeks
   eventually stops answering peeks from established peers — new
   requesters at that point still succeed, then wedge in turn after
   further cycles. Observed sequence: peer A resolves a peek; the
   publisher culls + regrows (revision n → n+1); peer A's next peek
   (fresh `%da` case, later than the new revision's bind time) never
   resolves. Local scries of the same path on the publisher, and the
   publisher's `%gw` revision state, remain correct throughout.

## Repro sketch (fake ships)

1. Boot fakezod + fakenec + fakebud (runtime 4.6 / 408k pill).
   Install a desk whose agent `%grow`s a path and serves it publicly.
2. From bud: `%pass ... %arvo %a %keen ~ [~zod /g/x/0/<desk>//1/<path>]`
   (revision 0 — unbindable). Interest pends forever.
3. From bud, issue a well-formed `%da`-case keen for the same path:
   works initially (over fine), then after mesa migration, all
   bud→zod gall-namespace peeks hang. Clay peeks
   (`/c/x/1/kids/sys/kelvin`) from the same pair still resolve.
4. On zod, cycle the binding (grow/cull/grow) several times while a
   second peer (dev) peeks between cycles: dev's peeks eventually
   stop resolving as well. Pokes (`|hi`) succeed throughout.

## Evidence available

Five piers preserved in the wedged state (three peers wedged against
the same publisher: bud→zod, dev→zod, wes→zod; healthy control pair
wes↔dev; healthy delegate nec↔zod for pokes). Sequence of operations
reproducible via scripted harness. Happy to provide piers, event
logs, or run instrumented builds.

## Suspected area

Interaction between pending peek interests (fine-era and/or mesa
`chums` state) and the publisher-side serve path for `%da`-case gall
namespace reads across cull/regrow cycles; possibly stale
pending-interest entries poisoning the per-peer flow. The
requester-side `%yawn` task cannot clear interests created by a
since-nuked agent (duct mismatch), and nothing appears to clear the
server-side registration for a culled, never-bindable case.

## Workarounds adopted in userspace

- Never emit a keen whose case is not certain to be bindable
  (`%da` cases only; farm revisions number from 1).
- `%yawn` superseded/abandoned keens from the requesting duct.
- For demos/CI: fresh piers.
