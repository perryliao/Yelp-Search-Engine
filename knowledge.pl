:- use_module(library(lists)).
:- ensure_loaded([api]).

set_categories(C) :-
    make_category_request(R),
    filter_categories(R, RestaurantCategories),
    filter_subcategories(R, RestaurantCategories, RestaurantSubCategories),
    append(RestaurantCategories, RestaurantSubCategories, C).

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
member_open(X,Y) :-
    \+var(Y),
    Y = [X|_].
member_open(X,Y) :-
    \+var(Y),
    Y = [_|T],
    member_open(X,T).

% debug
print_list([]).
print_list([A|B]) :-
  writeln(A),
  print_list(B).
