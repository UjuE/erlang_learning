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
-export([start/0, wait/0, signal/0, init/0, startTest/1, loopTest/0]).

start() ->
  Pid = spawn(mutex, init, []),
  register(mutex, Pid),
  ok.

%% This is called when a process is trying to take a mutex.
%% if the process succeeds the state should be busy.
wait() ->
  mutex ! {wait, self()},
  receive
    ok -> ok
  end.

%% This is called when the process that is holding the lock releases the lock
signal() ->
  mutex ! {signal, self()},
  receive
    ok -> ok
  end.

init() ->
  io:format("Initializing Mutex~n"),
  free().

free() ->
  receive
    {wait, Process} ->
      io:format("~p is holding the wait~n", [Process]),
      Process ! ok,
      busy(Process);
    stop -> true
  end.

busy(Process) ->
  receive
    {signal, Process} -> io:format("~p has released the mutex~n", [Process]),
      Process ! ok,
      free()
  end.


%%% This area is to spawn many processes that send wait and signal after a time
startTest(0) -> ok;
startTest(N) ->
  spawn(mutex, loopTest, []),
  timer:sleep(10),
  startTest(N - 1),
  ok.

loopTest() ->
  io:format("~p wants access to the mutex~n", [self()]),
  mutex:wait(),
  timer:sleep(1000),
  mutex:signal(),
  true.