%%%-------------------------------------------------------------------
%%% @author ujuezeoke
%%% @copyright (C) 2018, <COMPANY>
%%% @doc
%%% The mutex has only 2 states free and busy
%%% @end
%%% Created : 10. Oct 2018 15:01
%%%-------------------------------------------------------------------
-module(mutex).
-author("ujuezeoke").

%% API
-export([start/0, wait/0, signal/0, init/0, startTest/1, loopTest/0, killAfterHold/0, holdAndKill/0]).

start() ->
  Pid = spawn(?MODULE, init, []),
  register(?MODULE, Pid),
  ok.

%% This is called when a process is trying to take a mutex.
%% if the process succeeds the state should be busy.
wait() ->
  ?MODULE ! {wait, self()},
  receive
    ok -> ok
  end.

%% This is called when the process that is holding the lock releases the lock
signal() ->
  ?MODULE ! {signal, self()},
  receive
    ok -> ok
  end.

init() ->
  process_flag(trap_exit, true),
  io:format("Initializing Mutex~n"),
  free().

free() ->
  receive
    {wait, Process} ->
      io:format("~p is holding the wait~n", [Process]),
      link(Process),
      Process ! ok,
      busy(Process);
    stop -> true
  end.

busy(Process) ->
  receive
    {signal, Process} -> io:format("~p has released the mutex~n", [Process]),
      Process ! ok,
      unlink(Process),
      free();
    {'EXIT', Process, Reason} -> io:format("Message: ~p has exited because ~p~n", [Process, Reason]),
        free()
  end.


%%% This area is to spawn many processes that send wait and signal after a time
startTest(0) -> ok;
startTest(N) when N rem 7 == 0 ->
  spawn(?MODULE, holdAndKill, []),
  timer:sleep(100),
  startTest(N - 1),
  ok;
startTest(N) when N rem 3 == 0 ->
  spawn(?MODULE, killAfterHold, []),
  timer:sleep(10),
  startTest(N - 1),
  ok;
startTest(N) ->
  spawn(?MODULE, loopTest, []),
  timer:sleep(10),
  startTest(N - 1),
  ok.

loopTest() ->
  io:format("~p wants access to the mutex~n", [self()]),
  mutex:wait(),
  timer:sleep(1000),
  mutex:signal(),
  ok.

killAfterHold() ->
  io:format("~p wants access to the mutex and it will die~n", [self()]),
  mutex:wait(),
  timer:sleep(4000),
  exit(self(), "Killed after it recived ok"),
  ok.

holdAndKill() ->
  io:format("~p wants access to the mutex and it will die instantly.~n", [self()]),
  mutex:wait(),
  exit(self(), "Killed instantly"),
  ok.