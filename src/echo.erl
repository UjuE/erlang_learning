%%%-------------------------------------------------------------------
%%% @author ujuezeoke
%%% @copyright (C) 2018, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 09. Oct 2018 12:30
%%%-------------------------------------------------------------------
-module(echo).
-author("ujuezeoke").

%% API
-export([start/0, stop/0, print/1, init/1]).


start() ->
  Pid = spawn(echo, init, ["Started"]),
  register(echo, Pid), ok.

stop() ->
  io:format("It will stop~n"),
  echo ! stop,
  ok.

print(Term) ->
 echo ! {print, Term}, ok.

init(Msg) ->
  io:format("~p~n", [Msg]),
  loop().

loop() ->
  io:format("In loop~n"),
  receive
    {print, Msg} ->  io:format("Printing: ~p~n", [Msg]), loop();
    {From, Msg} -> From ! Msg;
    stop -> true
  end.