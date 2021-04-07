:- ensure_loaded([api, knowledge]).

% Initialize the program
init() :-
    set_categories(C).

% Starts program
askUser() :-
    write("Search for Yelp Restaurants: "),
    flush_output(current_output),
    readln(Ln).
