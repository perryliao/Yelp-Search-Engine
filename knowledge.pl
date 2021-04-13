:- use_module(library(lists)).
:- ensure_loaded([api]).

set_categories(C) :-
    make_category_request(R),
    filter_categories(R, RestaurantCategories),
    filter_subcategories(R, RestaurantCategories, RestaurantSubCategories),
    sort_open(RestaurantCategories, RestaurantSubCategories, C).

save_yelp_categories(C) :-
    open('categoriesfile', append, Out),
    save_yelp_categories(Out, C),
    close(Out).

save_yelp_categories(_, []).
save_yelp_categories(Out, [Cat | Rest]) :-
    write(Out, Cat), writeln(Out, "."),
    save_yelp_categories(Out, Rest).

read_categories_file(Cat) :-
    open('categoriesfile', read, Str),
    read_file(Str,Lines),
    !, close(Str), nl,
    convert_categories_lines(Lines, Cat).

convert_categories_lines(['end_of_file'], []).
convert_categories_lines([H|T], [H|R]) :-
    convert_categories_lines(T, R).


filter_categories([], _).
filter_categories([C|Categories], [C.alias | Filtered]) :-
    member("restaurants", C.parent_aliases),
    filter_categories(Categories, Filtered).
filter_categories([C|Categories], [C.alias | Filtered]) :-
    member("food", C.parent_aliases),
    filter_categories(Categories, Filtered).
filter_categories([_|Categories], Filtered) :-
    filter_categories(Categories, Filtered).

filter_subcategories([], _, _).
filter_subcategories([C | Categories], RC, [C.alias | Filtered]) :-
    member(E, C.parent_aliases),
    member_open(E,RC), % there exists a member in R.parent_alises in RestaurantCategories
    filter_subcategories(Categories, RC, Filtered).
filter_subcategories([_ | Categories], RC, Filtered) :-
    filter_subcategories(Categories, RC, Filtered).

% https://stackoverflow.com/questions/37676839/open-list-and-member
member_open(_,X) :-
    var(X),
    !,
    fail.
member_open(X,[X|_]).
member_open(X,[_, Y|T]) :-
    nonvar(Y),
    member_open(X,[Y|T]).

% https://stackoverflow.com/questions/12713586/how-to-make-one-sorted-list-out-of-two-already-sorted-lists
sort_open([], [], []).
sort_open([], [H|T], [H|R]) :- sort_open([], T, R).
sort_open([H|T], [], [H|R]) :- sort_open(T, [], R).
sort_open([X],[H|T],L) :-
    \+var(X),
    L = [H|R],
    sort_open([], T, R).
sort_open([H|T],[Y],L) :-
    \+var(Y),
    L = [H|R],
    sort_open(T, [], R).
sort_open([Head1|Tail1], [Head2|Tail2], L) :-
    Head1 @< Head2 -> L = [Head1|R], sort_open(Tail1,[Head2|Tail2],R) ;
    Head1 @> Head2 -> L = [Head2|R], sort_open([Head1|Tail1],Tail2,R) ;
    L = [Head1,Head2|R], sort_open(Tail1,Tail2,R).

% debug
print_list([]).
print_list([A|B]) :-
  writeln(A),
  print_list(B).
