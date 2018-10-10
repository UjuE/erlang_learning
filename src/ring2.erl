%%%-------------------------------------------------------------------
%%% @author ujuezeoke
%%% @copyright (C) 2018, <COMPANY>
%%% @doc
%%% This is redoing this following the lecturer
%%% @end
%%% Created : 10. Oct 2018 10:54
%%%-------------------------------------------------------------------
-module(ring2).
-author("ujuezeoke").

%% API
-export([start/3, start/2]).

%% This looks a lot like the crossover one.
%% I created new processes to be the control process basically my ring did not include the shell

%% I am hella confused at the moment.
start(ProcNum, _MsgNum, _Msg) ->
  io:format("~w started~n", [self()]),
  Pid = spawn(ring2, start, [ProcNum - 1, self()]),
  io:format("~w:~w connected to ~w~n", [1, self(), Pid]).


start(2, Pid) ->
%%  io:format("~w:~w started~n", [2, self()]),
  io:format("~w:~w connected to ~w~n", [2, self(), Pid]);
start(ProcNum, FirstPid) ->
  io:format("~w:~w started~n", [ProcNum, FirstPid]),
  Pid = spawn(ring2, start, [ProcNum - 1, FirstPid]),
  io:format("~w:~w connected to ~w~n", [ProcNum, FirstPid, Pid]).