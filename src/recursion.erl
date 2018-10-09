%%%-------------------------------------------------------------------
%%% @author ujuezeoke
%%% @copyright (C) 2018, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 08. Oct 2018 16:17
%%%-------------------------------------------------------------------
-module(recursion).
-author("ujuezeoke").

%% API
-export([average/1]).


average(List) ->
  sum(List) / len(List).

sum([H | T]) -> H + sum(T);
sum([]) -> 0.

len([_| T]) -> 1+ len(T);
len([]) -> 0.