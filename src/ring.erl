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
-export([start/1, init/1]).

%%timer:tc(ring, start, [10000]). Will time the run.
start(NumberOfProcesses) ->
  FirstProcessAlias = mainProcess,
  Process = startProcess(NumberOfProcesses - 1, FirstProcessAlias),
  MainPid = spawn(ring, init, [Process]),
  register(FirstProcessAlias, MainPid),
  ok.

init([Head | Tail]) ->
  io:format("Starting main process~n"),
  loop([Head | Tail]), ok;
init(FirstProcessAlias) ->
  io:format("Starting child process~n"),
  loop(FirstProcessAlias), ok.

loop([Head | [TailHead | Tail]]) ->
  receive
    stop ->
      io:format("Stoping main process, pid ~p~n", [self()]),
      Head ! {TailHead, stop, Tail}, true;

    Msg ->
      io:format("Main Process ~p received: ~p~n", [self(), Msg]),
      Head ! {TailHead, Msg, Tail}, loop([Head | [TailHead | Tail]]), ok
  end;
loop(FirstProcessAlias) ->
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
      loop(FirstProcessAlias);

    {To, Msg, [Head| Tail]} ->
      io:format("Process ~p received: ~p. Sending message to ~p~n", [self(), Msg, To]),
      To ! {Head, Msg, Tail},
      loop(FirstProcessAlias);

    {Msg} ->
      io:format("Process ~p received: ~p. The last in the ring~n", [self(), Msg]),
      FirstProcessAlias ! stop,
      loop(FirstProcessAlias)
  end.

startProcess(0, _) -> [];
startProcess(NumberOfProcesses, FirstProcess) ->
  [spawn(ring, init, [FirstProcess]) | startProcess(NumberOfProcesses - 1, FirstProcess)].
