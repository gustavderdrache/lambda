:- module(environ, [ bindings/1
                   , op(900, xfx, (:=))
                   , (:=)/2
                   ]).

:- dynamic(bound/2).

:- op(900, xfx, :=).
Var := Term :- 
    atom(Var),
    unbind(Var),
    asserta(bound(Var, Term)), !.

unbind(Var) :-
    (
        bound(Var, _)
    ->
        retract(bound(Var, _))
    ;
        true
    ).

bindings(Environment) :-
    findall(Var - Value, bound(Var, Value), Environment).
