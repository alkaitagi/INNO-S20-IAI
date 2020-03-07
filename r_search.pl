:- use_module(motion).
:- use_module(navigation).

start :-
    move(100, [0, 0]),
    retract(visited([0, 0])),
    write_visited.

move(I, Current) :-
    I > 0,
    alive(Current),
    \+ touchdown(Current),
    random(0, 2, Direction),
    navigate(Direction, I, Current, J, Next),
    move(J, Next),
    assert(visited(Current)).

move(I, Current) :-
    I >= 0,
    alive(Current),
    touchdown(Current),
    assert(visited(Current)).

navigate(Direction, I, Current, J, Next) :-
    Direction < 4,
    human(Current),
    J is I,
    step(Direction, Current, Next).

navigate(Direction, I, Current, J, Next) :-
    Direction < 4,
    \+ human(Current),
    J is I - 1,
    step(Direction, Current, Next).

navigate(Direction, I, Current, J, Next) :-
    Direction >= 4,
    Throw is Direction - 4,
    fly(Throw, Current, Next),
    J is I - 1,
    assert(human(Current)),
    retract(human(Next)).

fly(Direction, Current, Result) :-
    alive(Current),
    \+ human(Current),
    toss(Direction, Current, Next),
    fly(Direction, Next, Result).

fly(_, Current, Current) :-
    alive(Current),
    human(Current).
