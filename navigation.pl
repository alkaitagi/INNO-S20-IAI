:- module(navigation, [
        human/1,
        ork/1,
        touchdown/1,
        alive/1,
        visited/1,
        write_visited/0,
        navigate/3
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

write_step([X, Y], [U, V]) :-
    (\+ is_step([X, Y], [U, V]),
    write('P'));
    format('~w ~w~n', [U, V]).

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

navigate(Direction, Current, Next) :-
    Direction < 4,
    step(Direction, Current, Next).

navigate(Direction, Current, Next) :-
    Direction >= 4,
    Throw is Direction - 4,
    fly(Throw, Current, Next),
    assert(human(Current)),
    retract(human(Next)).

fly(Direction, Current, Result) :-
    alive(Current),
    \+ human(Current),
    toss(Direction, Current, Next),
    fly(Direction, Next, Result).

fly(_, Current, Current) :-
    alive(Current),
    human(Current).

% -----------------
