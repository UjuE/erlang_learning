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
%% Do not use export all
-export([write/2, delete/1, read/1, match/1, stop/0, start/0, init/0]).

%%% It is bad form to use import. use the modules directly.
%%-import(db_ets, [new/0, write/3, delete/2, read/2, match/2]).

write(Key, Element) ->
  ?MODULE ! call({write, Key, Element}).

delete(Key) ->
  ?MODULE ! call({delete, Key}).

read(Key) ->
  ?MODULE ! call({read, Key}).

match(Element) ->
  ?MODULE ! call({match, Element}).

stop() ->
  ?MODULE ! call(stop).

start() ->
  register(?MODULE, spawn(?MODULE, init, [])).

%%Note he likes synchonous calls. All this fire and forget things I do will not fly.
call(Msg) ->
  ?MODULE ! {msg, self(), Msg},
  receive
    {reply, Reply} -> Reply
  end.


init() ->
  io:format("Initialising~n"),
  loop(db_ets:new()).

loop(DbNew) ->
  io:format("In Loop~n"),
  receive
    {msg, Process, stop} -> io:format("Stopping ~p~n", [self()]),
      reply(Process, ok),
      true;
    {msg, Process, {write, Key, Element} } ->
      NewDb = db_ets:write(Key, Element, DbNew),
      reply(Process, ok),
      loop(NewDb);
    {msg, Process, {read, Key}}->
      reply(Process,  db_ets:read(Key, DbNew)),
      loop(DbNew);
    {msg, Process, {match, Element}} ->
      reply(Process, db_ets:match(Element, DbNew)),
      loop(DbNew);
    {msg, Process, {delete, Key}} ->
      DbDelete = db_ets:delete(Key, DbNew),
      io:format("New database after deleting: ~p~n", [DbDelete]),
      reply(Process, ok),
      loop(DbDelete);
    Msg -> io:format("Received message: ~w~n", [Msg]), loop(DbNew)
  end.

reply(Process, Message) ->
  Process ! {reply, Message}.