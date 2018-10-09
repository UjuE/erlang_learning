%%%-------------------------------------------------------------------
%%% @author ujuezeoke
%%% @copyright (C) 2018, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 08. Oct 2018 15:03
%%%-------------------------------------------------------------------
-module(temp).
-author("ujuezeoke").

%% API
-export([convert/1]).


c2f(Celsius) ->
  ((9 * Celsius)/5) + 32.

f2c(Fahrenheit) ->
  (5 * (Fahrenheit - 32)) / 9.

%% These are clauses for the same function. Notice the semi-colon after the first clause
%% and the period indicating the end of the function.
convert({c, TempInCelsius}) -> {f, c2f(TempInCelsius)};
convert({f, TempInFahrenheit}) -> {c, f2c(TempInFahrenheit)}.