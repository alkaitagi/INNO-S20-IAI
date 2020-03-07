:- use_module(motion).
:- use_module(navigation).
% -----------------

start :-
    [map],
    move(100, [0, 0]),
    retract(visited([0, 0])),
    write_visited,
    halt.
% -----------------

move(I, Current) :-
    I >= 0,
    alive(Current),
    touchdown(Current),
    assert(visited(Current)).

move(I, Current) :-
    I > 0,
    J is I - 1,
    alive(Current),
    \+ touchdown(Current),
    random(0, 2, Direction),
    navigate(Direction, Current, Next),
    move(J, Next),
    assert(visited(Current)).


% -----------------
