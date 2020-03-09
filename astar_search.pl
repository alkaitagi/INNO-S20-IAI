:- consult(core/core).
:- dynamic
    cost/2,
    link/2,
    pending/1.

% ---------------

start :-
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
        write_visited,
        !
    ;
        update_pending(Current)
    ),
    best_pending(Next),
    (human(Next) ->
        assert(human(Current)),
        retract(human(Next)),
        search(Next),
        assert(human(Next)),
        retract(human(Current))
    ;
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

% can be optimized
% https://stackoverflow.com/questions/16349912/prolog-find-minimum-value-query
best_pending(Point) :-
    pending(Point),
    try_cost(Point, Cost),
    try_cost(_, Other),
    Other =< Cost.

update_pending(Current) :-
    between(0, 12, Direction),
    navigate(Direction, Current, Next),
    \+ pending(Next),
    \+ visited(Next),
    try_cost(Next, _),
    assert(pending(Next)).

update_link(From, To) :-
    retractall(link(_, To)),
    link(From, To).

% ---------------
