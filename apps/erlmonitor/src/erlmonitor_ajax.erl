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
-export([allowed_methods/2, is_authorized/2]).
-export([content_types_provided/2]).
%%-export([content_types_accepted/2]).
%%-export([resource_exists/2]).

% custer API
-export([handler/2]).


init(Req, State) ->
  ?LOGLN(""),
%%  Way = cowboy_req:binding(way, Req),
%%  Qs = cowboy_req:qs(Req0),
%%  ?LOGF("qs:~p~n", [Qs]),
  {cowboy_rest, Req, State}.


is_authorized(RD, Ctx) ->
  ?LOGLN(""),
  {true, RD, Ctx}.

allowed_methods(Req, State) ->
  ?LOGLN(""),
  {[<<"GET">>, <<"POST">>], Req, State}.

%%content_types_accepted(Req, State) ->
%%  {[{{<<"application">>, <<"x-www-form-urlencoded">>, []}, create_paste}],
%%    Req, State}.

content_types_provided(Req, State) ->
  ?LOGLN(""),
  {[
%%    {<<"text/html">>, handler}
    {<<"application/json">>, handler}
%%    {<<"text/plain">>, hello_to_text},
%%    {{<<"text">>, <<"plain">>, []}, paste_text},
%%    {{<<"text">>, <<"html">>, []}, paste_html}
  ], Req, State}.

%%resource_exists(Req, _State) ->
%%  ?LOGLN(""),
%%  PasteID = xxx, % @todo
%%  case file_exists(PasteID) of
%%    true -> {true, Req, PasteID};
%%    false -> {false, Req, PasteID}
%%  end.


handler(Req0, Ctx) ->
%%  ?LOGF("req:~p~n", [Req0]),
  Path = cowboy_req:path(Req0),
  ?LOGF("Path:~p~n", [Path]),
  EncodeJson = case Path of
             <<"/ajax/processlist">> ->
               #{orderBy := OrderBy, orderReverse := OrderReverse} = cowboy_req:match_qs(
                 [{orderBy, int, 7}, {orderReverse, int, 0}], Req0),
               ?LOGF("orderby:~p, reverse:~p~n", [OrderBy, OrderReverse]),
               handler("processlist", OrderBy, OrderReverse);
             <<"/ajax/totalinfo">> ->
               handler("totalinfo")
           end,
%%  ?LOGF("encodejson:~p~n", [EncodeJson]),
  Req = cowboy_req:reply(200,
%%    #{<<"content-type">> => <<"application/json">>},
%%    #{<<"content-type">> => <<"text/plain">>},
    ?TEXT_HEAD,
    EncodeJson,
    Req0),
  {ok, Req, Ctx}.



%% ------------------------------------
%% --------- inner function------------
%% ------------------------------------



handler("processlist", OrderBy, OrderReverse) ->
  ?LOGLN(""),
%%  ?LOGF("orderby:~p, reverse:~p~n", [OrderBy, OrderReverse]),
  % todo
%%  {ok, Nodes} = application:get_env("nodes"),
%%  List = ["1", "2", "3"],
  ?LOGF("num:~p~n", [length(erlmonitor_data:get_process_list())]),
  ProcessList = erlmonitor_data:get_process_list(),
%%  ProcessList = lists:sublist(erlmonitor_data:get_process_list(), 2),
%%  ?LOGF("data:~p~n", [ProcessList]),
%%  ?LOGF("data:~p~n", [lists:sublist(ProcessList, 5)]),

  ?FILE_DEBUG(ProcessList),

  SortList = erlmonitor_format:sort(ProcessList, OrderBy, OrderReverse),
%%  SortList = lists:sublist(SortList1, 20), % @todo
%%  List = [abc, <<"abc">>],
%%  ?LOGF("data:~p~n", [SortList]),
%%  ?LOGF("first 5 data:~p~n", [lists:sublist(SortList, 5)]),
  JsonList = erlmonitor_util:format_json(SortList),
%%  JsonList = SortList,
%%  ?LOGF("jsonlist:~p~n", [JsonList]),
  EncodeJson = jsx:encode(JsonList),
%%  EncodeJson = jsx_encoder:encode(JsonList, jsx_encoder),
%%  EncodeJson = JsonList,
%%  ?LOGF("EncodeJson:~p~n", [EncodeJson]),
  EncodeJson.
%%  erlmonitor_format:handle_process_list(JsonList).

handler("totalinfo") ->
  ?LOGLN(""),
  % todo
%%  {ok, Nodes} = application:get_env("nodes"),
%%  List = ["1", "2", "3"],
%%  ?LOGLN("1111111"),
  List = erlmonitor_data:get_total_info(),
%%  List = [abc, <<"abc">>],
%%  ?LOGF("data:~p~n", [List]),
  JsonList = erlmonitor_util:format_json(List),
  EncodeJson = jsx:encode(JsonList),
%%  JsonList = List,
%%  ?LOGF("jsonlist:~p~n", [JsonList]),
  EncodeJson.


%%file_exists(_) ->
%%  ?LOGLN(""),
%%  % @todo
%%  false.