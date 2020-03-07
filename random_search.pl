:- use_module(motion).
:- use_module(navigation).
% -----------------

start :-
    [map],
    statistics(walltime, _),
    (move(100, [0, 0]) ->
        retract(visited([0, 0])),
        write_visited
    ;
        format('Could not solve~n')
    ),
    statistics(walltime, [_ | [Time]]),
    format("~w msec~n", [Time]),
    halt.

% -----------------

move(I, Current) :-
    I >= 0,
    alive(Current),
    touchdown(Current),
    assert(visited(Current)).

move(I, Current) :-
    I > 0,
    alive(Current),
    \+ touchdown(Current),
    random(0, 2, Direction),
    navigate(Direction, Current, Next),
    J is I - 1,
    move(J, Next),
    assert(visited(Current)).

% -----------------
