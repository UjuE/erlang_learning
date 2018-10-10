%%%-------------------------------------------------------------------
%%% @author ujuezeoke
%%% @copyright (C) 2018, <COMPANY>
%%% @doc
%%% Learning how to create databases in Erlang
%%% @end
%%% Created : 09. Oct 2018 11:09
%%%-------------------------------------------------------------------
-module(db).
-author("ujuezeoke").

%% API
-export([new/0, destroy/1, write/3, delete/2, read/2, match/2]).

new() -> [].

%% I am replicating what he did in class. I had it throw an exception.
%% He choose the safe call route.
destroy(_DbRef) -> ok.

%% I used ++ He used List pattern
%% he used [{Key, Element} | Db ]
%% I used DbRef ++ [{Key, Element}]... Maybe this was cheating
%% After delete was created he used the delete to ensure that the keys are unique.
write(Key, Element, DbRef) ->
  [{Key, Element} | delete(Key, DbRef)].


%%Juan has his example on the board. It looks similar but he likes _Key to indicate an unbound variable.
%% I like plain old _.
%% The lecturer really prefers using pattern matching to create a new lis rather than concatenating.
%% REMEMBER THIS use [HEAD | OldDb] rather than [HEAD] ++ OldDB.
%% I think I get it now. I am creating a new list with a single element just to add that element to the old list.
delete(_, []) -> [];
delete(Key, [{Key, _} | Tail]) -> delete(Key, Tail);
delete(Key, [ Head | Tail ]) -> [Head | delete(Key, Tail)].

%% His is similar the difference is the catch all clause was used last in his.
read(_, []) -> {error, instance};
read(Key, [{Key, Element} | _]) -> {ok, Element};
read(Key, [_ | Tail]) -> read(Key, Tail).

match(_ , []) -> [];
match(Element, [{Key, Element} | Tail]) -> [Key | match(Element, Tail)];
match(Element, [_ | Tail]) -> match(Element, Tail).
