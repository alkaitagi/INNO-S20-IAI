% :- use_module(motion).
% :- use_module(navigation).
% % -----------------

% start :-
%     [map],
%     statistics(walltime, _),
%     ball(Ball),
%     (move(Ball) ->
%         retract(visited(Ball)),
%         write_visited
%     ;
%         format('Could not solve~n')),
%     statistics(walltime, [_ | [Time]]),
%     format("~w msec~n", [Time]),
%     halt.

% finish :-

% % -----------------

% move(Current) :-
%     \+ visited(Current),
%     alive(Current),
%     assert(visited(Current)),
%     touchdown(Current).

% move(Current) :-
%     alive(Current),
%     assert(visited(Current)),
%     \+ touchdown(Current),
%     random(0, 12, Direction),
%     navigate(Direction, Current, Next),
%     J is I - 1,
%     move(Next),


% % -----------------
