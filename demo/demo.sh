#!/bin/sh
# %emissary — narrated live demo
#
# Drives a tmux fleet of fake ships through the full delegation
# lifecycle while the audience watches dashboards update in real
# time. Pairs with the harness in emissary-harness/drive.sh (boot
# the fleet and install %emissary on each ship first).
#
#   ./demo.sh            step-by-step (press enter to advance)
#   AUTO=1 ./demo.sh     self-paced (for rehearsal / smoke testing)
#
# Roles (override via env):
#   PATRON   (default zod)  — designates a delegate
#   DELEGATE (default nec)  — accepts the designation
#   OBSERVER (default dev)  — third party verifying both sides
#   SESSION  (default emissary) — tmux session, one window per ship

SESSION="${SESSION:-emissary}"
PATRON="${PATRON:-zod}"
DELEGATE="${DELEGATE:-nec}"
OBSERVER="${OBSERVER:-dev}"

dojo() {  # dojo <ship> '<command>'
  tmux send-keys -t "$SESSION:$1" C-a
  tmux send-keys -t "$SESSION:$1" C-k
  tmux send-keys -t "$SESSION:$1" -l -- "$2"
  tmux send-keys -t "$SESSION:$1" Enter
}

say() { printf '\n\033[1;33m%s\033[0m\n' "$*"; }
sub() { printf '\033[0;36m  %s\033[0m\n' "$*"; }
pause() {
  if [ -n "$AUTO" ]; then sleep "${1:-6}"; else
    printf '\033[0;90m  [enter to continue]\033[0m'; read -r _; fi
}

port_of() {
  tmux capture-pane -pt "$SESSION:$1" -S -5000 \
    | grep 'web interface live' | tail -1 | grep -o 'localhost:[0-9]*'
}

# ---------------------------------------------------------------
say "%emissary — delegation with cryptographic third-party verification"
sub "patron:   ~$PATRON   ($(port_of $PATRON)/apps/emissary)"
sub "delegate: ~$DELEGATE   ($(port_of $DELEGATE)/apps/emissary)"
sub "observer: ~$OBSERVER   ($(port_of $OBSERVER)/apps/emissary)"
sub ""
sub "open the patron and observer dashboards in a browser now —"
sub "everything that follows happens live, no refreshing."
pause 3

# ---------------------------------------------------------------
say "0 · clean slate"
sub "revoke any standing delegation so the audience sees the whole arc."
dojo "$PATRON" ":emissary|revoke ~$DELEGATE"
pause 6

say "1 · observer baseline"
sub "~$OBSERVER remote-scries both sides before anything exists."
sub "(first contact rides the mesa handshake — answers land in ~30s,"
sub " which the coming narration absorbs. watch the observer's field.)"
dojo "$OBSERVER" ":emissary &emissary-query [%delegate ~$PATRON]"
dojo "$OBSERVER" ":emissary &emissary-query [%patron ~$DELEGATE]"
pause 8

# ---------------------------------------------------------------
say "2 · the patron designates"
sub "~$PATRON names ~$DELEGATE its delegate. on the patron dashboard the"
sub "row appears instantly as PENDING — the request is now crossing the"
sub "network, and the delegate's dashboard raises an incoming toast."
dojo "$PATRON" ":emissary|designate ~$DELEGATE"
pause 10

# ---------------------------------------------------------------
say "3 · the delegate accepts"
sub "~$DELEGATE accepts. watch the patron dashboard: PENDING flips to"
sub "VALID with no refresh — and both ships publish signed attestations"
sub "into their remote-scry namespaces, revision-managed and culled."
dojo "$DELEGATE" ":emissary|accept ~$PATRON"
pause 10

# ---------------------------------------------------------------
say "4 · third-party verification (the point of all this)"
sub "~$OBSERVER re-queries BOTH sides. neither ship is asked to be"
sub "honest: the observer reads each side's signed attestation over"
sub "remote scry and requires them to agree."
dojo "$OBSERVER" ":emissary &emissary-query [%delegate ~$PATRON]"
dojo "$OBSERVER" ":emissary &emissary-query [%patron ~$DELEGATE]"
pause 8
sub "on the observer's graph: a solid green edge ~$PATRON ▸ ~$DELEGATE —"
sub "VERIFIED, because patron-side and delegate-side attestations match."
sub "click the edge: the drill-down shows each side's answer, its"
sub "timestamp, and the ships' life:rift keys."
pause 8

# ---------------------------------------------------------------
say "5 · revocation propagates"
sub "~$PATRON revokes. both sides republish; the observer re-queries and"
sub "the edge disappears — a stale VERIFIED can't outlive re-checking."
dojo "$PATRON" ":emissary|revoke ~$DELEGATE"
pause 8
dojo "$OBSERVER" ":emissary &emissary-query [%delegate ~$PATRON]"
dojo "$OBSERVER" ":emissary &emissary-query [%patron ~$DELEGATE]"
pause 8

# ---------------------------------------------------------------
say "6 · restore (end in the good state)"
dojo "$PATRON" ":emissary|designate ~$DELEGATE"
pause 8
dojo "$DELEGATE" ":emissary|accept ~$PATRON"
pause 8
dojo "$OBSERVER" ":emissary &emissary-query [%delegate ~$PATRON]"
dojo "$OBSERVER" ":emissary &emissary-query [%patron ~$DELEGATE]"
pause 8

say "fin — the observer field shows the verified binding again."
sub "QR epilogue: on the patron dashboard, hit ⧉ VERIFY ME and scan"
sub "the QR from a phone pointed at any ship's dashboard — it opens"
sub "the observer view with the query pre-fired."
