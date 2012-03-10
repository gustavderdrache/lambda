% vi:syn=prolog

:- module(util, [ same/2, diff/2 ]).

%%% misc util functions
same(X, Y) :- atom(X), atom(Y), X  == Y.
diff(X, Y) :- atom(X), atom(Y), X \== Y.
