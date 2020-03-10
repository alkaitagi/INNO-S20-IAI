:- consult(core/physics).
:- consult(core/game).
:- dynamic
    best/2.
% ---------------

search :-
    statistics(walltime, _),
    ball(Ball),
    (search(Ball) ; true),
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
            format("Moving: ~w ~w~n", [Current, Next]),
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
            format("retracting~n"),
            retract(best(_, _)),
            format("retracted~n"),
            assert(best(Count, Output))
        )
    ;
        format("Checking: ~w~n", [Count]),
        assert(best(Count, Output))
    ).

% ---------------
