:- use_module(api).

% Starts program
askUser() :-
    write("Search for Yelp Restaurants: "),
    flush_output(current_output),
    readln(Ln).
