%%% api.pl calls the YELP API to send our search query

%%% Standard Library Modules
:- use_module(library(http/http_client)).
:- use_module(library(http/json)).
:- use_module(library(uri)).

%%% User-Defined Modules
:- ensure_loaded([secrets]). 

yelp_business_url("https://api.yelp.com/v3/businesses/search?").
result_limit("10").

% HTTP GET request for Yelp
search_yelp_business(Query, Response) :- 
  yelp_business_url(Url),                                % access yelp business api
  yelp_api_key(ApiKey),                                  % access yelp api key
	generate_url(Url, Query, RequestUrl),                  % change to yelp api query parameters
	http_get(RequestUrl, Json, [authorization(bearer(ApiKey))]),
  atom_json_dict(Json, Response, []).


% Generates the correct URL with the provided query params.
generate_url(Url, Params, NewUrl) :-
	add_limit_param(Url, NextUrl),
	query_params(NextUrl, Params, NewUrl).

% Add initial paramter for the limit of number of yelp results
add_limit_param(Url, NewUrl) :-
	result_limit(limit),
	string_concat("?limit=", limit, UrlEnd),
	string_concat(Url, UrlEnd, NewUrl).

% Turn parameters list into url
query_params(Url, [], Url).
query_params(Url, [(Key, Val)|Tail], NewUrl) :- 
	paramterize(Key, Val, Param),
	string_concat(Url, Param, NextUrl),
	query_params(NextUrl, Tail, NewUrl).

% Takes each key val pair and turn them into "&" + Key + "=" + Val
paramterize(Key, Val, Param) :-
	string_concat("&", Key, Front),
	string_concat("=", Val, Back),
	string_concat(Front, Back, Param).
