% vi:syn=prolog

:- module(eval, [ evaluate/2 ]).

:- use_module(term).
:- use_module(subst).

% helper rule
reducible(apply(fun(_, _), _)).
reducible(apply(Fun, _))  :- reducible(Fun).
reducible(apply(_, Body)) :- reducible(Body).
reducible(fun(_, Body))   :- reducible(Body).

evaluate(apply(fun(Arg, Expr), Body), Result)
    :- subst(Arg, Body, Expr, Stuff)
    -> evaluate(Stuff, Result), !.

evaluate(apply(Fun, Body), Result) :-
    evaluate(Fun, AFun),
    evaluate(Body, ABody),
     % if the application reduces to another reducible form, evaluate again
     % (solves the issues of ((\f.\x.f x) g) y
    (reducible(apply(AFun, ABody)) -> evaluate(apply(AFun, ABody), Result)
    ; Result = apply(AFun, ABody)),
    !.

evaluate(fun(Arg, Body), fun(Arg, Result)) :-
    evaluate(Body, Result), !.

evaluate(Term, Term).
