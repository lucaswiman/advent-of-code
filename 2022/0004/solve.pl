:- use_module(library(dcg/basics)).
:- use_module(library(pio)).

range_pair(L) -->
    integer(Start1), "-", integer(End1), ",", integer(Start2), "-", integer(End2), ("\n"; eos),
    {L = [range{start: Start1, end: End1}, range{start: Start2, end: End2}]}
.

range_file([]) --> eos, !.

range_file([Ranges|L]) --> range_pair(Ranges), range_file(L).

fully_contained([R1, R2]) :-
    (R1.start >= R2.start, R1.end =< R2.end, !);
    (R2.start >= R1.start, R2.end =< R1.end, !).

overlaps([R1, R2]) :-
    R1.start =< R2.end, R2.start =< R1.end.

num_fully_contained(RangePairList, Num) :-
    findall(X, (member(X, RangePairList), fully_contained(X)), FullyContained),
    length(FullyContained, Num).

num_overlap(RangePairList, Num) :-
    findall(X, (member(X, RangePairList), overlaps(X)), Overlaps),
    length(Overlaps, Num).

part1(RangePairs) :-
    num_fully_contained(RangePairs, Num),
    writeln("Part 1:"),
    writeln(Num).

part2(RangePairs) :-
    num_overlap(RangePairs, Num),
    writeln("Part 2:"),
    writeln(Num).


:- initialization phrase_from_file(range_file(RangePairs), "input"), part1(RangePairs), part2(RangePairs), halt.
