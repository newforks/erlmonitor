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
  HeaderProplist = [{uptime, erlang:statistics(wall_clock)},
    {local_time, calendar:local_time()},
    {process_count, erlang:system_info(process_count)},
    {run_queue, erlang:statistics(run_queue)},
    {reduction_count, erlang:statistics(reductions)},
    {process_memory_used, erlang:memory(processes_used)},
    {process_memory_total, erlang:memory(processes)},
    {memory, erlang:memory([system, atom, atom_used, binary, code, ets])}
  ],
  Self = self(),
%%  Processes = lists:sublist(erlang:processes(), 10),
  Processes = erlang:processes(),
  ProcessesProplist =
    [ [ {realpid, P}
%%        ,{pid,erlang:pid_to_list(P)}
      | process_info_items(P) ]
      || P <- Processes, P /= Self ],

  {ok, HeaderProplist, ProcessesProplist}.


process_info_items(P) ->
  [
    {meta,[
      {registered_name, RegName},
      {dictionary, Dictionary},
      {group_leader, _GroupLeader},
      {status, Status}
    ]},
    {signals,[
      {links, _Pids},
      {monitors, _Monitor},
      {monitored_by, _MonitorBy},
      {trap_exit, _TrapExit}
    ]},
    {location, [
      {initial_call, Location},  % {otp_ring0,start,2}},
      {current_stacktrace, [CurrentStackTrace|_]}  % [{init,loop,1,[]}]}
    ]},
    {memory_used,[
      {memory,Memory},
      {message_queue_len, MsgQueueLen},
      {heap_size, HeapSize},
      {total_heap_size, TotalHeapSize},
      {garbage_collection,  _GarbageCollection}   %% [{max_heap_size,#{error_logger => true,kill => true,size => 0}},
                                                %%{min_bin_vheap_size, _MinVheapSize},
                                                %%{min_heap_size, _MinHeapSize},
                                                %%{fullsweep_after, _},
                                                %%{minor_gcs, _}]}
    ]},
    {work,[{reductions, Reductions}]}
  ]=recon:info(P),

[{initial_call, Location},
{current_function, CurrentStackTrace},
{status, Status},
{reductions, Reductions},
{registered_name, RegName},
{message_queue_len, MsgQueueLen},
{memory, Memory},
{stack_size, HeapSize},
{heap_size, HeapSize},
{total_heap_size, TotalHeapSize},
{dictionary, Dictionary}]
.