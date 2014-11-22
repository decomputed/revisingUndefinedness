falso <- h, not h.
falso <- q1, not q1.
falso <- assert((h)), not assert((h)).
falso <- assert((not h)), not assert((not h)).




assert((h)) <- not h.
assert((not h)) <- h.
q1 <- h.

newEvents.
