%%%-------------------------------------------------------------------
%%% @author ujuezeoke
%%% @copyright (C) 2018, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 09. Oct 2018 16:32
%%%-------------------------------------------------------------------
-module(ring).
-author("ujuezeoke").

%% API
-export([start/1, init/0, init/1]).


start(NumberOfProcesses) ->
  Process = startProcess(NumberOfProcesses - 1),
  MainPid = spawn(ring, init, [Process]),
  register(mainProcess, MainPid),
  ok.

init(Processes) ->
  io:format("Starting main process~n"),
  loop(Processes), ok.

init() ->
  io:format("Starting child process~n"),
  loop(), ok.

loop() ->
  receive
    {stop} ->
      io:format("Stoping pid ~p~n", [self()]),
      true;

    {To, stop, []} ->
      io:format("Stoping pid ~p~n", [self()]),
      To ! {stop},
      true;

    {To, stop, [Head| Tail] } ->
      io:format("Stoping pid ~p~n", [self()]),
      To ! {Head, stop, Tail},
      true;

    {To, Msg, []} ->
      io:format("Process ~p received: ~p. Sending message to ~p~n", [self(), Msg, To]),
      To ! {Msg},
      loop();

    {To, Msg, [Head| Tail]} ->
      io:format("Process ~p received: ~p. Sending message to ~p~n", [self(), Msg, To]),
      To ! {Head, Msg, Tail},
      loop();

    {Msg} ->
      io:format("Process ~p received: ~p. The last in the ring~n", [self(), Msg]),
      loop()
  end.

loop([Head | [TailHead | Tail]]) ->
  receive
    stop ->
      io:format("Stoping main process, pid ~p~n", [self()]),
      Head ! {TailHead, stop, Tail}, true;

    Msg ->
      io:format("Main Process ~p received: ~p~n", [self(), Msg]),
      Head ! {TailHead, Msg, Tail}, loop([Head | [TailHead | Tail]]), ok
  end.

startProcess(1) -> [spawn(ring, init, [])];
startProcess(NumberOfProcesses) when NumberOfProcesses > 1 ->
  [spawn(ring, init, [])] ++ startProcess(NumberOfProcesses - 1).
