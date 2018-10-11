%%%-------------------------------------------------------------------
%%% @author ujuezeoke
%%% @copyright (C) 2018, <COMPANY>
%%% @doc
%%% Learning how to create databases in Erlang
%%% @end
%%% Created : 09. Oct 2018 11:09
%%%-------------------------------------------------------------------
-module(db_ets).
-author("ujuezeoke").

%% API
-export([new/0, destroy/1, write/3, delete/2, read/2, match/2]).

new() -> ets:new(db_ets, []).

destroy(DbRef) -> ets:delete(DbRef).

write(Key, Element, DbRef) -> ets:insert(DbRef, {Key, Element}).

delete(Key, DbRef) -> ets:delete(DbRef, Key).

read(Key, DbRef) -> read_result(ets:lookup(DbRef, Key)).

read_result([]) -> {error, instance};
read_result([{_Key, Element}]) -> {ok, Element}.

match(Element, DbRef) ->
  lists:append(ets:match(DbRef, {'$1', Element})).

