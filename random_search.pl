:- consult(core/core).
% ---------------

start :-
    statistics(walltime, _),
    ball(Ball),
    (search(100, Ball) -> true ; format("Could not solve~n")),
    statistics(walltime, [_ | [Time]]),
    format("~w msec~n", [Time]),
    halt.

search(I, Current) :-
    I >= 0,
    alive(Current),
    assert(visited(Current)),
    (touchdown(Current) ->
        write_visited
    ;I > 0 ->
        random(0, 12, Direction),
        navigate(Direction, Current, Next),
        (human(Current) ->
            assert(human(Current)),
            retract(human(Next))
        ;
            true
        ),
        J is I - 1,
        search(J, Next)
    ).

% ---------------
