starter_phrase(['What', 'is' | P], P).
starter_phrase(['What', '\'', 's' | T], T).
starter_phrase([Imperative | T], T) :-
    imperative(Imperative).
starter_phrase([Imperative, Pronoun | T], T) :-
    imperative(Imperative),
    pronoun(Pronoun).
starter_phrase(['I', 'want' | P], P).
starter_phrase(['I', 'want', 'to', 'eat' | P], P).
starter_phrase('I\'m', 'feeling', 'lucky').

imperative('Give').
imperative('give').
imperative('Suggest').
imperative('suggest').
imperative('Recommend').
imperative('recommend').
imperative('Find').
imperative('find').

pronoun('me').
pronoun('us').

% ex. the cheapest Mexican restaurant in Vancouver
restaurant_description(P0, P7, Entity, C0, C7) :-
    det(P0, P1, Entity, C0, C1),
    adj(P1, P2, Entity, C1, C2),             % one adjective only
    category(P2, P3, Entity, C2, C3),        % one category only
    keyword(P3, P4, Entity, C3, C4),         % remaining terms
    prep(P4, P5, Entity, C4, C5),
    det(P5, P6, Entity, C5, C6),
    location(P6, P7, Entity, C6, C7).

det(['a' | P], P, _, C, C).
det(['an' | P], P, _, C, C).
det(['the' | P], P, _, C, C).
det(P, P, _, C, C).

adj(['cheapest' | P], P, _, [price('1')|C], C).
adj(['cheap' | P], P, _, [price('1,2')|C], C).
adj(['fancy' | P], P, _, [price('4'), rating('4,5') |C], C).
adj(['expensive' | P], P, _, [price('4') |C], C).
adj(['good' | P], P, _, [rating('3,4,5') |C], C).
adj(['great' | P], P, _, [rating('4,5') |C], C).
adj(['amazing' | P], P, _, [rating('5') |C], C).
adj(['best' | P], P, _, [rating('5') |C], C).
adj(['worst' | P], P, _, [rating('1') |C], C).
adj(P, P, _, C, C).

keyword(P3, P4, _, C, C)
keyword(P, P, _, C, C).

prep(['in' | P], P, _, C, C).
prep(['of' | P], P, _, C, C).
prep(['on' | P], P, _, C, C).
prep(['at' | P], P, _, C, C).
prep(['by' | P], P, _, C, C).
prep(['down' | P], P, _, C, C).
prep(['within' | P], P, _, C, C).
prep(P, P, _, C, C).

location([L| P], P, L, C, C) :- isCanada(L).
location([L| P], P, L, C, C) :- inCanada(L).
location(['near me' | P], P, _, C, C).
location(['area' | P], P, _, C, C).
location(['city' | P], P, _, C, C).
location(['block' | P], P, _, C, C).
location(['community' | P], P, _, C, C).
location(['neighborhood' | P], P, _, C, C).
location(['Canada' | P], P, _, C, C).
location(['canada' | P], P, _, C, C).

% isCanada(C) is true if C is Canada
isCanada('Canada').
isCanada('canada').
isCanada('can').
