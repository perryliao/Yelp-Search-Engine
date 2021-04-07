:- use_module(api).

% Starts program
askUser() :-
    write("Search for Yelp Restaurants: "),
    flush_output(current_output),
    readln(Ln),
    query(Ln, Constraints),
    search(Constraints, Result),
    return_results(Result).

% Parse regular restaurant query
query(P0, Constraints) :-
    query_head(P0, P1),
    restaurant_query(P1, _, _, Constraints, _).

% Parse Im feeling lucky smart restaurant query
query(['I\'m', 'feeling', 'lucky'], Constraints) :-
    smart_query(Constraints).


% Request response from Yelp API for category list


% Parse user query and change them to Yelp query parameters


% Store user query


% Request response from Yelp API for user query


% Return search result(s)


% Recommendation algorithm