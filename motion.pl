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

step(0, Point, Result) :-
    up(Point, Result).

step(1, Point, Result) :-
    right(Point, Result).

step(2, Point, Result) :-
    down(Point, Result).

step(3, Point, Result) :-
    left(Point, Result).

% ------------------

toss(0, Point, Result) :-
    up(Point, Result).

toss(1, Point, Result) :-
    up_right(Point, Result).

toss(2, Point, Result) :-
    right(Point, Result).

toss(3, Point, Result) :-
    down_right(Point, Result).

toss(4, Point, Result) :-
    down(Point, Result).

toss(5, Point, Result) :-
    down_left(Point, Result).

toss(6, Point, Result) :-
    left(Point, Result).

toss(7, Point, Result) :-
    up_left(Point, Result).

% ------------------

is_step(From, To) :-
    step(0, From, Step),
    are_equal(To, Step).

is_step(From, To) :-
    step(1, From, Step),
    are_equal(To, Step).

is_step(From, To) :-
    step(2, From, Step),
    are_equal(To, Step).

is_step(From, To) :-
    step(3, From, Step),
    are_equal(To, Step).

are_equal([X, Y], [U, V]) :-
    X =:= U,
    Y =:= V.

% ------------------
