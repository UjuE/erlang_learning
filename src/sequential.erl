%%%-------------------------------------------------------------------
%%% @author ujuezeoke
%%% @copyright (C) 2018, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 09. Oct 2018 09:31
%%%-------------------------------------------------------------------
-module(sequential).
-author("ujuezeoke").

%% API
-export([sum/1, sum_interval/2, create/1, reverse_create/1, print/1, even_print/1]).

sum(1) -> 1;
sum(N) -> N + sum(N - 1).


sum_interval(N, N) ->
 N;
sum_interval(N, M) when N < M->
  N + sum_interval(N + 1, M).

reverse_create(1) -> [1];
reverse_create(N) ->
  [ N | reverse_create(N - 1)].


create(N) -> create(N, []).

create(Head, Tail) when Head > 1 ->
  create(Head - 1, [Head | Tail]);
create(1, Tail) -> [1 | Tail].

print(1) -> io:format("~p~n", [1]);
print(N) when N > 1 ->
  print(N - 1),
  io:format("~p~n", [N]).

even_print(2) -> io:format("~p~n", [2]);
even_print(N) when N rem 2 == 0 -> even_print(N - 1), io:format("~p~n", [N]);
even_print(N) when N rem 2 =/= 0 -> even_print(N - 1).