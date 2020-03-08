:- module(motion, [
        up/2,
        up_right/2,
        right/2,
        down_right/2,
        down/2,
        down_left/2,
        left/2,
        up_left/2,
        step/3,
        toss/3,
        is_step/2
    ]).

% ------------------

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

% ------------------

step(Direction, Point, Result) :-
    (Direction =:= 0 -> up(Point, Result)
    ;Direction =:= 1 -> right(Point, Result)
    ;Direction =:= 2 -> down(Point, Result)
    ;Direction =:= 3 -> left(Point, Result)).

toss(Direction, Point, Result) :-
    (Direction =:= 0 -> up(Point, Result)
    ;Direction =:= 1 -> up_right(Point, Result)
    ;Direction =:= 2 -> right(Point, Result)
    ;Direction =:= 3 -> down_right(Point, Result)
    ;Direction =:= 4 -> down(Point, Result)
    ;Direction =:= 5 -> down_left(Point, Result)
    ;Direction =:= 6 -> left(Point, Result)
    ;Direction =:= 7 -> up_left(Point, Result)).

is_step(From, To) :-
    between(0, 3, Direction),
    step(Direction, From, To).

% ------------------
