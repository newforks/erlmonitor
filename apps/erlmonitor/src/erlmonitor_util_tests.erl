%%%-------------------------------------------------------------------
%%% @author zhaoweiguo
%%% @copyright (C) 2018, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 07. Dec 2018 11:08 PM
%%%-------------------------------------------------------------------
-module(erlmonitor_util_tests).
-author("zhaoweiguo").
%%-include_lib("eunit/include/eunit.hrl").


%%format_json_test() ->
%%  List1 = [
%%    {uptime, {3311, 2010}},
%%    {local_time, {{2018, 12, 7}, {23, 6, 12}}},
%%    {process_count, 77},
%%    {run_queue, 0},
%%    {reduction_count, {692666, 9544}},
%%    {process_memory_used, 4942176},
%%    {process_memory_total, 4996488},
%%    {memory, [
%%      {system, 12875232},
%%      {atom, 215369},
%%      {atom_used, 209721},
%%      {binary, 72984},
%%      {code, 4464177},
%%      {ets, 435256}
%%    ]}
%%  ],
%%  List2 = [
%%    {uptime, <<"3311:2010">>},
%%    {local_time, <<"{2018,12,7}:{23,6,12}">>},
%%    {process_count, 77},
%%    {run_queue, 0},
%%    {reduction_count, <<"692666:9544">>},
%%    {process_memory_used, 4942176},
%%    {process_memory_total, 4996488},
%%    {memory, [
%%      {system, 12875232},
%%      {atom, 215369},
%%      {atom_used, 209721},
%%      {binary, 72984},
%%      {code, 4464177},
%%      {ets, 435256}
%%    ]}
%%  ],
%%  List2 = erlmonitor_util:format_json(List1).
