:- use_module(api).
:- use_module(dictionary).

nearby('Vancouver').

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

% Search Yelp Database and make API call
search(Constraints, Results) :-
    parse_query(Constraints, Params),
    search_yelp_business(Params, Response),
    choose_best(Response.results, Results).

% Parse user query and change them to Yelp query parameters
parse_query([], []).
parse_query([Constraint|T], [Param|P]) :-
    parameters(Constraint, Param),
    parse_query(T, P).

parameters(rating(Rating), ('rating', Rating)).
parameters(price(Price), ('price', Price)).
parameters(term(Keyword), ('term', Keyword)).
parameters(location('nearby'), ('location', Location)) :- nearby(Location).
parameters(location(Location), ('location', Location)) :- dif(Location, 'nearby').


% Choose to return the most fitting results from list of yelp responses
choose_best(Response, Results) :-


% Return currently stored user query parameters to search for a restaurant 
% Based on our smart recommendation system
smart_query(Constraints) :-


% Store user query


% Recommendation algorithm


% Return search results
return_results([]) :- 
    writeln("No restaurants were found with those descriptions.").
return_results(Result) :-
    writeln(Result.restaurant_name),
    writeln(Result.restaurant_price),
    writeln(Result.restaurant_rating),
    writeln(Result.restaurant_address).
