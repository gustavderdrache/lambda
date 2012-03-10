:- module(interact, [ op(1, fx, eval), eval/1, pprint/1 ]).

:- use_module('environ.pro').
:- use_module('alist.pro').
:- use_module('eval.pro').
:- use_module('subst.pro').

% interaction code (friendlier toplevel stuff)
:- op(1, fx, eval).
eval(Term)
    :- bindings(Env),
       alistsub(Env, Term, Expr),
       evaluate(Expr, Result),
       pprint(Result), nl, !.

pprint(Term)
    :- atom(Term)
    -> write(Term).
pprint(apply(Fun, Arg))
    :- write('(')
    -> pprint(Fun)
    -> write(' ')
    -> pprint(Arg)
    -> write(')').
pprint(fun(Arg, Body))
    :- write('λ')
    -> pprint(Arg)
    -> write('.')
    -> pprint(Body).
