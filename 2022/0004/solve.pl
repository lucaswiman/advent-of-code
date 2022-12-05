#! /usr/bin/env swipl

:- use_module(library(dcg/basics)).
:- use_module(library(pio)).
% lines([])           --> call(eos), !.
% lines([Line|Lines]) --> line(Line), lines(Lines).

% eos([], []).

% line([])     --> ( "\n" ; call(eos) ), !.
% line([[range{start: S1, end: E1}, range{start: S2, end: E2}]|Ls]) --> [integer(S1), "-", integer(E1), ",", integer(S2), "-", intgers(E2)], line(Ls).

% :- initialization phrase_from_file(lines(Ls), 'input2'), writeln(Ls), halt.
% foo(X, Y) --> integer(X), "-", integer(Y).

% lines([])           --> call(eos), !.
% lines([Line|Lines]) --> line(Line), lines(Lines).

% eos([], []).

% line([])     --> ( "\n" ; call(eos) ), !.
% line([L|Ls]) --> [L], line(Ls).
% :- initialization phrase_from_file(lines(Ls), 'input'), writeln(Ls), halt.
% :- use_module(library(dcg/basics)).

% foo(X, Y) :-  Y is integer(X).
id([Id]) --> [Id].
id([Id|Ids]) --> [Id,'(', ids(Ids), ')'].

% ids([Id]) --> [Id].
% ids([Id|Ids]) --> [Id], ids(Ids).


% The DCG grammar for parsing a comma-delimited string of integers
% into a list of integers.

integer_list(L) -->
    integer(I),
    (",", integer_list(T), {L = [I|T]} ; {L = [I]}).

integer(I) -->
    digit(D0),
    digits(D),
    {number_codes(I, [D0|D])}.

digits([D|T]) -->
    digit(D),
    !,
    digits(T).
digits([]) --> [].

digit(D) -->
    [D],
    {code_type(D, digit)}.

% Example usage of the DCG grammar.

parse_integer_string(String, List) :-
    string_codes(String, Codes),
    phrase(integer_list(List), Codes).
