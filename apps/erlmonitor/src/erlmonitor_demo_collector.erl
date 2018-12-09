%%%-------------------------------------------------------------------
%%% @author zhaoweiguo
%%% @copyright (C) 2018, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 08. Dec 2018 2:41 PM
%%%-------------------------------------------------------------------
-module(erlmonitor_demo_collector).
-author("zhaoweiguo").

-include("erlmonitor.hrl").
%% API
-export([get_data/0]).


get_data() ->
  TotalInfos = [{uptime, erlang:statistics(wall_clock)},
    {local_time, calendar:local_time()},
    {process_count, erlang:system_info(process_count)},
    {run_queue, erlang:statistics(run_queue)},
    {reduction_count, erlang:statistics(reductions)},
    {process_memory_used, erlang:memory(processes_used)},
    {process_memory_total, erlang:memory(processes)},
    {memory, erlang:memory([system, atom, atom_used, binary, code, ets])}
  ],
  Self = self(),
  % Just get 5 number for debugging
  PidList = erlang:processes(),
%%  PidList = lists:sublist(erlang:processes(), 5),
%%  ?LOGF("pidlist:~p~n", [PidList]),
  ProcessList =
    [ [{realpid, P}
%%        ,{pid,erlang:pid_to_list(P)}
      | process_info_items(P)]
      || P <- PidList, P /= Self ],

  {ok, TotalInfos, ProcessList}.



%% =============================================================================
%% Internal Functions
%% =============================================================================
process_info_items(P) ->
  erlang:process_info(P, [
    initial_call,
    current_function,
    status,
    reductions,
    registered_name,
    message_queue_len,
    memory,
    stack_size,
    heap_size,
    total_heap_size,
    dictionary]).