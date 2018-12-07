%%%-------------------------------------------------------------------
%%% @author zhaoweiguo
%%% @copyright (C) 2018, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 07. Dec 2018 3:43 PM
%%%-------------------------------------------------------------------
-module(erlmonitor_ajax).
-author("zhaoweiguo").
-behavior(cowboy_handler).

-include("erlmonitor.hrl").

%% API
-export([init/2]).


init(Req0, State) ->
  Method = cowboy_req:binding(method, Req0),
%%  ?LOGF("method:~p~n", [Method]),
  EncodeJson = handler(Method),
  Req = cowboy_req:reply(200,
    #{<<"content-type">> => <<"application/json">>},
    EncodeJson,
    Req0),
  {ok, Req, State}.

%% ------------------------------------
%% --------- inner function------------
%% ------------------------------------

handler(<<"pidlist">>) ->
  % todo
%%  {ok, Nodes} = application:get_env("nodes"),
%%  List = ["1", "2", "3"],
%%  ?LOGLN("1111111"),
  List = erlmonitor_data:get_pidlist_data(),
%%  List = [abc, <<"abc">>],
  ?LOGF("data:~p~n", [List]),
  JsonList = erlmonitor_util:format_json(List),
  EncodeJson = jsx:encode(JsonList),
%%  JsonList = List,
  ?LOGF("jsonlist:~p~n", [JsonList]),
  EncodeJson;
handler(<<"headerlist">>) ->
  % todo
%%  {ok, Nodes} = application:get_env("nodes"),
%%  List = ["1", "2", "3"],
%%  ?LOGLN("1111111"),
  List = erlmonitor_data:get_header_data(),
%%  List = [abc, <<"abc">>],
  ?LOGF("data:~p~n", [List]),
  JsonList = erlmonitor_util:format_json(List),
  EncodeJson = jsx:encode(JsonList),
%%  JsonList = List,
  ?LOGF("jsonlist:~p~n", [JsonList]),
  EncodeJson.
