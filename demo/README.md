# `%emissary` live demo

A narrated walkthrough of the full delegation lifecycle — designate →
accept → third-party verification → revocation — driven from tmux
while the audience watches dashboards update over the live stream.

## Setup

1. Boot a fleet of fake ships in a tmux session named `emissary`, one
   window per ship (the development harness's `drive.sh boot` does
   this; any tmux session with windows named after the ships works).
2. Install the `%emissary` desk on each ship (`drive.sh install <ship>`).
3. Find each ship's HTTP port (`drive.sh read <ship>` after boot, or
   grep the boot log for `web interface live`), log into the patron
   and observer dashboards at `http://localhost:<port>/apps/emissary`
   (fake ship codes are deterministic; `+code` in the dojo).

## Run

```sh
./demo.sh              # press enter to advance between beats
AUTO=1 ./demo.sh       # self-paced, for rehearsal or smoke-testing
PATRON=wes DELEGATE=dev OBSERVER=zod ./demo.sh   # recast the roles
```

## Beats

0. **Clean slate** — revoke any standing delegation.
1. **Observer baseline** — queries fired early; first-contact remote
   scry takes ~30s over the mesa handshake, absorbed by narration.
2. **Designate** — PENDING appears live on the patron dashboard; the
   delegate's dashboard raises an incoming-request toast.
3. **Accept** — PENDING flips to VALID, no refresh; both sides publish
   signed attestations to their remote-scry namespaces.
4. **Verify** — the observer reads both sides and requires agreement:
   a solid green VERIFIED edge on the graph. Drill-down shows each
   side's answer, timestamps, and life:rift keys.
5. **Revocation** — republish + re-query; the edge disappears.
6. **Restore** — end in the good state; QR epilogue via ⧉ VERIFY ME.
