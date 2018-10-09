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


new() ->
  [].

destroy(DbRef) ->
  erlang:error(not_implemented).

write(Key, Element, DbRef) ->
  DbRef ++ [{Key, Element}].

delete(_, []) -> [];
delete(Key, [{Key, _} | Tail]) -> delete(Key, Tail);
delete(Key, [ Head | Tail ]) -> [Head] ++ delete(Key, Tail).

read(_, []) -> {error, instance};
read(Key, [{Key, Element} | _]) -> {ok, Element};
read(Key, [_ | Tail]) -> read(Key, Tail).

match(_ , []) -> [];
match(Element, [{Key, Element} | Tail]) -> [Key] ++ match(Element, Tail);
match(Element, [_ | Tail]) -> match(Element, Tail).
