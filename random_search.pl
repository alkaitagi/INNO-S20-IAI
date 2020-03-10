:- consult(core/motion).
:- consult(core/game).
% ---------------

search :-
    statistics(walltime, _),
    ball(Ball),
    (
        search(100, Ball);
        format("Could not solve~n")
    ),
    statistics(walltime, [_ | [Time]]),
    format("~w msec~n", [Time]),
    halt.

search(I, Current) :-
    I >= 0,
    assert(visited(Current)),
    (touchdown(Current) ->
        trace_visited(Output, Count),
        !
    ;I > 0 ->
        random(0, 12, Direction),
        navigate(Direction, Current, Next),
        (
            \+ human(Current);
            assert(human(Current)),
            retract(human(Next))
        ),
        J is I - 1,
        search(J, Next)
    ).

% ---------------
