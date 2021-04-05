:- module(dictionary, [starter_phrase/2]).

starter_phrase(['What', 'is' | P], P).
starter_phrase(['What', '\'', 's' | T], T).
starter_phrase([Imperative | T], T) :-
    imperative(Imperative).
starter_phrase([Imperative, Asker | T], T) :-
    imperative(Imperative),
    asker(Asker).
starter_phrase(['I', 'want' | P], P).
starter_phrase(['I', 'want', 'to', 'eat' | P], P).

imperative('Give').
imperative('give').
imperative('Suggest').
imperative('suggest').
imperative('Recommend').
imperative('recommend').
imperative('Find').
imperative('find').

asker('me').
asker('us').

% ex. the cheapest Mexican restaurant in Vancouver
restaurant_description(P0, P8, Entity, C0, C8) :-
    det(P0, P1, Entity, C0, C1),
    adj(P1, P2, Entity, C1, C2),             % one adjective only
    category(P2, P3, Entity, C2, C3),        % one category only
    keyword(P3, P4, Entity, C3, C4),         % remaining terms
    prep(P4, P5, Entity, C4, C5),
    location(P5, P6, Entity, C5, C6).

det(['a' | P], P, _, C, C).
det(['an' | P], P, _, C, C).
det(['the' | P], P, _, C, C).
det(P, P, _, C, C).

adj(['cheapest' | P], P, _, [price(1, 'LessThan')|C], C).
adj(['cheap' | P], P, _, [price(2, 'LessThan')|C], C).
adj(['fancy' | P], P, _, [price(3, 'GreaterThan'), rating(4, 'GreaterThan') |C], C).
adj(['expensive' | P], P, _, [price(4, 'EqualTo') |C], C).
adj(['good' | P], P, _, [rating(3, 'GreaterThan') |C], C).
adj(['great' | P], P, _, [rating(4, 'GreaterThan') |C], C).
adj(['amazing' | P], P, _, [rating(5, 'EqualTo') |C], C).
adj(['best' | P], P, _, [rating(5, 'EqualTo') |C], C).
adj(['worst' | P], P, _, [rating(1, 'EqualTo') |C], C).
adj(P, P, _, C, C).

