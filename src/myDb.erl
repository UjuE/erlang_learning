%%%-------------------------------------------------------------------
%%% @author ujuezeoke
%%% @copyright (C) 2018, <COMPANY>
%%% @doc
%%% Learning how to create databases in Erlang
%%% @end
%%% Created : 09. Oct 2018 11:09
%%%-------------------------------------------------------------------
-module(myDb).
-author("ujuezeoke").

%% API
-export([write/2, delete/1, read/1, match/1, stop/0, start/0, init/0]).
-import(db_ets, [new/0, write/3, delete/2, read/2, match/2]).

write(Key, Element) ->
  myDb ! {write, Key, Element}.

delete(Key) ->
  myDb ! {delete, Key}.

read(Key) ->
  myDb ! {read, Key, self()}.

match(Element) ->
  myDb ! {match, Element, self()}.

stop() ->
  myDb ! stop.

start() ->
  Pid = spawn(myDb, init, []),
  register(myDb, Pid).

init() ->
  io:format("Initialising~n"),
  loop(new()).

loop(DbNew) ->
  io:format("In Loop~n"),
  receive
    stop -> io:format("Stopping ~p~n", [self()]), true;
    {write, Key, Element} -> NewDb = write(Key, Element, DbNew), loop(NewDb);
    {read, Key, Process} -> Process ! read(Key, DbNew), loop(DbNew);
    {match, Element, Process} -> Process ! match(Element, DbNew), loop(DbNew);
    {delete, Key} ->
      DbDelete = delete(Key, DbNew),
      io:format("New database after deleting: ~p~n", [DbDelete]),
      loop(DbDelete);
    Msg -> io:format("Received message: ~w~n", [Msg]), loop(DbNew)
  end.