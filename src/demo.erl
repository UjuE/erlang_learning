%%%-------------------------------------------------------------------
%%% @author ujuezeoke
%%% @copyright (C) 2018, <COMPANY>
%%% @doc
%%% This was done in class.
%%% @end
%%% Created : 08. Oct 2018 14:59
%%%-------------------------------------------------------------------
-module(demo).
-author("ujuezeoke").

%% API
-export([double/1]).


double(X) ->
  times(X, 2).

times(X, N) ->
  X * N.