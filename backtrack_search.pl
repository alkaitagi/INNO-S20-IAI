:- consult(core/core).
% ---------------

start :-
    statistics(walltime, _),
    ball(Ball),
    (search(Ball) -> true ; format("Could not solve~n")),
    statistics(walltime, [_ | [Time]]),
    format("~w msec~n", [Time]),
    halt.

search(Current) :-
    assert(visited(Current)),
    (touchdown(Current) ->
        write_visited
    ;
        between(0, 12, Direction),
        navigate(Direction, Current, Next),
        \+ visited(Next),
        (human(Next) ->
            assert(human(Current)),
            retract(human(Next)),
            search(Next),
            assert(human(Next)),
            retract(human(Current))
        ;
            search(Next)
        )
    ),
    retract(visited(Current)).

% ---------------
