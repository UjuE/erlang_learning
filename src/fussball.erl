%%%-------------------------------------------------------------------
%%% @author ujuezeoke
%%% @copyright (C) 2018, <COMPANY>
%%% @doc
%%% There are no Global variables in Erlang.
%%% @end
%%% Created : 11. Oct 2018 09:05
%%%-------------------------------------------------------------------
-module(fussball).
-author("ujuezeoke").
-include("File.hrl").

%% API
-export([start/2, kickoff/1, stop/1, init/0]).

stop(Player) ->
  erlang:error(not_implemented).

kickoff(Player) ->
  erlang:error(not_implemented).

start(Player1, Player2) ->
  erlang:error(not_implemented).

init() ->
  process_flag(trap_exit, true),
  Person = #person{name = "Uju", phone = "012384758"},
  io:format("~p~n", [Person]).