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
-export([factorial/1, printFactorial/1]).

factorial(0) -> 1;
factorial(N) ->
  N * factorial(N - 1).

printFactorial(Number) ->
  io:format("The result: ~p~n", [factorial(Number)]).