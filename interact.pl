:- module(interact, [ eval/1, pprint/1 ]).

:- use_module(environ).
:- use_module(eval).
:- use_module(subst).

% interaction code (friendlier toplevel stuff)
eval(Term) :-
    bindings(Env),
    list_subst(Env, Term, Expr),
    evaluate(Expr, Result),
    pprint(Result), nl.

pprint(apply(Fun, Arg)) :-
    write('('),
    pprint(Fun),
    write(' '),
    pprint(Arg),
    write(')').

pprint(fun(Arg, Body)) :-
    write('λ'),
    pprint(Arg),
    write('.'),
    pprint(Body).

pprint(Term) :-
    atom(Term),
    write(Term).

