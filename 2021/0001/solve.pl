:- use_module(library(dcg/basics)).
:- use_module(library(pio)).

int_list([]) --> eos, !.
int_list([X|Xs]) --> integer(X), ("\n"; eos), int_list(Xs).

incr_count([], 0).
incr_count([_], 0).
incr_count([First, Second | Rest], Cnt) :-
    incr_count([Second | Rest], Cnt2),
    (
        (First >= Second -> Cnt is Cnt2 );
        (Cnt is Cnt2 + 1)
    )
.


window(X, N, W) :-
    length(W, N),
    append(W, _, X)
.
windows([], 0, []).
windows(X, N, []) :-
    length(X, L),
    L < N.
windows([X|Xs], N, [W|Ws]) :-
    window([X|Xs], N, W),
    windows(Xs, N, Ws)
.
sums([], []).
sums([X|Xs], [S|Sums]) :-
    sum_list(X, S),
    sums(Xs, Sums)
.

:-
    initialization phrase_from_file(int_list(Ints), "input"),
    incr_count(Ints, Cnt),
    writeln("Part 1:"),
    writeln(Cnt),
    windows(Ints, 3, Windows),
    sums(Windows, Sums),
    incr_count(Sums, Part2Cnt),
    writeln("Part 2:"),
    writeln(Part2Cnt),
    halt
.

