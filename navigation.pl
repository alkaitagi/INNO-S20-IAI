:- module(navigation, [
        human/1,
        ork/1,
        touchdown/1,
        alive/1,
        visited/1,
        write_visited/0
    ]).

:- use_module(motion).
:- use_module(map).
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
    h(X, Y).

ork([X, Y]) :-
    o(X, Y).

touchdown([X, Y]) :-
    t(X, Y).

alive([X, Y]) :-
    \+ o(X, Y),
    X>=0,Y>=0,
    m(U, V),
    X=<U, Y=<V.


% -----------------
