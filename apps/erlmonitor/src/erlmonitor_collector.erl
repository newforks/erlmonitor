%%%-------------------------------------------------------------------
%%% @author zhaoweiguo
%%% @copyright (C) 2018, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 07. Dec 2018 3:43 PM
%%%-------------------------------------------------------------------
-module(erlmonitor_collector).
-author("zhaoweiguo").

%% API
-export([get_data/0]).

get_data() ->
%%  {{Year, Month, Day}, {Hour, Minute, Second}} = calendar:local_time(),
%%  LocalTime = list_to_binary(lists:flatten(
%%    io_lib:format("~4..0w-~2..0w-~2..0wT~2..0w:~2..0w:~2..0w",
%%      [Year, Month, Day, Hour, Minute, Second]))),
%%  WallClock = erlmonitor_util:to_string(erlang:statistics(wall_clock)),
%%  Reductions = erlmonitor_util:to_string(erlang:statistics(reductions)),
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
  ProcessesProplist =
    [ [ {realpid, P}
%%        ,{pid,erlang:pid_to_list(P)}
        | process_info_items(P) ]
      || P <- lists:sublist(erlang:processes(), 20), P /= Self ],

  {ok, HeaderProplist, ProcessesProplist}.



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