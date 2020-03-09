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

:- use_module(core/physics).
:- use_module(core/map).
:- dynamic
    visited/1.

% ----------------

trace_visited(Output, Count) :-
    findall(Point, visited(Point), Visited),
    trace_visited(Visited, Output, Count),
    format("~w\n~w", [Count, Output]).

trace_visited([Current, [U, V] | Path], Output, Count) :-
    (sqr_distance(Current, [U, V], 1) ->
        (human(Current) -> Type = 'H' ; Type = ' ')
    ;
        Type = 'P'
    ),
    trace_visited([[U, V] | Path], NOutput, NCount),
    format(atom(Output), "~w ~w ~w\n~w", [Type, U, V, NOutput]),
    (Type == 'H' -> Count = NCount ; succ(NCount, Count)).

trace_visited([_], "", 0).

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
