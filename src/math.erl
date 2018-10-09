%%%-------------------------------------------------------------------
%%% @author ujuezeoke
%%% @copyright (C) 2018, <COMPANY>
%%% @doc
%%% I am using this to experiment with factorial
%%% @end
%%% Created : 08. Oct 2018 16:09
%%%-------------------------------------------------------------------
-module(math).
-author("ujuezeoke").

%% API
-export([factorial/1]).

factorial(0) -> 1;
factorial(N) ->
  erlang:error(not_implemented).