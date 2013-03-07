:- module(eval, [ evaluate/2 ]).

:- use_module(subst).

% helper rule
reducible(apply(fun(_, _), _)).
reducible(apply(Fun, _))  :- reducible(Fun).
reducible(apply(_, Body)) :- reducible(Body).
reducible(fun(_, Body))   :- reducible(Body).

evaluate(apply(fun(Arg, Expr), Body), Result) :-
    subst(Arg, Body, Expr, Stuff), !,
    evaluate(Stuff, Result).

evaluate(apply(Fun, Body), Result) :-
    evaluate(Fun, AFun),
    evaluate(Body, ABody),
    Expr = apply(AFun, ABody),
    (
        reducible(Expr)
    ->
        evaluate(Expr, Result)
    ;
        Result = Expr
    ).

evaluate(fun(Arg, Body), fun(Arg, Result)) :-
    evaluate(Body, Result).

evaluate(Term, Term).
