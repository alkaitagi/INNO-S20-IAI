:- module(game, [
        ball/1,
        human/1,
        ork/1,
        touchdown/1,
        alive/1,
        visited/1,
        write_visited/0,
        navigate/3,
        pass_ball/2
    ]).

:- use_module(core/physics).
:- use_module(core/map).
:- dynamic
    visited/1.

% ----------------



% ----------------


write_visited :-
    findall(Point, visited(Point), Visited),
    length(Visited, Len),
    N is Len - 1,
    format('~w~n', [N]),
    write_visited(Visited).

write_visited([Current, [U, V] | Path]) :-
    (sqr_distance(Current, [U, V], 1) ->
        (human(Current) -> write('H') ; write(' '))
    ;
        write('P')
    ),
    format(' ~w ~w~n', [U, V]),
    write_visited([[U, V] | Path]).

write_visited([_]).
% ----------------

ball([X, Y]) :-
    b(X, Y).

human([X, Y]) :-
    h(X, Y).

ork([X, Y]) :-
    o(X, Y).

touchdown([X, Y]) :-
    t(X, Y).

alive([X, Y]) :-
    \+ o(X, Y),
    X>=0,Y>=0,
    m(W, H),
    X=<W, Y=<H.

% ---------------

pass_ball([X, Y], [U, V]) :-
    assert(h(X, Y)),
    retract(h(U, V)).

navigate(Direction, Current, Next) :-
    (Direction < 4 ->
        step4(Direction, Current, Next),
        alive(Next)
    ;
        Toss is Direction - 4,
        fly(Toss, Current, Next)
    ).

fly(Direction, Current, Result) :-
    alive(Current),
    \+ human(Current),
    step8(Direction, Current, Next),
    fly(Direction, Next, Result).

fly(_, Current, Current) :-
    alive(Current),
    human(Current).

% ---------------
