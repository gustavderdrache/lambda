:- use_module('environ.pro').
:- use_module('interact.pro').
:- use_module('lex.pro').

bind_defaults :-
    % ZERO := λf.λx.x
    zero := fun(f, fun(x, x)),

    % SUCC := λn.λf.λx.f (n f x)
    succ := fun(n, fun(f, fun(x,
                apply(f, apply(apply(n, f), x))))),


    % PLUS := λm.λn.λf.λx.m f (n f x)
    plus := fun(m, fun(n, fun(f, fun(x,
                apply(apply(m, f), apply(apply(n, f), x)))))),

    % MULT := λm.λn.λf.m (n f)
    mult := fun(m, fun(n, fun(f, apply(m, apply(n, f))))),

    % TRUE := λx.λy.x
    true := fun(x, fun(y, x)),

    % FALSE := λx.λy.y
    false := fun(x, fun(y, y)),

    % AND := λp.λq.p q p
    and := fun(p, fun(q, apply(apply(p, q), p))).

loop :- peek_char(Ch), char_type(Ch, end_of_file), nl, halt.
loop :- ignore((readline(Expr), eval Expr)), loop.

:- bind_defaults, loop.
