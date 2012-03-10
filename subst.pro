:- module(subst, [ subst/4, alistsub/3 ]).

:- use_module(util).

%%%
% Substitution rules
%
%%
% subst/4(+var, +value, +term, -replaced)
%
% Replaces all occurences of `var' with `value' in `term'.
%
%%
% subst/5(+var, +value, +boundvars, +term, -value)
%
% Replaces all occurences of `var' with `value' in `term', unless `var' is in
% the `boundvars' list.
%
%%
% alistsub/3(+alist, +term, -result)
%
% Replaces every [Key, Value] pair in `term'.  Identical to repeatedly calling
% subst/4, but friendlier.


%% subst/4

% rule 1: x[x := N] ==> N
%         y[x := N] ==> y
subst(Var, Value, Term, Value) :- same(Var, Term).
subst(Var, _,     Term, Term)  :- diff(Var, Term).

% rule 2: (\x.E)[x := N] ==> \x.E
%         (\y.E)[x := N] ==> \y.(E[x := N])
subst(Var, _,     fun(Arg, Body), fun(Arg, Body))       
    :- same(Var, Arg).
subst(Var, Value, fun(Arg, Body), fun(Arg, Substituted))
    :- diff(Var, Arg)
    -> subst(Var, Value, [Arg], Body, Substituted).

% rule 3: (M N)[x := E] ==> M[x := E] N[x := E]
subst(Var, Value, apply(Fun, Body), apply(SubstFun, SubstBody))
    :- subst(Var, Value, Fun, SubstFun)
    -> subst(Var, Value, Body, SubstBody).

%% subst/5

% rule 1: x[x := N] ==> x if x is bound, N otherwise
%         y[x := N] ==> y
subst(Var, _,    Bound, Term, Term)
    :-
    (    same(Var, Term)
      -> member(Term, Bound)
      -> !
    )
    ; diff(Var, Term).
subst(Var, Value, _,    Term, Value) :- same(Var, Term), !.

% rule 2: (\x.E)[x := N] ==> \x.E
%         (\y.E)[x := N] ==> \y.E if x free in E, \y.(E[x := N]) otherwise
subst(Var, _,     _,     fun(Arg, Body), fun(Arg, Body))
    :- same(Var, Arg), !.
subst(Var, Value, Bound, fun(Arg, Body), fun(Arg, Replaced))
    :- diff(Var, Arg)
    -> subst(Var, Value, [Arg | Bound], Body, Replaced), !.

subst(Var, Value, Bound, apply(Fun, Body), apply(FunSubst, BodySubst))
    :- subst(Var, Value, Bound, Fun,  FunSubst)
    -> subst(Var, Value, Bound, Body, BodySubst), !.

%%% 

alistsub([], Result, Result).
alistsub([[Var, Value] | Env], Term, Result)
    :- subst(Var, Value, Term, Expr),
       alistsub(Env, Expr, Result). 
