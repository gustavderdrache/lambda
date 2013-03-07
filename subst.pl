:- module(subst, [ subst/4, list_subst/3 ]).

list_subst([], Term, Term).
list_subst([Var - Value | Env], Term, Result) :-
    subst(Var, Value, Term, Expr),
    list_subst(Env, Expr, Result).

%% subst/4

% rule 2: (\x.E)[x := N] ==> \x.E
%         (\y.E)[x := N] ==> \y.(E[x := N])
subst(Var, Value, fun(Arg, Body), fun(Arg, Subst)) :-
    (
        Var == Arg
    ->
        Subst = Body
    ;
        subst(Var, Value, [Arg], Body, Subst)
    ).

% rule 3: (M N)[x := E] ==> M[x := E] N[x := E]
subst(Var, Value, apply(Fun, Body), apply(SubstFun, SubstBody)) :-
    subst(Var, Value, Fun, SubstFun),
    subst(Var, Value, Body, SubstBody).

% rule 1: x[x := N] ==> N
%         y[x := N] ==> y
subst(Var, Value, Term, Result) :-
    atom(Term), !,
    (
        Var == Term
    ->
        Result = Value
    ;
        Result = Term
    ).

%% subst/5

% rule 2: (\x.E)[x := N] ==> \x.E
%         (\y.E)[x := N] ==> \y.E if x free in E, \y.(E[x := N]) otherwise
subst(Var, Value, Bound, fun(Arg, Body), fun(Arg, Replaced)) :-
    (
        Var \= Arg
    ->
        subst(Var, Value, [Arg | Bound], Body, Replaced)
    ;
        Replaced = Body
    ).

subst(Var, Value, Bound, apply(Fun, Body), apply(FunSubst, BodySubst)) :-
    subst(Var, Value, Bound, Fun,  FunSubst),
    subst(Var, Value, Bound, Body, BodySubst).

% rule 1: x[x := N] ==> x if x is bound, N otherwise
%         y[x := N] ==> y
subst(Var, Value, Bound, Term, Subst) :-
    atom(Term), !,
    (
        Var \= Term
    ->
        Subst = Term
    ;
        memberchk(Term, Bound)
    ->
        Subst = Term
    ;
        Subst = Value
    ).

