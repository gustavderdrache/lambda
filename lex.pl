:- module(lex, [ lambda/3, readline/1 ]).

name(Name) -->
    name_first(Ch),
    name_chars(Rest),
    { atom_codes(Name, [Ch | Rest])
    }.

name_first(Ch) -->
    [Ch],
    { code_type(Ch, csymf)
    }.

name_char(Ch) -->
    [Ch],
    { code_type(Ch, csym)
    }.

name_chars([Ch | Rest]) -->
    name_char(Ch), !,
    name_chars(Rest).

name_chars([]) -->
    [].

ws -->
    [Ch],
    { code_type(Ch, space)
    }, !,
    ws.

ws --> [].

lambda(fun(Arg, Body)) -->
    "\\", !,
    ws,
    name(Arg),
    ws,
    ".",
    ws,
    lambda(Body).

lambda(apply(Fun, Arg)) -->
    "(", !,
    ws,
    lambda(Fun),
    ws,
    lambda(Arg),
    ws,
    ")".

lambda(Name) -->
    name(Name).

readline(Term) :-
    read_line_to_codes(user_input, Codes),
    phrase(lambda(Term), Codes).
