%%%-------------------------------------------------------------------
%%% @author zhaoweiguo
%%% @copyright (C) 2018, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 07. Dec 2018 6:22 PM
%%%-------------------------------------------------------------------
-module(erlmonitor_data).
-author("zhaoweiguo").
-define(WORKER, erlmonitor_worker).
%% API
-export([get_pidlist_data/0, get_header_data/0]).

get_pidlist_data() ->
  gen_server:call(?WORKER, get_pidlist_data).



get_header_data() ->
  gen_server:call(?WORKER, get_header_data).





