:- consult(core/core).
% ---------------

search :-
    statistics(walltime, _),
    ball(Ball),
    (
        search(Ball);
        format("Could not solve~n")
    ),
    statistics(walltime, [_ | [Time]]),
    format("~w msec~n", [Time]),
    halt.

search(Current) :-
    assert(visited(Current)),
    (touchdown(Current) ->
        trace_visited(Output, Count)
    ;
        between(0, 11, Direction),
        navigate(Direction, Current, Next),
        \+ visited(Next),
        (human(Next) ->
            pass_ball(Current, Next),
            search(Next),
            pass_ball(Next, Current)
        ;
            search(Next)
        )
    ),
    retract(visited(Current)).

% ---------------
