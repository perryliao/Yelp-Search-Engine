:- ensure_loaded([api,dictionary]).

nearby('Vancouver').

% Starts program
askUser() :-
    write("Search for Yelp Restaurants: "),
    flush_output(current_output),
    readln(Ln),
    query(Ln, Constraints),
    search(Constraints, Result),
    return_results(Result.businesses).

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
parameters(category(Category), ('categories', Category)).
parameters(location('nearby'), ('location', Location)) :- nearby(Location).
parameters(location(Location), ('location', Location)) :- dif(Location, 'nearby').


% Choose to return the most fitting results from list of yelp responses
%choose_best(Response, Results) :-


% Return currently stored user query parameters to search for a restaurant
% Based on our smart recommendation system
%smart_query(Constraints) :-


% Store user query


% Recommendation algorithm


% Return search results
return_results([]) :-
    writeln("No restaurants were found with those descriptions. Maybe try again with a different query?").
return_results([Result | Rest]) :-
    writeln(""),
    write("Restaurant Name: "), writeln(Result.name),
    write("Categories: "), print_categories(Result.categories),
%    write("Price: "), writeln(Result.price), % not all results contain price
    write("Rating / Number of reviews: "), write(Result.rating), write(" / "), writeln(Result.review_count),
    write("Address: "), print_address(Result.location.display_address),
    write("Are you happy with this result? (yes/no):"),
    readln(Ln),
    check_end(Ln, Rest).

check_end([Ln], _) :-
    happy(Ln),
    writeln("See you again!").
check_end([Ln], Rest) :-
    unhappy(Ln),
    return_results(Rest).
check_end(_, Rest) :-
    write("Please enter (yes/no): "),
    readln(Ln),
    check_end(Ln, Rest).

print_categories([]) :- writeln("").
print_categories([Cat | Rest]) :-
    write(Cat.title), write(" "),
    print_categories(Rest).

print_address([]) :- writeln("").
print_address([Addr | Rest]) :-
    write(Addr), write(" "),
    print_address(Rest).

happy('Yes').
happy('Y').
happy('yes').
happy('y').

unhappy('No').
unhappy('N').
unhappy('no').
unhappy('n').
