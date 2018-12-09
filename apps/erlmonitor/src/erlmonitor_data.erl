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
-export([get_process_list/0, get_total_info/0]).

get_process_list() ->
  gen_server:call(?WORKER, get_process_list).



get_total_info() ->
  gen_server:call(?WORKER, get_total_info).





