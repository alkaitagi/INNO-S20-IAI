:- use_module(motion).
:- use_module(navigation).
% -----------------

start :-
    [map],
    statistics(walltime, _),
    ball(Ball),
    (move(Ball) -> true ; format("Could not solve~n")),
    statistics(walltime, [_ | [Time]]),
    format("~w msec~n", [Time]),
    halt.

move(Current) :-
    alive(Current),
    assert(visited(Current)),
    (touchdown(Current) ->
        write_visited
    ;
        between(0, 12, Direction),
        navigate(Direction, Current, Next),
        \+ visited(Next),
        move(Next)
    ),
    retract(visited(Current)).

% -----------------
