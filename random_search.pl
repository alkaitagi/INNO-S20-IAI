:- use_module(motion).
:- use_module(navigation).
% -----------------

start :-
    [map],
    statistics(walltime, _),
    ball(Ball),
    (move(100, Ball) -> write_visited ; format("Could not solve~n")),
    statistics(walltime, [_ | [Time]]),
    format("~w msec~n", [Time]),
    halt.

move(I, Current) :-
    I >= 0,
    alive(Current),
    assert(visited(Current)),
    (touchdown(Current) -> !
    ;I > 0 ->
        random(0, 2, Direction),
        navigate(Direction, Current, Next),
        J is I - 1,
        move(J, Next)
    ).

% -----------------
