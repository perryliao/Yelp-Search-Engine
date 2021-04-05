:- use_module(api).

% Starts program
askUser() :-
    write("Search for Yelp Restaurants: "),
    flush_output(current_output),
    readln(Ln).


% Request response from Yelp API for category list


% Parse user query and change them to Yelp query parameters


% Store user query


% Request response from Yelp API for user query


% Return search result(s)


% Recommendation algorithm