:- module(navigation, [
        map/2,
        human/1,
        human/2,
        ork/1,
        ork/2,
        touchdown/1,
        touchdown/2,
        alive/1,
        visited/1,
        write_visited/0
    ]).

:- use_module(motion).
:- dynamic
    visited/1,
    human/1.

% ------------------

write_visited :-
    findall(Point, visited(Point), Visited),
    length(Visited, Len),
    format('~w~n', [Len]),
    write_visited(Visited).

write_visited([A]) :-
    write_step([1, 1], A).

write_visited([A, B | C]) :-
    write_visited([B | C]),
    write_step(B, A).

write_step(From, To) :-
    is_step(From, To),
    format('~w~n', [To]).

write_step(From, To) :-
    \+ is_step(From, To),
    format('P ~w~n', [To]).

% ------------------

human([X, Y]) :-
    human(X, Y).

ork([X, Y]) :-
    ork(X, Y).

touchdown([X, Y]) :-
    touchdown(X, Y).

alive([X, Y]) :-
    \+ ork(X, Y),
    X>=0,Y>=0,
    map(U, V),
    X=<U, Y=<V.


% ------------------


map(2, 2).

human(0, 1).
ork(1, 0).
touchdown(1, 1).
