:- module(lex, [ readline/1 ]).

lambda(Value)           --> [tok(name, Value)].
lambda(fun(Arg, Body))  --> [tok('\\')]
                         -> [tok(name, Arg)]
                         -> [tok('.')]
                         -> lambda(Body).
lambda(apply(Fun, Arg)) --> [tok('(')]
                         -> lambda(Fun)
                         -> lambda(Arg)
                         -> [tok(')')].

lt(X, Y) :- compare(<, X, Y).
le(X, Y) :- compare(<, X, Y) ; compare(=, X, Y).

gt(X, Y) :- compare(>, X, Y).
ge(X, Y) :- compare(>, X, Y) ; compare(=, X, Y).

lcase(Ch) :- ge(Ch, a), le(Ch, z).
ucase(Ch) :- ge(Ch, 'A'), le(Ch, 'Z').

letter(Ch) :- lcase(Ch) ; ucase(Ch).

skipws :- (peek_char(' ') -> get_char(_) -> skipws) ; true.

lexer([]) :- skipws, peek_char('\n') -> get_char(_).
lexer([tok(Sym) | Tokens]) :-
    skipws,
    peek_char(Sym),
    member(Sym, ['\\', '.', '(', ')']),
    get_char(_),
    lexer(Tokens).

lexer([tok(name, Tok) | Tokens]) :-
    skipws,
    peek_char(Ch),
    letter(Ch),
    read_name(Tok),
    lexer(Tokens), !.

read_name(Word) :- read_name([], Word).
read_name(Chars, Tok) :-
    peek_char(Ch),
    char_type(Ch, alpha),
    get_char(_),
    append(Chars, [Ch], CharList),
    read_name(CharList, Tok), !.

read_name(Chars, Tok) :-
    atom_chars(Tok, Chars), !.

readline(Expr) :- lexer(Tokens), lambda(Expr, Tokens, _), !.
