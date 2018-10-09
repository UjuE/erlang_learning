%%%-------------------------------------------------------------------
%%% @author ujuezeoke
%%% @copyright (C) 2018, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 08. Oct 2018 15:18
%%%-------------------------------------------------------------------
-module(boolean).
-author("ujuezeoke").

%% API
-export([b_not/1, b_and/2, b_or/2]).

b_not(X) ->
  not X.

b_and(X, Y) ->
  X and Y.

b_or(X, Y) ->
  X or Y.