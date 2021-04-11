:- ensure_loaded([knowledge]).

query_head(['What', 'is' | P], P).
query_head(['What', '\'', 's' | T], T).
query_head([Imperative | T], T) :-
    imperative(Imperative).
query_head(['I', 'want' | P], P).
query_head(['I', 'want', 'to', 'eat' | P], P).
query_head(P, P).

imperative('Give').
imperative('give').
imperative('Suggest').
imperative('suggest').
imperative('Recommend').
imperative('recommend').


% ex. the cheapest Mexican restaurant in Vancouver
restaurant_query(P0, P7, C0, C7) :-
    det(P0, P1, C0, C1),
    adj(P1, P2, C1, C2),             % one adjective only
    category(P2, P3, C2, C3),        % one category only
    keyword(P3, P4, C3, C4),         % remaining terms
    prep(P4, P5, C4, C5),
    det(P5, P6, C5, C6),
    location(P6, P7, C6, C7).

det(['a' | P], P, C, C).
det(['an' | P], P, C, C).
det(['the' | P], P, C, C).
det(P, P, C, C).

adj(['cheapest' | P], P, [price('1')|C], C).
adj(['cheap' | P], P, [price('1,2')|C], C).
adj(['fancy' | P], P, [price('4'), rating('4,5') |C], C).
adj(['expensive' | P], P, [price('4') |C], C).
adj(['good' | P], P, [rating('3,4,5') |C], C).
adj(['great' | P], P, [rating('4,5') |C], C).
adj(['amazing' | P], P, [rating('5') |C], C).
adj(['best' | P], P, [rating('5') |C], C).
adj(['worst' | P], P, [rating('1') |C], C).
adj(P, P, C, C).

category([L | P], P, [category(L)| C], C) :-
    set_categories(Categories),
    member_open(L, Categories).

keyword(['restaurant' | P], P, [term('restaurant')| C], C).
keyword(['food' | P], P, [term('restaurant')| C], C).
keyword(['place' | P], P, [term('restaurant')| C], C).
keyword(P, P, [term('restaurant')| C], C).

location([L | P], P, [location(L)| C], C).

prep(['in' | P], P, C, C).
prep(['of' | P], P, C, C).
prep(['on' | P], P, C, C).
prep(['at' | P], P, C, C).
prep(['by' | P], P, C, C).
prep(['down' | P], P, C, C).
prep(['within' | P], P, C, C).
prep(P, P, C, C).