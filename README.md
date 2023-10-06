#   `%emissary`

`%emissary` allows a star to designate a planet as its representative.  This is tied to an operational star, not to ownership on Azimuth.

Ultimately, `%emissary` should allow app developers to permit emissary planets to exercise star-related powers and privileges.

##  Specification

User story:

1. A star operator uses an agent on their star to designate a particular planet as an emissary.  This can be checked through a scry or a venter-pattern poke/gift.
2. The planet operator (same person presumably) can then make a claim on their ship at an endpoint or scry path or whatever that they have the designation from a star.
3. A third-party app should check both the planet claim and the star claim, which requires the star to be online.

So there are two agents in `%emissary`:

1. Designator (for the star)
2. Testator (for the planet)


##  Worklist

- [x] spec out project scope
  - do we want to use the `++abet` pattern?
    - https://github.com/sigilante/rkyv
- [x] look at `%bless`
  - https://github.com/hanfel-dovned/Bless
- [x] set up repo and MWE agent
  - ++on-init, ++on-load, ++on-save
  - ++on-peek, ++on-poke
  - ++on-watch, ++on-leave
    - https://github.com/niblyx-malnus/venter-pattern/
  - ++on-arvo, ++on-fail
  - ++on-agent
- [x] restrict asset classes
- [~] test and validate behavior
- [ ] add generators to wrap pokes
- [ ] add a Sail/Rudder front-end
