:- use_module(eval).

:- begin_tests(evaluation).

:- op(100, xfx, reduces_to).
x reduces_to x.
apply(fun(x, x), y) reduces_to y.
apply(fun(x, x), x) reduces_to x.

apply(apply(AND, TRUE), FALSE) reduces_to FALSE :-
    AND   = fun(p, fun(q, apply(apply(p, q), p))),
    TRUE  = fun(x, fun(y, x)),
    FALSE = fun(x, fun(y, y)).

apply(apply(AND, FALSE), TRUE) reduces_to FALSE :-
    AND   = fun(p, fun(q, apply(apply(p, q), p))),
    TRUE  = fun(x, fun(y, x)),
    FALSE = fun(x, fun(y, y)).

apply(apply(AND, TRUE), TRUE) reduces_to TRUE :-
    AND   = fun(p, fun(q, apply(apply(p, q), p))),
    TRUE  = fun(x, fun(y, x)).

apply(apply(AND, FALSE), FALSE) reduces_to FALSE :-
    AND   = fun(p, fun(q, apply(apply(p, q), p))),
    FALSE = fun(x, fun(y, y)).

apply(SUCC, ZERO) reduces_to ONE :-
    SUCC = fun(n, fun(f, fun(x, apply(f, apply(apply(n, f), x))))),
    ZERO = fun(f, fun(x, x)),
    ONE  = fun(f, fun(x, apply(f, x))).

apply(apply(MULT, TWO), TWO) reduces_to FOUR :-
    MULT = fun(m, fun(n, fun(f, apply(m, apply(n, f))))),
    TWO  = fun(f, fun(x, apply(f, apply(f, x)))),
    FOUR = fun(f, fun(x, apply(f, apply(f, apply(f, apply(f, x)))))).

fun(x, apply(fun(x, x), x)) reduces_to fun(x, x).
fun(x, apply(fun(x, y), x)) reduces_to fun(x, y).
fun(y, apply(fun(y, x), y)) reduces_to fun(y, x).
fun(y, apply(fun(x, x), y)) reduces_to fun(y, y).

apply(f, apply(fun(x, x), y)) reduces_to apply(f, y).

test(eval, [forall(Term reduces_to Expected)]) :-
    evaluate(Term, Result),
    Result = Expected.

:- end_tests(evaluation).

:- (run_tests ; format(':(~n')), halt.
