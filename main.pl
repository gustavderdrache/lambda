:- use_module(environ).
:- use_module(interact).
:- use_module(lex).

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

loop :-
    read_line_to_codes(user_input, Codes),
    (
        Codes = end_of_file
    ->
        true
    ;
        run_phrase(Codes),
        loop
    ).

run_phrase(Phrase) :-
    (
        phrase(lambda(Expr), Phrase)
    ->
        eval(Expr)
    ;
        write('Couldn\'t make sense of input...'), nl
    ).

main :-
    bind_defaults,
    loop.
