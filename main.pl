:- ensure_loaded([api,dictionary, result_handler]).


% Starts program
askUser() :-
    write("Search for Yelp Restaurants: "),
    flush_output(current_output),
    readln(Ln),
    query(Ln, Constraints, Params),
    search(Constraints, Result, Params),
    return_results(Result.businesses).

% Parse Im feeling lucky smart restaurant query
query(['I', '\'', 'm', 'feeling', 'lucky'], _, Params) :-
    smart_query(Params).

% Parse regular restaurant query
query(P0, Constraints, _) :-
    dif(P0, ['I', '\'', 'm', 'feeling', 'lucky']),
    query_head(P0, P1),
    dif(P0, ['I','\'','m', 'feeling', 'lucky']),
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
    % TODO: read results and put into params
    Params = [('categories', 'tacos'), ('term', 'restaurant'), ('location', 'vancouver')].
