# Handoff: %emissary Dashboard

## Overview
The %emissary dashboard is the redesigned web front-end for an Urbit desk that lets a **patron** (typically a star) designate a **delegate** (typically a planet) as its operating representative, and lets any **observer** cryptographically verify that relationship by remote-scrying both sides. One desk serves all three roles; any ship may play several at once.

The dashboard replaces three server-rendered form pages (`/apps/emissary/patron`, `/delegate`, `/observer`) plus an index. Its three redesign goals:
1. **Live state** — a delegate's acceptance appears without manual refresh (updates stream over the ship's channel API).
2. **An observer view worth demoing** — the "who vouches for whom" verification is the product pitch; it is the visual centerpiece.
3. **Verification legibility** — the both-sides-agree rule is surfaced explicitly, with per-side timestamps, staleness, and life:rift keys.

## About the Design Files
The files in this bundle are **design references created in HTML** — a prototype showing the intended look and behavior, **not production code to copy directly**. They are authored as "Design Components" (a streaming `.dc.html` format) and use a small runtime (`support.js`) plus CDN fonts purely for prototyping.

The task is to **recreate these designs inside the actual %emissary desk** using its real constraints (see Platform Constraints below): hand-rolled JS + the ship's channel API, all assets inline/same-origin, no CDN, no build pipeline preferred. Do not ship the `.dc.html` files. If you adopt a framework, it must glob cleanly into the desk.

## Fidelity
**High-fidelity (hifi).** Final colors, typography, spacing, layout, interaction states, and the full state machine are specified here and in the prototype. Recreate the UI to match, substituting the desk's embedded fonts (Urbit Sans / Urbit Serif) for the prototype's CDN fonts (see Typography).

## Platform Constraints (hard requirements from the spec)
- Served by the user's ship at `/apps/emissary/…` behind **Eyre session auth** (cookie). Unauthenticated requests get a redirect/401 — **do not build a login page**, Eyre owns it.
- **No external hosts.** All assets inline or same-origin. No CDN fonts/scripts.
- **Prefer no build pipeline**: hand-rolled JS + the ship's channel API. A compiled bundle is acceptable only if it globs into the desk.
- Must **degrade gracefully on mobile** (star operators check this from phones).
- Sigil SVGs are rendered server-side and exposed at `GET /apps/emissary/api/v1/sigil/<ship>.svg` — use that URL per ship (the prototype draws geometric placeholders instead).

## Screens / Views
This is a **single-page dashboard**, one scrolling column, max-width 1240px, centered, on a dark blueprint-grid ground. Three stacked regions:

### 1. Header
- **Purpose**: identity + connection status.
- **Layout**: flex row, space-between, wraps on narrow. Bottom border `1px solid rgba(247,241,210,.28)`.
- **Left**: wordmark `%emissary` (the `%` in gold `#fed107`) in Space Mono 30px, with a `v1` tag in gold 11px beside it; a subtitle line under it — `DELEGATION & REMOTE-SCRY VERIFICATION DESK`, Jost, 11px, uppercase, letter-spacing .22em, color `rgba(247,241,210,.6)`.
- **Right**: a `LIVE · /web/state` indicator (green `#5dbf8d` 8px dot, blinking at 1.5s, + mono 11px green label), then a bordered identity chip: 30px sigil + `~marzod` (Space Mono 13px) + `THIS SHIP · STAR` (Jost 9.5px uppercase, letter-spacing .18em).

### 2. Observer · Verification Field  (CENTERPIECE)
Wrapped in a Panel (see Components → Panel). Panel tag text: `OBS-01 / both-sides-agree`.

- **Query bar** (flex row, wraps): label `SCRY →`; a ship text input with a leading `~` prefix and underline-only border; a two-button segmented toggle **delegates / patrons**; a solid-gold **RUN SCRY** button; a spacer; and a right-aligned **graph / matrix** view toggle.
- **Body** splits into two columns (flex, wrap, gap 26px):
  - **Left — the visualization** (`flex:1 1 520px`):
    - **Graph view** (default): a circular node-link schematic in a 600×460 SVG coordinate space (container uses `aspect-ratio:600/460`, max-width 600px, centered). Ships are placed on a circle (radius 165 around center 300,220). Each **node** is an absolutely-positioned box (solid `#2f3019` fill, `1px solid #f7f1d2` border, 5×8px padding) containing a 20px sigil + the `@p` in Space Mono 10.5px, centered on its point via `translate(-50%,-50%)`. **Edges** are directed `patron → delegate`, drawn as SVG lines; the line style encodes verification state (see Verification States). Each edge has a **hollow square at the patron end** and a **filled dot at the delegate end** (both colored to the edge state). A transparent 16px-wide line sits over each edge as the click target (select that binding). Endpoints are pulled 44px in from node centers so markers sit at node edges; opposite-direction edges are offset ±6px perpendicular so they don't overlap. Selected edge gets +1.2 width and a translucent gold halo (`rgba(254,209,7,.35)`, 10px).
    - **Matrix view** (toggle): a grid over all queried ships. Corner caption `delegate → / patron ↓`. Column headers are the `@p`s rotated −45°, Space Mono 9px. Each cell is 38×38px; rows are keyed by patron (row = P), columns by delegate (col = X); the cell shows the state of "X is a delegate of P". Cell glyphs/colors per Verification States. The diagonal (P==X) is an inert 45° hatch. Selected cell gets a `0 0 0 2px #fed107` ring. Horizontal scroll on overflow.
    - **Legend** (below both views, dashed top border): line samples for verified / unconfirmed / conflict, plus the patron-square and delegate-dot markers. Space Mono 10px.
  - **Right — drill-down** (`flex:1 1 300px`, dashed left border, 26px left padding):
    - Header `SELECTED BINDING` (Space Mono 10px) + `~binzod ▸ ~sampel-palnet` (Space Mono 16px, gold `▸`).
    - **Verdict banner**: `1.5px solid` box in the state color, a square swatch + the verdict word (Jost uppercase 14px 600, letter-spacing .2em, in the state color), and a description line (12.5px, `rgba(247,241,210,.85)`).
    - **Two attestation rows** (patron-side, then delegate-side). Each: a 26px square mark box (`1px solid` + colored glyph — `✓` attests / `✕` answered-without / `?` not queried), then the claim title (`P → X`, Space Mono 11.5px), a role caption (Jost 9.5px uppercase), the status sub-line (`attests · 5m ago` / `answered — no such binding · …` / `not queried yet`), a **keys line** (`<ship> keys · life N · rift N`, Space Mono 9.5px, rift red when >0), and — when that side isn't attesting — a `scry <ship> ▸ <kind>s` button.

### 3. Patron + Delegate panels (two-column grid, `minmax(320px,1fr)`, gap 22px)

- **Patron · Your Delegates** (Panel tag `PAT-02`):
  - A designate row: `~`-prefixed underline input (`designate a ship…`) + an outlined-gold **DESIGNATE** button.
  - A list of designated delegates. Each row: 26px sigil + `@p` (Space Mono 12.5px) + a **life:rift badge** (`life N · rift N`, rift red when >0) + a status chip (`VALID` green / `PENDING` gold / `REJECTED` red, outlined) + a **revoke** button (hover → red).
  - Empty state: `no delegates designated.`
  - A full-width dashed **⧉ VERIFY ME — SHARE / QR** button that expands to show a QR (rendered on a cream `#f7f1d2` field) + the relative deep-link (`/apps/emissary/observer?who=~marzod&what=delegates`) in gold Space Mono, with an explainer line.

- **Delegate · Incoming & Patrons** (Panel tag `DEL-03`):
  - Section label `INCOMING DESIGNATION REQUESTS`. Each row: 26px sigil + `@p` + life:rift badge + **accept** (green) + **reject** (red) buttons. Empty state: `no pending requests.`
  - Section label `SHIPS YOU REPRESENT`. Each row: sigil + `@p` + life:rift badge + a `patron` chip (green outline). Empty state: `no patrons.`

- **Footer line** (centered, Space Mono 10px, `rgba(247,241,210,.4)`): `/apps/emissary/api/v1 · session-authenticated · updates stream on /web/state · re-subscribe on quit`.

- **Toast** (fixed, bottom-center): `#2f3019` box, `1px solid` in the event color, an 8px dot + Space Mono 12px message. Slides up 10px over .22s. Auto-dismisses after 3.4s.

## Components

### Panel (reusable frame)
`position:relative; border:1px solid rgba(247,241,210,.34); padding:20px 22px 22px; background:rgba(247,241,210,.014)`. Four **gold registration corner ticks** (13×13px, `2px solid #fed107`, one per corner, offset −1px). Header row: title (Jost uppercase 12.5px 500, letter-spacing .24em, cream) left / tag (Space Mono 10px, gold) right, with a `1px solid rgba(247,241,210,.22)` bottom rule and 16px gap to content.

### Sigil (placeholder — replace with server SVG)
The prototype draws a `1px solid rgba(247,241,210,.6)` square with a geometric mark classified by @p length: **galaxy** (≤3 chars, no dash) = filled gold diamond; **star** (no dash) = cream diamond outline; **planet** (one dash) = cream square outline. Plus two gold corner ticks. **In production, replace entirely with** `<img src="/apps/emissary/api/v1/sigil/<ship>.svg">`.

### Buttons
- **Primary (RUN SCRY)**: solid `#fed107`, text `#2f3019`, Jost 11px uppercase 600, letter-spacing .16em, 7×16px. Hover → transparent bg, gold text.
- **Outlined (designate, side scry)**: transparent, `1px solid` (gold or `rgba(247,241,210,.4)`), matching text. Hover fills.
- **Segmented toggle (delegates/patrons, graph/matrix, kind)**: container `1px solid rgba(247,241,210,.4)`; active segment `#f7f1d2` bg / `#2f3019` text; inactive transparent / `rgba(247,241,210,.7)`. Jost 11px uppercase.
- **Accept** green outline (hover fills green), **reject/revoke** red outline (hover fills/red text).

### Inputs
Transparent, no box; **underline only** (`1px solid rgba(247,241,210,.45)` on the wrapper). Space Mono cream text, placeholder `rgba(247,241,210,.35)`. A dimmed `~` prefix sits inside the underline. Enter submits (query / designate).

## Verification States (the core rule)
A delegation claim `X is a delegate of P` is **verified only when both sides attest**:
> `queries[P].delegate.ships` contains `X` **AND** `queries[X].patron.ships` contains `P`.

| State | When | Edge (graph) | Cell (matrix) | Color |
|---|---|---|---|---|
| **verified** | both attest | solid line, width 2.4 | `✓` | green `#5dbf8d` |
| **unconfirmed** | one attests, other unknown / not queried | dashed line (`6 5`), width 1.8 | `~`, dashed border | gold `#fed107` |
| **conflict** | one attests, other **answered without** the counterpart | bold solid line, width 3.2 | `✕`, `2px` border | red `#f05826` |
| **no relationship** | neither attests (both answered empty) | not drawn | `·`, faint | `rgba(247,241,210,.55)` |

- Attestations are **point-in-time, not subscriptions**. Answers carry timestamps; anything **older than 1 hour is stale** and should read `STALE` + invite re-query.
- **life:rift keys** contextualize conflicts: a **rift** bump means the ship breached (factory reset), which invalidates older attestations. In the prototype `~sampel-palnet` is at rift 1, which is why the `~binzod ▸ ~sampel-palnet` binding is a conflict — the verdict text names the breached ship. Surface `life:rift` on every ship (list rows + drill-down keys line); render rift red when > 0.
- The conflict case is "the interesting failure" — **flag it loudly** (reddest treatment) and default the drill-down to it on load in the demo.

## Interactions & Behavior
- **View toggle**: graph ↔ matrix, shared `selPair` selection.
- **Select a binding**: click any graph edge (via its transparent hit-line) or matrix cell → sets `selPair {p, x}` → drill-down re-renders.
- **query / RUN SCRY**: `POST action {query:{kind, ship}}`. Immediately set `queries[ship][kind].status = "unknown"` (spinner/elapsed), toast. Answer arrives via the update stream → `valid` (ships + timestamp) or `unasked-for`. **May never settle** if the target is offline — show elapsed time and allow re-query.
- **designate**: `POST {designate:{ship}}`. Immediately `delegates[ship] = "pending"`, toast. Settles to `valid`/`rejected` when the target accepts/rejects — **arrives via the stream, no refresh** (prototype simulates a ~2.6s accept).
- **revoke**: `POST {revoke:{ship}}` → entry removed immediately.
- **accept / reject** (on incoming): `POST {accept|reject:{ship}}` → moved to `patrons` / removed immediately.
- **verify-me**: toggles a QR + relative deep-link. The QR encodes **path + params only** (relative) so any ship's dashboard can scan-and-verify against its own session.
- **Live stream**: subscribe to `/web/state`; every fact is a **full state document** identical to `GET …/state` (no diff protocol). **Reconnect/resubscribe on quit.** Assume anything on screen can change within ~1s of a network event. (Prototype injects a live incoming request ~9s after load to demo this.)
- **Animations**: live dot blink 1.5s; toast slide-up .22s ease-out; keep motion minimal/technical.
- **Responsive**: header wraps; observer columns stack; patron/delegate grid collapses to one column; matrix scrolls horizontally.

## State Management
Mirror `GET /apps/emissary/api/v1/state`:
- `ship` — the authenticated @p.
- `delegates` — `{ @p: "pending" | "valid" | "rejected" }` (patron role).
- `patrons` — `[@p]` (delegate role).
- `incoming` — `[@p]` awaiting this ship's accept/reject (delegate role).
- `queries` — `{ target: { delegate:{status,timestamp,ships}, patron:{status,timestamp,ships} } }` (observer results). `status`: `"unknown" | "valid" | "unasked-for"`.
- UI-only: `selPair {p,x}`, `view "graph"|"matrix"`, `qShip`, `qKind`, `desig`, `showQR`, `toast`.

Derived per render: the ship axis (union of OBS set + query targets), node positions, edge list, matrix grid, the selected binding's verdict + two side objects, and the life:rift lookup. **Every stream fact replaces the whole state** — recompute derived views from it.

## Design Tokens
**Colors**
- Ground / dark: `#2f3019` (spec `--black` is `#38391f`; prototype darkened slightly for grid contrast — either is fine)
- Ink / cream (`--white`): `#f7f1d2` (+ alphas `.85 / .6 / .55 / .4 / .34 / .28 / .22 / .16 / .14`)
- Green (`--green`, valid/verified/accept): `#5dbf8d`
- Gold/yellow (`--yellow`, pending/unconfirmed/accent/registration ticks): `#fed107`
- Red (`--red`, rejected/conflict/breach): `#f05826`

**Blueprint grid** (root background): two layered line grids — `rgba(247,241,210,.05)` at 154px and `rgba(247,241,210,.025)` at 28px, both directions.

**Typography** (prototype → production)
- `Space Mono` (400/700) → **Urbit Sans / mono desk face**. Used for @p, data, tags, numbers.
- `Jost` (300–600) → desk sans. Used for uppercase labels/titles/buttons, letter-spacing .1–.24em.
- Sizes in use: 30 (wordmark), 16 (selected pair), 14 (verdict), 13 (input/@p), 12.5 (titles/rows), 11–11.5 (body/buttons), 9.5–10 (captions), 9 (badges).

**Spacing**: page padding `clamp(18px,3vw,40px)`; panel padding 20–22px; row padding 10px vertical; grid gaps 22–26px.

**Borders**: hairlines `1px` cream at .14–.45 alpha; emphasis `1.5–2px`; conflict `2px`. Registration ticks `2px` gold. No border-radius anywhere (square, technical). No shadows except the toast drop (`0 6px 22px rgba(0,0,0,.4)`).

## API Contract (reference — see spec for full detail)
All under `/apps/emissary/api/v1/`, same-origin, session-authenticated, JSON UTF-8. @p strings include the leading `~`; timestamps ISO-8601 UTC.
- `GET /state` → full local state (shape above).
- `POST /action` → one of `{designate|revoke|accept|reject:{ship}}` or `{query:{kind,ship}}`; responds `204`, results arrive on the stream.
- `GET /sigil/<ship>.svg` → sigil SVG for any @p (moons/comets get a placeholder glyph).
- **Update stream**: `%json` facts on subscription path `/web/state` over the standard channel API (`/~/channel`, EventSource). Each fact = a full state document.
- **Deep link**: `GET /apps/emissary/observer?who=<ship>&what=<delegates|patrons>` pre-fills and fires the query on load.

## Non-goals for v1
No pagination (sets are tens of ships), no history/audit log, no moon/comet flows, no unauthenticated public status page.

## Assets
- **Sigils**: server-rendered at `/apps/emissary/api/v1/sigil/<ship>.svg` — use directly; the prototype's geometric placeholder is not an asset to ship.
- **Fonts**: embed the desk's Urbit Sans / Urbit Serif faces (no CDN). The prototype's Jost / Space Mono are stand-ins.
- No images or icon libraries — the UI is pure type + hairline SVG.

## Files
In this bundle (design references, HTML "Design Components"):
- `Emissary Dashboard.dc.html` — the full dashboard: header, observer verification field (graph + matrix + drill-down), patron & delegate panels, mock live-state engine, toast.
- `Panel.dc.html` — the reusable bordered panel frame with gold corner ticks.
- `Sigil.dc.html` — the geometric sigil placeholder (replace with the server SVG in production).
- `support.js` — the prototype runtime (not part of the design; do not port).
