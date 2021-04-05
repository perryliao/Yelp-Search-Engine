%%% api.pl calls the YELP API to send our search query

%%% Standard Library Modules
:- use_module(library(http/http_client)).
:- use_module(library(http/json)).
:- use_module(library(uri)).

%%% User-Defined Modules
:- ensure_loaded([secrets]). 

yelp_business_url("https://api.yelp.com/v3/businesses/search").


% HTTP GET request for Yelp
search_yelp_business(SearchTerm, Location, Category, Price, Response) :- 
  yelp_api_key(ApiKey),
  http_get([
    host('api.yelp.com'),
    path('/v3/businesses/search'),
    search([
      term=SearchTerm,
      location=Location,
      categories=Category,
      price=Price,
      limit='10'
    ])
  ], Json, [
    authorization(bearer(ApiKey))
  ]),
  atom_json_dict(Json, Response, []).

% Exmaple search request
% search_yelp_business('taco', 'vancouver', 'mexican', '2', Response).