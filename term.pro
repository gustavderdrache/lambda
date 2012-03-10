% vi:syn=prolog

:- module(term, [ term/1, 'term<->list'/2 ]).

term(apply(X, Y)) :- term(X), term(Y).
term(fun(X, Y))   :- atom(X), term(Y).
term(X)           :- atom(X), !.

'term<->list'(List, Term) :- Term =.. List, !, term(Term).
