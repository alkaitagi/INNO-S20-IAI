:- consult(core/motion).
:- consult(core/game).
:- dynamic
    best/2.
% ---------------

search :-
    statistics(walltime, _),
    ball(Ball),
    search(Ball),
    (best(Count, Output) ->
        format("~w~n~w", [Count, Output])
    ;
        format("Could not solve~n")
    ),
    statistics(walltime, [_ | [Time]]),
    format("~w msec~n", [Time]),
    halt.

search(Current) :-
    assert(visited(Current)),
    (touchdown(Current) ->
        trace_visited(Count, Output),
        update_best(Count, Output)
    ;forall(
        between(0, 11, Direction),
        (
            navigate(Direction, Current, Next),
            \+ visited(Next),
            (human(Next) ->
                pass_ball(Current, Next),
                search(Next),
                pass_ball(Next, Current)
            ;
                search(Next)
            );
            true
        )
    )),
    retract(visited(Current)).

% ---------------

update_best(Count, Output) :-
    (best(BCount, _) ->
        (
            Count >= BCount;
            retract(best(_, _)),
            assert(best(Count, Output))
        )
    ;
        assert(best(Count, Output))
    ).

% ---------------
