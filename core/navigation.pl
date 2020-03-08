:- module(navigation, [
        ball/1,
        human/1,
        ork/1,
        touchdown/1,
        alive/1,
        visited/1,
        write_visited/0,
        navigate/3,
        distance/3,
        touchdown_distance/2,
        ball_distance/2
    ]).

:- use_module(core/motion).
:- use_module(core/map).
:- dynamic
    human/1,
    visited/1.

% ----------------

write_visited :-
    findall(Point, visited(Point), Visited),
    length(Visited, Len),
    N is Len - 1,
    format('~w~n', [N]),
    write_visited(Visited).

write_visited([Current, [X, Y] | Path]) :-
    (is_step(Current, [X, Y]) -> true ; write('P ')),
    format('~w ~w~n', [X, Y]),
    write_visited([[X, Y] | Path]).

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
    X<W, Y<H.

% ---------------

distance(X, Y, D) :-
    D is X * X + Y * Y.

touchdown_distance(X, D) :-
    touchdown(T),
    distance(X, T, D).

ball_distance(X, D) :-
    ball(B),
    distance(X, B, D).

% ---------------

navigate(Direction, Current, Next) :-
    (Direction < 4 ->
        step(Direction, Current, Next)
    ;
        Throw is Direction - 4,
        fly(Throw, Current, Next)
    ).

fly(Direction, Current, Result) :-
    alive(Current),
    \+ human(Current),
    toss(Direction, Current, Next),
    fly(Direction, Next, Result).

fly(_, Current, Current) :-
    alive(Current),
    human(Current).

% ---------------
