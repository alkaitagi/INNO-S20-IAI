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
        (
            (update_pending(0, Current) ; true),
            (update_pending(1, Current) ; true),
            (update_pending(2, Current) ; true),
            (update_pending(3, Current) ; true),
            (update_pending(4, Current) ; true),
            (update_pending(5, Current) ; true),
            (update_pending(6, Current) ; true),
            (update_pending(7, Current) ; true),
            (update_pending(8, Current) ; true),
            (update_pending(9, Current) ; true),
            (update_pending(10, Current) ; true),
            (update_pending(11, Current) ; true)
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
