:- use_module(library(dcg/basics)).
:- use_module(library(pio)).

moves_list([]) --> eos.
moves_list([X|Xs]) --> move(X), "\n", moves_list(Xs).
move(down(I)) --> "down ", integer(I).
move(forward(I)) --> "forward ", integer(I).
move(down(I)) --> "up ", integer(J), {I is -J}.

process1([], 0, 0).
process1([down(I)|Ms], Down, Forward) :-
    process1(Ms, Down_, Forward),
    (Down is Down_ + I)
.
process1([forward(I)|Ms], Down, Forward) :-
    process1(Ms, Down, Forward_),
    (Forward is Forward_ + I)
.


down_moves([], []).
down_moves([down(I)|M], [I|D]) :- down_moves(M, D).
down_moves([forward(_)|M], [0|D]) :- down_moves(M, D).

forward_moves([], []).
forward_moves([forward(I)|M], [I|D]) :- forward_moves(M, D).
forward_moves([down(I)|M], [0|D]) :- forward_moves(M, D).

multiply_lists([], [], []).
multiply_lists([X|Xs], [Y|Ys], [Z|Zs]) :-
    Z is X * Y,
    multiply_lists(Xs, Ys, Zs).

aims(Moves, Aims) :-
    down_moves(Moves, Verts),
    scanl(plus, Verts, 0, Sums),
    append(Aims, [_], Sums).

process2(Moves, Down, Forward) :-
    aims(Moves, Aims),
    forward_moves(Moves, Forwards),
    down_moves(Moves, Downs),
    multiply_lists(Forwards, Aims, AimComponent),
    sum_list(AimComponent, Down),
    sum_list(Forwards, Forward).

:- initialization
    phrase_from_file(moves_list(Moves), "input"),
    process1(Moves, D, F),
    X is D*F,
    writeln("Part 1:"),
    writeln(X),
    process2(Moves, Down, Forward),
    Y is Down * Forward,
    writeln("Part 2:"),
    writeln(Y),
    halt.