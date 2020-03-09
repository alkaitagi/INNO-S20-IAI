:- consult(core/core).
:- dynamic
    cost/2,
    link/2,
    pending/1.

% ---------------

search :-
    statistics(walltime, _),
    ball(Ball),
    assert(pending(Ball)),
    (search(Ball) -> true ; format("Could not solve~n")),
    statistics(walltime, [_ | [Time]]),
    format("~w msec~n", [Time]),
    halt.

search(Current) :-
    retract(pending(Current)),
    assert(visited(Current)),
    (touchdown(Current) ->
        retractall(visited(_)),
        link_visited(Current),
        trace_visited(Output, Count)
    ;
        forall(
            between(0, 11, Direction),
            (update_pending(Direction, Current) ; true)
        ),
        best_pending(Next),
        update_link(Current, Next),

        search(Next)
    ).

% ---------------

try_cost(Point, Cost) :-
    (cost(Point, TryCost) ->
        Cost is TryCost
    ;
        touchdown(Touchdown),
        sqr_distance(Point, Touchdown, TouchdownCost),
        ball(Ball),
        sqr_distance(Point, Ball, BallCost),
        Cost is TouchdownCost + BallCost,
        assert(cost(Point, Cost))
    ).

best_pending(Point) :-
    setof(
        Cost-Point,
        (
            pending(Point),
            try_cost(Point, Cost)
        ),
        [Cost-Point | _]
    ).

update_pending(Direction, Current) :-
    navigate(Direction, Current, Next),
    \+ pending(Next),
    \+ visited(Next),
    try_cost(Next, _),
    assert(pending(Next)),
    true.

update_link(From, To) :-
    retractall(link(_, To)),
    assert(link(From, To)).

link_visited(Current) :-
    (link(Previous, Current) ->
        link_visited(Previous),
        (
            \+ human(Current);
            pass_ball(Previous, Current)
        )
    ;
        true
    ),
    assert(visited(Current)).

% ---------------
