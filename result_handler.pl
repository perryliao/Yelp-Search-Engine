happy('Yes').
happy('Y').
happy('yes').
happy('y').

unhappy('No').
unhappy('N').
unhappy('no').
unhappy('n').

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
    write("Are you happy with this result? (yes/no): "),
    readln(Ln),
    check_end(Ln, Result, Rest).

check_end([Ln], Result, _) :-
    happy(Ln),
    save_results(Result.categories),
    writeln("See you again!").
check_end([Ln], _, Rest) :-
    unhappy(Ln),
    return_results(Rest).
check_end(_, Result, Rest) :-
    write("Please enter (yes/no): "),
    readln(Ln),
    check_end(Ln, Result, Rest).

print_categories([]) :- writeln("").
print_categories([Cat | Rest]) :-
    write(Cat.title), write(" "),
    print_categories(Rest).

print_address([]) :- writeln("").
print_address([Addr | Rest]) :-
    write(Addr), write(" "),
    print_address(Rest).

save_results(ResultCategories) :-
    open('userdata', append, Out),
    save_categories(Out, ResultCategories),
    close(Out).

save_categories(_, []).
save_categories(Out, [Cat | Rest]) :-
    write(Out, Cat.alias), writeln(Out, "."),
    save_categories(Out, Rest).

clear_cache() :-
    open('userdata', write, Out),
    writeln(Out, "restaurants."),
    close(Out).

convert_to_dict(['end_of_file'], D, D).
convert_to_dict([C | R], D, Dict) :-
    X = D.get(C),
    N is X + 1,
    convert_to_dict(R, D.put(C, N), Dict).
convert_to_dict([C | R], D, Dict) :-
    append(D.get('categories'), [C], New),
    D1 = D.put('categories', New),
    convert_to_dict(R, D1.put(C, 1), Dict).

% https://stackoverflow.com/questions/4805601/read-a-file-line-by-line-in-prolog
read_results(Dict) :-
    read_result_helper(Lines),
    convert_to_dict(Lines, _{categories:[]}, Dict).

read_result_helper(Lines):-
    open('userdata', read, Str),
    read_file(Str,Lines),
    close(Str), nl.

read_file(Stream,[]) :-
    at_end_of_stream(Stream).

read_file(Stream,[X|L]) :-
    \+ at_end_of_stream(Stream),
    read(Stream,X),
    read_file(Stream,L).
