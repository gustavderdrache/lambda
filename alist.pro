:- module(alist, [ alistref/3, alistmember/2 ]).

:- use_module(util).

% is alist?
alist([]).
alist([[_, _] | Tail]) :- alist(Tail).

% how to retrieve a thing from the alist
alistref(Key, [[Key, Value] | _], Value).
alistref(Key, [[_, _] | Rest],    Value) :- alistref(Key, Rest, Value).

% remove an association from a list
alistunref(Key, [[Var, _] | Rest], Rest)
    :- same(Key, Var), !.

alistunref(Key, [[Var, Value] | Rest], [[Var, Value] | Filtered])
    :- diff(Key, Var),
       alistunref(Key, Rest, Filtered).

% is Key a key in the alist?
alistmember(Key, Alist) :- alistref(Key, Alist, _).
