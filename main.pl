:- ensure_loaded([api,dictionary, result_handler]).


% Starts program
init() :-
    set_categories(C),
    save_yelp_categories(C).

askUser() :-
    write("Search for Yelp Restaurants: "),
    flush_output(current_output),
    readln(Ln),
    query(Ln, Constraints, Params),
    search(Constraints, Result, Params),
    return_results(Result.businesses).
askUser() :-
    write("That doesn't sound like a valid query. Why don't you try something else?").

% Parse Im feeling lucky smart restaurant query
query(['I', '\'', 'm', 'feeling', 'lucky'], _, Params) :-
    smart_query(Params).

% Parse regular restaurant query
query(P0, Constraints, _) :-
    dif(P0, ['I', '\'', 'm', 'feeling', 'lucky']),
    query_head(P0, P1),
    restaurant_query(P1, _, Constraints, _).

% Search Yelp Database and make API call
search(Constraints, Results, _) :-
    nonvar(Constraints),
    parse_query(Constraints, Params),
    search_yelp_business(Params, Results).
search(_, Results, Params) :-
    search_yelp_business(Params, Results).

% Parse user query and change them to Yelp query parameters
parse_query([], []).
parse_query([Constraint|T], [Param|P]) :-
    parameters(Constraint, Param),
    parse_query(T, P).

parameters(rating(Rating), ('rating', Rating)).
parameters(price(Price), ('price', Price)).
parameters(term(Keyword), ('term', Keyword)).
parameters(category(Category), ('categories', Category)).
parameters(location(Location), ('location', Location)).

% Return currently stored user query parameters to search for a restaurant
% Based on our smart recommendation system
smart_query(Params) :-
    read_results(Cache),
    get_popular_categories(Cache, Categories),
    make_category_pair(Categories, Res),
    append([('term', 'restaurant'), ('location', 'vancouver')], Res, Params).

% find the most popular categor(ies)
get_popular_categories(Cache, Result) :-
    get_largest_entries(Cache, Cache.categories, _, Result).

get_largest_entries(Cache, [], H, Result) :-
    get_popular_categories_entries(Cache, Cache.categories, H, Result).
get_largest_entries(Cache, [C | R], Highest, Result) :-
    var(Highest),
    get_largest_entries(Cache, R, Cache.get(C), Result).
get_largest_entries(Cache, [C | R], Highest, Result) :-
    X = Cache.get(C),
    X > Highest,
    get_largest_entries(Cache, R, X, Result).
get_largest_entries(Cache, [_ | R], Highest, Result) :-
    get_largest_entries(Cache, R, Highest, Result).

get_popular_categories_entries(_, [], _, []).
get_popular_categories_entries(Cache, [C | R], H, [C | F]) :-
    X = Cache.get(C),
    X = H,
    get_popular_categories_entries(Cache, R, H, F).
get_popular_categories_entries(Cache, [_ | R], H, F) :-
    get_popular_categories_entries(Cache, R, H, F).

make_category_pair([], []).
make_category_pair(Categories, [('categories', String)]) :-
    atomic_list_concat(Categories, ',', Atom),
    atom_string(Atom, String).
