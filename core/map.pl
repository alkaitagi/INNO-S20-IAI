:- module(map, [
    m/2,
    b/2,
    h/2,
    o/2,
    t/2
    ]).

:- discontiguous map:h/2.
:- discontiguous map:o/2.
:- discontiguous map:t/2.

h(-1, -1).
o(-1, -1).
t(-1, -1).

% -----------------

m(2, 2).
b(0, 0).

t(1, 1).

% ----------------- input
