:-table b/0.
a1d:-tnot(b).
:-table c/0.
b1d:-braa.
b1d:-tnot(c).
c1d:-craa.
c1d:-true.
a2d:-araa.
a2d:-true.
:-table c/0.
b2d:-tnot(c).
:-table a/0.
c2d:-craa.
c2d:-tnot(a).
:-table b/0.
a3d:-araa.
a3d:-tnot(b).
b3d:-braa.
b3d:-true.
:-table a/0.
c3d:-tnot(a).
:-table b1i/0.
a1i:-tnot(b1i).
b1i:-braa.
:-table c1i/0.
b1i:-tnot(c1i).
c1i:-craa.
c1i:-true.
a2i:-araa.
a2i:-true.
:-table c2i/0.
b2i:-tnot(c2i).
c2i:-craa.
:-table a2i/0.
c2i:-tnot(a2i).
a3i:-araa.
:-table b3i/0.
a3i:-tnot(b3i).
b3i:-braa.
b3i:-true.
:-table a3i/0.
c3i:-tnot(a3i).
:-table a1d/0.
araa:-a1d.
araa:-a1i,tnot(a1d).
a:-araa.
:-table b2d/0.
braa:-b2d.
braa:-b2i,tnot(b2d).
b:-braa.
:-table c3d/0.
craa:-c3d.
craa:-c3i,tnot(c3d).
c:-craa.
