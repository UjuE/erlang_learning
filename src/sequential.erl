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
-export([sum/1, sum_interval/2, create/1, reverse_create/1, print/1, even_print/1, createStartingFromOne/1]).

%% He did this in class. His base was zero.
sum(1) -> 1;
sum(N) -> N + sum(N - 1).

%% The base case he used was the same. He also noted that the second clause could have been:
%% reduced M
sum_interval(N, N) ->
 N;
sum_interval(N, M) when N < M->
  N + sum_interval(N + 1, M).

%% This was easier to reason about.
reverse_create(1) -> [1];
reverse_create(N) ->
  [ N | reverse_create(N - 1)].


%% There are many recursive patterns. At least 3. I need to go in and learn them.
%% I think he helped us out yesterday. I do not think I would have gotten this on my own.
%% His solution in class is similar to mine.
%% He likes this style of writing where related functions have the same name.
create(N) -> create(N, []).
create(Head, Tail) when Head > 1 -> create(Head - 1, [Head | Tail]);
create(1, Tail) -> [1 | Tail].

%% He really prefers pattern matching in the function heads followed by case statements.
%% His least favourite.
%% This method begins from 1 and recursses to N
createStartingFromOne(N) -> createStartingFromOne(1, N).
createStartingFromOne(N, N) -> [N];
createStartingFromOne(N, Y) -> [N | createStartingFromOne(N+1, Y)].

print(0) -> ok;
print(N) ->
  print(N - 1),
  io:format("~p~n", [N]).

even_print(2) -> io:format("~p~n", [2]);
even_print(N) when N rem 2 == 0 -> even_print(N - 1), io:format("~p~n", [N]);
even_print(N) when N rem 2 =/= 0 -> even_print(N - 1).
