%%%-------------------------------------------------------------------
%%% @author zhaoweiguo
%%% @copyright (C) 2018, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 09. Dec 2018 2:03 PM
%%%-------------------------------------------------------------------
-module(erlmonitor_socket_io).
-author("zhaoweiguo").
-behavior(cowboy_handler).

-include("erlmonitor.hrl").

%% API
-export([init/2]).
-export([websocket_init/1]).
-export([websocket_handle/2]).
-export([websocket_info/2]).

-record(state, {
  session_id
}).

init( Req0 = #{path_info := [<<"1">>] }, State) ->
%%  ?LOGF("req:~p~n", [Req0]),
  Req = cowboy_req:reply(200,
    ?TEXT_HEAD,
%%    #{<<"content-type">> => <<"text/plain">>},
    <<"71f51c0c616435e041d86effdc6a4639:30:30:websocket, xhr-polling">>, Req0),
  {ok, Req, State};
init( Req = #{path_info := [<<"1">>,<<"websocket">>,Sid] }, State) ->
%%  ?LOGF("req:~p~n", [Req]),
  {cowboy_websocket, Req, [{sid, Sid} | State]};
init(Req, State) ->
  ?LOGF("req:~p~n", [Req]),
  {ok, ok, State}.


websocket_init(State) ->
  ?LOGF("state: ~p~n", [State]),
%%  erlang:start_timer(1000, self(), <<"Hello!">>),
  self() ! post_init,
  {ok, State}.

websocket_handle({text, Msg}, State) ->
  ?LOGLN(""),
  NewMsg = <<"4:::2345678">>,
  {reply, {text, NewMsg}, State};
websocket_handle(_Data, State) ->
  ?LOGLN(""),
  {ok, State}.

websocket_info(post_init, [{sid, Sid}]=State) ->
  ?LOG("path:~n"),
  self() ! {go, Sid},
  {ok, State};
websocket_info({go, Sid}, State) ->
  ?LOGLN(""),
  Msg = <<"2::">>,
  {reply, {text, Msg}, State};
websocket_info({timeout, _Ref, Msg}, State) ->
  ?LOGLN(""),
  erlang:start_timer(1000, self(), <<"How' you doin'?">>),
  {reply, {text, Msg}, State};
websocket_info(_Info, State) ->
  ?LOGLN(""),
  {ok, State}.








