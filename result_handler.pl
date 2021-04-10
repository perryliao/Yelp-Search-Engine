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
check_end(_, _, Rest) :-
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

save_results(ResultCategories) :-
    open('userdata', write, Out),
    save_categories(Out, ResultCategories),
    close(Out).

save_categories(_, []).
save_categories(Out, [Cat | Rest]) :-
    writeln(Out, Cat.alias),
    save_categories(Out, Rest).
