:- module(environ, [ bindings/1
                   , op(900, xfx, (:=))
                   , (:=)/2
                   ]).

:- use_module(term, [term/1]).

:- dynamic(bound/2).

:- op(900, xfx, :=).
Var := Term :- 
    atom(Var),
    term(Term),
    ignore(unbind(Var)),
    asserta(bound(Var, Term)), !.

:- op(1, fx, unbind).
unbind(Var) :-
    (bound(Var, _) -> retract(bound(Var, _)))
    ; true.

bindings(Environment) :- findall([Var, Value], bound(Var, Value), Environment).
