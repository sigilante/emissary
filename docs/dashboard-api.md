# `%emissary` Dashboard — Design Handoff & API Contract (v1)

**Audience:** designer/frontend agent redesigning the `%emissary` web dashboard.
**Backend status:** the JSON API below is the contract the desk will serve in `[1 6 0]`; mock against it freely. The action and state semantics are live today (server-rendered); the JSON encoding is what changes.

## 1. Product context

`%emissary` lets an Urbit point (the **patron**, typically a star) designate another point (the **delegate**, typically a planet) as its operating representative, and lets any third party (an **observer**) cryptographically verify that relationship by remote-scrying *both* sides. One desk serves all three roles; any ship may play several roles at once.

The dashboard replaces three server-rendered form pages (`/apps/emissary/patron`, `/delegate`, `/observer`) plus an index. The core redesign goals:

1. **Live state** — a delegate's acceptance should appear without manual refresh.
2. **An observer view worth demoing** — the "who vouches for whom" verification is the product's pitch; today it's a bare form.
3. **Verification legibility** — surface the both-sides-agree rule (§5) explicitly, with per-side timestamps and staleness.

## 2. Platform constraints

- Served **by the user's ship** at `/apps/emissary/…` behind Eyre session auth (cookie; unauthenticated requests get a redirect/401 — don't design a login page, Eyre owns it).
- **No external hosts.** All assets inline or same-origin. No CDN fonts/scripts.
- Prefer no build pipeline: hand-rolled JS + the ship's channel API (see §6). A compiled bundle is acceptable only if it globs into the desk.
- Must degrade gracefully on mobile (star operators check this from phones).
- Ship identity visuals: **sigil SVGs are rendered server-side** (`/lib/sigil`) and can be exposed at `GET /apps/emissary/api/v1/sigil/<ship>.svg` — the design can assume a sigil image URL per ship.
- Existing palette (keep or replace deliberately): `--black #38391f`, `--white #f7f1d2`, `--green #5dbf8d`, `--yellow #fed107`, `--red #f05826`; Urbit Sans / Urbit Serif faces are embedded in the desk.

## 3. Data API

All endpoints under `/apps/emissary/api/v1/`, same-origin, session-authenticated, JSON UTF-8. Ships are `@p` strings with leading sigil (`"~sampel-palnet"`). Timestamps are ISO-8601 UTC.

### `GET /apps/emissary/api/v1/state`

Full local state for the authenticated ship:

```json
{
  "ship": "~marzod",
  "delegates": { "~sampel-palnet": "valid", "~wicdev-wisryt": "pending" },
  "patrons":   [ "~zod" ],
  "incoming":  [ "~binzod" ],
  "queries": {
    "~zod": {
      "delegate": {
        "status": "valid",
        "timestamp": "2026-07-18T00:40:45Z",
        "ships": [ "~marzod" ]
      },
      "patron": {
        "status": "unknown",
        "timestamp": null,
        "ships": null
      }
    }
  },
  "keys": {
    "~zod":           { "life": 2, "rift": 0 },
    "~sampel-palnet": { "life": 3, "rift": 1 }
  }
}
```

- `keys` — jael-sourced `life` (key revision) and `rift` (breach count) for every ship appearing anywhere in the document. A rift bump means the ship breached, invalidating older attestations; the UI renders rift red when > 0 (added per the design review's life:rift treatment).

- `delegates` — ships this ship has designated, with per-ship status: `"pending" | "valid" | "rejected"`. (Patron role.)
- `patrons` — ships whose designation this ship has accepted. (Delegate role.)
- `incoming` — designation requests awaiting this ship's accept/reject decision. (Delegate role.)
- `queries` — observer results, keyed by target ship, then by question kind:
  - kind `"delegate"` = "who are `<target>`'s delegates?" → `ships` holds the target's delegate set.
  - kind `"patron"` = "who are `<target>`'s patrons?" → `ships` holds the target's patron set.
  - `status`: `"unknown"` (asked, no answer yet) | `"valid"` (answered; `ships` + `timestamp` set) | `"unasked-for"` (target answered with nothing bound — treat as *no relationship attested*).

### `POST /apps/emissary/api/v1/action`

Body is a single action object; responds `204` on acceptance (results arrive via the update stream, §6):

```json
{ "designate": { "ship": "~sampel-palnet" } }
{ "revoke":    { "ship": "~sampel-palnet" } }
{ "accept":    { "ship": "~zod" } }
{ "reject":    { "ship": "~zod" } }
{ "query":     { "kind": "delegate", "ship": "~zod" } }
```

Effects and expected UI treatment:

| action | precondition | immediate state change | settles when |
|---|---|---|---|
| `designate` | target not already `valid` | `delegates[ship] = "pending"` | target accepts/rejects → `"valid"`/`"rejected"` |
| `revoke` | target in `delegates` | entry removed | immediate |
| `accept` | ship in `incoming` | moved to `patrons` | immediate |
| `reject` | ship in `incoming` | removed | immediate |
| `query` | — | `queries[ship][kind].status = "unknown"` | remote answer → `"valid"`/`"unasked-for"`; **may never settle** if target is offline — show elapsed time, allow re-query |

### `GET /apps/emissary/api/v1/sigil/<ship>.svg`

Sigil for any `@p`, as SVG (galaxy/star/planet; moons/comets get a placeholder glyph).

## 4. Update stream

State changes stream over the ship's standard channel API (`/~/channel`, EventSource) as `%json` facts on subscription path `/web/state`. Every fact is a **full state document** identical to `GET …/state` (state is tiny — sets of ships — so no diff protocol is warranted). Reconnect/resubscribe on `quit`. Design assumption: any state you render can change underneath you within ~1s of a network event.

## 5. Verification semantics (observer view — the important part)

A delegation claim is **verified** only when *both* sides attest:

> `X` is a delegate of `P` ⟺ `queries[P]["delegate"].ships` contains `X` **and** `queries[X]["patron"].ships` contains `P`.

The dashboard should render the one-sided states honestly:

- both sides agree → **verified** (strongest visual)
- one side attests, other not yet queried / `unknown` → **unconfirmed** (prompt: query the other side)
- one side attests, other side answered without the counterpart → **conflict** (this is the interesting failure: revocation propagating, or a breach — flag it loudly)
- `unasked-for` on both → no relationship
- answers have **timestamps**; attestations are point-in-time, not subscriptions. Stale answers (design threshold: > 1 hour) should look stale and invite re-query.

A delegation graph or matrix over all queried ships is the desired centerpiece; per-ship drill-down secondary.

### QR / deep link

`GET /apps/emissary/observer?who=<ship>&what=<delegates|patrons>` pre-fills and fires the query on load. The QR code on a patron's page encodes that URL on the *observer's* ship? No — QR encodes the path + params only (relative), so any ship's dashboard can scan-and-verify against its own session. Design a "verify me" share/QR affordance on the patron and delegate views that emits this link/QR.

## 6. Non-goals for v1

- No pagination (sets are small: tens of ships).
- No history/audit log (revisions exist in the scry namespace but are not surfaced in v1).
- No moon/comet flows.
- No unauthenticated public status page (interesting later; requires Eyre `%serve` of an open endpoint — do not design around it yet).
