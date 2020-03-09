:- module(physics, [
        step4/3,
        step8/3,
        sqr_distance/3
    ]).

% ----------------

up([X, Y], [X, V]) :-
    V is Y + 1.

up_right([X, Y], [U, V]) :-
    U is X + 1,
    V is Y + 1.

right([X, Y], [U, Y]) :-
    U is X + 1.

down_right([X, Y], [U, V]) :-
    U is X + 1,
    V is Y - 1.

down([X, Y], [X, V]) :-
    V is Y - 1.

down_left([X, Y], [U, V]) :-
    U is X - 1,
    V is Y - 1.

left([X, Y], [U, Y]) :-
    U is X - 1.

up_left([X, Y], [U, V]) :-
    U is X - 1,
    V is Y + 1.

% ----------------

step4(Direction, Point, Result) :-
    (Direction =:= 0 -> up(Point, Result)
    ;Direction =:= 1 -> right(Point, Result)
    ;Direction =:= 2 -> down(Point, Result)
    ;Direction =:= 3 -> left(Point, Result)).

step8(Direction, Point, Result) :-
    (Direction =:= 0 -> up(Point, Result)
    ;Direction =:= 1 -> up_right(Point, Result)
    ;Direction =:= 2 -> right(Point, Result)
    ;Direction =:= 3 -> down_right(Point, Result)
    ;Direction =:= 4 -> down(Point, Result)
    ;Direction =:= 5 -> down_left(Point, Result)
    ;Direction =:= 6 -> left(Point, Result)
    ;Direction =:= 7 -> up_left(Point, Result)).

sqr_distance([X, Y], [U, V], D) :-
    W is X - U,
    H is Y - V,
    D is W * W + H * H.

% ----------------
