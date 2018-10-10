%%%-------------------------------------------------------------------
%%% @author ujuezeoke
%%% @copyright (C) 2018, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 09. Oct 2018 16:32
%%%-------------------------------------------------------------------
-module(crossover).
-author("ujuezeoke").

%% API
-export([start/3, init/3, init/2]).


start(NumberOfProcesses, StartProcess, Msg) ->
  Processes = startProcess(NumberOfProcesses - 1, [], NumberOfProcesses, mainProcess),
  MainPid = spawn(crossover, init, [NumberOfProcesses, NumberOfProcesses / 2, Processes]),
  register(mainProcess, MainPid),
  findPid(StartProcess, Processes) ! Msg,
  ok.

init(MaxNumber, HalfWay, Processes) ->
  io:format("Starting Process 1~n"),
  processOne(MaxNumber, HalfWay, Processes).

init(CurrentNumber, NextProcess) ->
  io:format("Starting Process ~p~n", [CurrentNumber]),
  receive
    stop ->
      io:format("Process: ~p terminating~n", [CurrentNumber]),
      NextProcess ! stop,
      true;

    {_, Msg} ->
      io:format("Process: ~p received: ~p~n", [CurrentNumber, Msg]),
      NextProcess ! {CurrentNumber, Msg},
      init(CurrentNumber, NextProcess);

    Msg ->
      io:format("Process: ~p received: ~p~n", [CurrentNumber, Msg]),
      NextProcess ! {CurrentNumber, Msg},
      init(CurrentNumber, NextProcess)
  end.

startProcess(NumberOfProcesses, List, NumberOfProcesses, FirstProcessAtom) ->
io:format("The maximum Process is called ~p~n", [NumberOfProcesses]),
startProcess(
NumberOfProcesses - 1,
[{NumberOfProcesses, spawn(crossover, init, [NumberOfProcesses, FirstProcessAtom])}] ++ List,
NumberOfProcesses,
FirstProcessAtom);

startProcess(2, List, NumberOfProcesses, _) when NumberOfProcesses > 2 -> [{2, spawn(crossover, init, [2, findPid(3, List)])}] ++ List;

startProcess(NumberOfProcesses, List, M, N) when NumberOfProcesses > 2 ->
  startProcess(
    NumberOfProcesses - 1,
    [{NumberOfProcesses, spawn(crossover, init, [NumberOfProcesses, findPid(NumberOfProcesses + 1, List)])}] ++ List,
    M,
    N).

processOne(MaxNumber, HalfWay, Processes) when MaxNumber > 1 ->
  io:format("In the first process~n"),
  receive
    {MaxNumber, _} ->
      io:format("Process: 1 terminating~n"),
      findPid(2, Processes) ! stop,
      true;

    {HalfWay, Msg} ->
      io:format("Process: 1 received: ~p halfway through~n", [Msg]),
      findPid(HalfWay + 1, Processes) ! {1, Msg},
      processOne(MaxNumber, HalfWay, Processes),
      ok;

    stop -> true;

    Msg ->
      io:format("Process: 1 received: ~p~n", [Msg]),
      findPid(2, Processes) ! {1, Msg},
      processOne(MaxNumber, HalfWay, Processes),
      ok
  end.

findPid(_, []) -> [];
findPid(N, [{N, Process} | _]) -> Process;
findPid(N, [_ | Tail]) -> findPid(N, Tail).