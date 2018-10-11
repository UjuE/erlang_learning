%%%-------------------------------------------------------------------
%%% @author ujuezeoke
%%% @copyright (C) 2018, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 11. Oct 2018 11:57
%%%-------------------------------------------------------------------
-module(sup).
-author("ujuezeoke").

%% API
-export([start/1, start_child/4, stop/1, init/0]).

start(SupName) ->
  Pid = spawn(sup, init, []),
  register(SupName, Pid),
  {ok, Pid}.

start_child(SupNameOrPid, Mod, Func, Args) ->
  SupNameOrPid ! {link, Mod, Func, Args, self()},
  receive
    Msg -> Msg
  end.

stop(SupNameOrPid) ->
  SupNameOrPid ! stop.

%% Private functions.
init() ->
  io:format("Initializing Supervisor~n"),
  process_flag(trap_exit, true),
  loop([]).

start_child(Mod, Func, Args) ->
  Pid = spawn(Mod, Func, Args),
  link(Pid),
  {ok, Pid}.

loop(Processes) ->
  AddToList = fun({ok, Pid}, Mod, Func, Args, List) ->
                    [{Pid, {Mod, Func, Args}} | List]
              end,
  receive

    {link, Mod, Func, Args, Process} ->
      Result = start_child(Mod, Func, Args),
      NewProcesses = AddToList(Result, Mod, Func, Args, Processes),
      Process ! Result,
      loop(NewProcesses);

    {'EXIT', Process, Reason} ->
      io:format("Process ~p terminated~nReason for terminated:~p~n", [Process, Reason]),
      {value, {Process, {Mod, Func, Args}}, List} = lists:keytake(Process, 1, Processes),
      io:format("Restarting with ~w:~w/~w~n", [Mod, Func, length(Args)]),
      Result = start_child(Mod, Func, Args),
      loop(AddToList(Result, Mod, Func, Args, List));

    stop ->
      io:format("Supervisor is being stopped."),
      true;

    showstore ->
      io:format("Child Processes : ~p~n", [Processes]),
      loop(Processes)
  end.