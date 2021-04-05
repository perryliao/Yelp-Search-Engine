%%% api.pl calls the YELP API to send our search query

%%% Standard Library Modules
:- use_module(library(http/http_client)).
:- use_module(library(http/json)).
:- use_module(library(uri)).

%%% User-Defined Modules
:- ensure_loaded([secrets]). 

yelp_business_url("https://api.yelp.com/v3/businesses/search").


% Checking for errors
try_search(QueryParams, Response) :-
  catch(
    search_yelp_business(QueryParams, Response),
    Error,
    print_message(error, Error)
).

% Send search query
search_yelp_business(QueryParams, Response) :-
    yelp_business_url(Url),
	add_query_params(Url, QueryParams, RequestUrl).
	make_request(RequestUrl, Response).

% Adds query parameters to given url.
add_query_params(Url, [], Url).
add_query_params(Url, [(Key, Val)|Tail], NewUrl) :- 
	make_query_param(Key, Val, Param),
	string_concat(Url, Param, NextUrl),
	add_query_params(NextUrl, Tail, NewUrl).

% Transforms key, val => "&" + Key + "=" + Val
make_query_param(Key, Val, Param) :-
	string_concat("&", Key, Front),
	string_concat("=", Val, Back),
	string_concat(Front, Back, Param).

%%% Make HTTP GET call to URL which will receive a JSON Response
make_search_request(Url, Response) :-
    yelp_api_key(ApiKey),
	http_get(Url, JsonResponse, [authorization(bearer(ApiKey))]),
	atom_json_dict(JsonResponse, Response, []).
