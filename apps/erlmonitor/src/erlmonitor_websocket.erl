%%%-------------------------------------------------------------------
%%% @author zhaoweiguo
%%% @copyright (C) 2018, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 07. Dec 2018 11:47 AM
%%%-------------------------------------------------------------------
-module(erlmonitor_websocket).
-behavior(cowboy_handler).

-author("zhaoweiguo").
-include("erlmonitor.hrl").

%% API
-export([init/2]).
-export([websocket_init/1]).
-export([websocket_handle/2]).
-export([websocket_info/2]).


init(Req, Opts) ->
  ?LOGLN("init"),
%%  ?LOGF("req:~p~n", [Req]),
  Method = cowboy_req:method(Req),
  PathInfo = cowboy_req:path(Req),
  ?LOGF("method:~p | pathinfo:~p~n", [Method, PathInfo]),
  {cowboy_websocket, Req, Opts}.

websocket_init(State) ->
  ?LOGLN(""),
  self() ! post_init,
  {ok, State}.

websocket_handle({text, Msg}, State) ->
  ?LOGLN(""),
  {reply, {text, << "That's what she said! ", Msg/binary >>}, State};
websocket_handle(_Data, State) ->
  ?LOGLN(" 2"),
  {ok, State}.

websocket_info(post_init, State) ->
  ?LOG("path:~n"),
  self() ! {go, sid},
  {ok, State};
websocket_info({go, Sid}, State) ->
  ?LOGLN(""),
  Msg = <<"">>,
  {reply, {text, Msg}, State};
websocket_info({timeout, _Ref, Msg}, State) ->
  ?LOGLN(""),
  erlang:start_timer(1000, self(), <<"How' you doin'?">>),
  {reply, {text, Msg}, State};
websocket_info(_Info, State) ->
  ?LOGLN("websocket_info2"),
  {ok, State}.
