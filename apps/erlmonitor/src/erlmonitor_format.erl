%%%-------------------------------------------------------------------
%%% @author zhaoweiguo
%%% @copyright (C) 2018, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 08. Dec 2018 9:45 PM
%%%-------------------------------------------------------------------
-module(erlmonitor_format).
-author("zhaoweiguo").

-include("erlmonitor.hrl").
%% API
-export([handle_process_list/1]).
-export([sort/2]).


handle_process_list(ProcessList) ->
  ?LOGLN(""),
  handle_process_list(ProcessList, []).

handle_process_list([], FormatList) ->
  ?LOGLN(""),
  FormatList;
handle_process_list([ProcessInfo | Others], FormatList) ->
  ?LOGLN(""),
  ?LOGF("before format proc:~p~n", [ProcessInfo]),
  FormatProc = handle_process(ProcessInfo),
  ?LOGF("format proc:~p~n", [FormatProc]),
  handle_process_list(Others, [FormatProc | FormatList]).


handle_process(FormatList) ->
  io_lib:format("~p|~p|~p|~p|~p|~p|~p|~p|~p|~p|~p|~p", tuple_to_list(FormatList)).
%%io_lib:format("~w|~w|~w|~w|~w|~w|~w|~w|~w|~w|~w|~w", tuple_to_list(FormatList)).
%%FormatList.

sort(List, N) ->
  Fun = fun(List1, List2) ->
    {_,R1} = lists:nth(N, List1),
    {_,R2} = lists:nth(N, List2),
    ?LOGF("R1:~p, R2:~p~n", [R1, R2]),
    R1 > R2
        end,
  lists:sort(Fun, List).
