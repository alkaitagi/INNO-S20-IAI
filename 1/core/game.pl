:- module(game, [
        map/1,
        ball/1,
        human/1,
        ork/1,
        touchdown/1,
        alive/1,
        visited/1,
        trace_visited/2,
        write_visited/2,
        navigate/3,
        pass_ball/2,
        reload_game/0
    ]).
:- consult(core/motion).
:- consult(core/map).
:- dynamic
    m/2,
    b/2,
    h/2,
    o/2,
    t/2,
    visited/1.

% ----------------

reload_game :-
    retractall(m(_, _)),
    retractall(b(_, _)),
    retractall(h(_, _)),
    retractall(o(_, _)),
    retractall(t(_, _)),
    retractall(visited(_)),
    unload_file(core/map),
    [core/map].

% ----------------

write_visited(Turns, Output) :-
    format("~w turns:~n~w", [Turns, Output]).

trace_visited(Turns, Output) :-
    findall(Point, visited(Point), Visited),
    trace_visited(Visited, Turns, Output).

trace_visited([Current, [U, V] | Path], Turns, Output) :-
    (sqr_distance(Current, [U, V], 1) ->
        (human(Current) -> Type = 'H' ; Type = ' ')
    ;
        Type = 'P'
    ),
    trace_visited([[U, V] | Path], NTurns, NOutput),
    (Type == 'H' -> Turns = NTurns ; succ(NTurns, Turns)),
    format(atom(Output), "~w ~w ~w~n~w", [Type, U, V, NOutput]).

trace_visited([_], 0, "").

% ----------------

map([X, Y]) :-
    m(X, Y).

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
