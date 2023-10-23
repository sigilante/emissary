#   `%emissary`

`%emissary` allows a running star to designate a planet as its representative.  (This is tied to operation not merely to ownership.)

`%emissary` allows app developers to permit delegate planets to exercise star-related powers and privileges.  It can be used for arrangements beyond this, however.

![](https://raw.githubusercontent.com/sigilante/emissary/master/img/emissary-icon.png)

Prior art:

- [`~hanfel-dovned/bless`](https://github.com/hanfel-dovned/Bless)
- [`~paldev/pals`](https://github.com/fang-/suite/)


##  Interface

The index page is served at `/app/emissary`.

### Patron

The patron is responsible to send a request to another point for that point to act as its delegate.

Delegation may be managed through the patron portal online or using CLI generators:

```hoon
:emissary|designate ~sampel-palnet
:emissary|revoke ~sampel-palnet
```

![](./img/screenshot-patron.png)

### Delegate

The delegate may review and either accept or reject requests from other points to serve as their delegate.

Delegation may be managed through the delegate portal online or using CLI generators:

```hoon
:emissary|accept ~sampel
:emissary|reject ~sampel
```

![](./img/screenshot-delegate.png)

### Third-Party App

At the current time, a third-party app should check the claim and agreement of a patron and a delegate through scries.

```hoon
.^((set @p) %gy /=emissary=/delegates)
.^((set @p) %gy /=emissary=/requests)
.^((set @p) %gy /=emissary=/patrons)

.^(? %gx /=emissary=/delegate/~zod/noun)
.^(? %gx /=emissary=/patron/~zod/noun)
```

We need to decide what is a good interval for this attestation to remain valid.  We also need to produce a library core to facilitate checking both points easily.


##  Specification

User story:

1. A star operator uses an agent on their star to designate a particular planet as an emissary.  This can be checked through a scry or a venter-pattern poke/gift.
2. The planet operator (same person presumably) can then make a claim on their ship at an endpoint or scry path or whatever that they have the designation from a star.
3. A third-party app should check both the planet claim and the star claim, which requires the star to be online.

So there is one agent in `%emissary` that carries out two roles:

1. Patron (nominally for the star or superior point)
2. Delegate (nominally for the planet or inferior point)
