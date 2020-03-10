:- consult(core/motion).
:- consult(core/game).
:- dynamic
    best/2.
% ---------------

search :-
    statistics(walltime, _),
    Runs = 1000,
    Steps = 100,
    ball(Ball),
    forall(
        between(1, Runs, _),
        (
            reload_game,
            search(Steps, Ball);
            true
        )
    ),
    (best(Turns, Output) ->
        write_visited(Turns, Output)
    ;
        format("Could not solve~n")
    ),
    statistics(walltime, [_ | [Time]]),
    format("~w msec~n", [Time]),
    halt.

search(Steps, Current) :-
    assert(visited(Current)),
    (touchdown(Current) ->
        trace_visited(Turns, Output),
        update_best(Turns, Output)
    ; Steps >= 1 ->
        random(0, 12, Direction),
        navigate(Direction, Current, Next),
        \+ visited(Next),
        (
            \+ human(Next);
            pass_ball(Current, Next)
        ),
        succ(NSteps, Steps),
        search(NSteps, Next)
    ).

% ---------------

update_best(Turns, Output) :-
    (best(BTurns, _) ->
        (
            Turns >= BTurns;
            retract(best(_, _)),
            assert(best(Turns, Output))
        )
    ;
        assert(best(Turns, Output))
    ).

% ---------------
