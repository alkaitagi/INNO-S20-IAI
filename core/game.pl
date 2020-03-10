:- module(game, [
        ball/1,
        human/1,
        ork/1,
        touchdown/1,
        alive/1,
        visited/1,
        trace_visited/2,
        navigate/3,
        pass_ball/2
    ]).
:- consult(core/physics).
:- consult(core/map).
:- dynamic
    m/2,
    b/2,
    h/2,
    o/2,
    t/2,
    visited/1.

% ----------------

trace_visited(Count, Output) :-
    findall(Point, visited(Point), Visited),
    trace_visited(Visited, Count, Output).

trace_visited([Current, [U, V] | Path], Count, Output) :-
    (sqr_distance(Current, [U, V], 1) ->
        (human(Current) -> Type = 'H' ; Type = ' ')
    ;
        Type = 'P'
    ),
    trace_visited([[U, V] | Path], NCount, NOutput),
    (Type == 'H' -> Count = NCount ; succ(NCount, Count)),
    format(atom(Output), "~w ~w ~w~n~w", [Type, U, V, NOutput]).

trace_visited([_], 0, "").

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
    (human(Current) ->
        Result = Current
    ;
        step8(Direction, Current, Next),
        fly(Direction, Next, Result)
    ).

% ---------------
