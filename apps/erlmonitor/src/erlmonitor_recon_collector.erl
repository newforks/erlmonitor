%%%-------------------------------------------------------------------
%%% @author zhaoweiguo
%%% @copyright (C) 2018, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 09. Dec 2018 11:31 AM
%%%-------------------------------------------------------------------
-module(erlmonitor_recon_collector).
-author("zhaoweiguo").

-include("erlmonitor.hrl").
%% API
-export([get_data/0]).

get_data() ->
  {ok, Nodes} = application:get_env(nodes),
%%  ?LOGF("Node~p~n", [Nodes]),
  [{node, [{name, Node},
    {cookie, _Cookie},
    {interval, _Interval}]} | _] = Nodes,
  RPC = fun(M, F, A) -> rpc:call(Node, M, F, A) end,

  HeaderProplist = [{uptime, RPC(erlang, statistics, [wall_clock])},
    {local_time, RPC(calendar, local_time, [])},
    {process_count, RPC(erlang, system_info, [process_count])},
    {run_queue, RPC(erlang, statistics, [run_queue])},
    {reduction_count, RPC(erlang, statistics, [reductions])},
    {process_memory_used, RPC(erlang, statistics, [processes_used])},
    {process_memory_total, RPC(erlang, statistics, [processes])},
    {memory, RPC(erlang, memory, [system, atom, atom_used, binary, code, ets])}
  ],
%%  Self = self(),
%%  Processes = lists:sublist(erlang:processes(), 10),
  Processes = RPC(erlang, processes, []),
  ProcessesProplist = process_info_list(Processes),

  {ok, HeaderProplist, ProcessesProplist}.


process_info_list(Processes) ->
  process_info_list(Processes, []).

process_info_list([], NewList) ->
  ?LOGLN(""),
  NewList;
process_info_list([P | Other], NewList) ->
%%  ?LOGLN(""),
  try process_info_items(P) of
    Pinfo ->
      process_info_list(Other, [[{realpid, P} | Pinfo] | NewList])
  catch
    error:_Reason ->
      % the process may die when get info
%%      ?LOGF("err reason:~p~n", [_Reason]),
      process_info_list(Other, NewList)
  end.

process_info_items(P) ->
%%  ?LOGLN(""),
%%  ?LOGF("pid:~p~n", [P]),
  [
    {meta, [
      {registered_name, RegName},
      {dictionary, Dictionary},
      {group_leader, _GroupLeader},
      {status, Status}
    ]},
    {signals, [
      {links, _Pids},
      {monitors, _Monitor},
      {monitored_by, _MonitorBy},
      {trap_exit, _TrapExit}
    ]},
    {location, [
      {initial_call, Location},  % {otp_ring0,start,2}},
      {current_stacktrace, [CurrentStackTrace | _]}  % [{init,loop,1,[]}]}
    ]},
    {memory_used, [
      {memory, Memory},
      {message_queue_len, MsgQueueLen},
      {heap_size, HeapSize},
      {total_heap_size, TotalHeapSize},
      {garbage_collection, _GarbageCollection}   %% [{max_heap_size,#{error_logger => true,kill => true,size => 0}},
      %%{min_bin_vheap_size, _MinVheapSize},
      %%{min_heap_size, _MinHeapSize},
      %%{fullsweep_after, _},
      %%{minor_gcs, _}]}
    ]},
    {work, [{reductions, Reductions}]}
%%  ]=recon:info(P),
  ] = rpc:call(node(P), recon, info, [P]),

  [
    {initial_call, Location},
    {current_function, CurrentStackTrace},
    {status, Status},
    {reductions, Reductions},
    {registered_name, RegName},
    {message_queue_len, MsgQueueLen},
    {memory, Memory},
    {stack_size, HeapSize},
    {heap_size, HeapSize},
    {total_heap_size, TotalHeapSize}
%%,{dictionary, Dictionary}
  ]
.