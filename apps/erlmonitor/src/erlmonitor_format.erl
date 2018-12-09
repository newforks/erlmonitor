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
-export([sort/2, sort/3]).
-export([compare/3]).


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
  sort(List, N, 0).

sort(List, N, Reverse) ->
  ?LOGLN(""),
  Fun = fun(List1, List2) ->
%%    ?LOGF("list~p  ~p~n", [List1, List2]),
    {_,R1} = lists:nth(N, List1),
    {_,R2} = lists:nth(N, List2),
%%    ?LOGF("R1:~p, R2:~p~n", [R1, R2]),
    compare(R1, R2, Reverse)
        end,
  lists:sort(Fun, List).


compare(R1, R2, Reverse) ->
%%  ?LOGLN(""),
%%  ?LOGF("~p:~p~n", [R1, R2]),
%%  ?LOGF(":::~p~n", [R1>R2]),
  case Reverse of
    0 ->
      R1 > R2;
    1 ->
      R1 =< R2
  end.


%%compare(R1, R2, Reverse) when is_number(R1) orelse is_pid(R1)
%%                              orelse is_port(R1) orelse is_boolean(R1)
%%                              orelse is_list(R1) orelse is_binary(R1)->
%%  ?LOGLN(""),
%%  case Reverse of
%%    0 ->
%%      R1 > R2;
%%    1 ->
%%      R1 =< R2
%%  end;
%%compare(R1, R2, Reverse) when is_tuple(R1) ->
%%  ?LOGF("~p:~p~n", [R1, R2]),
%%  N1 = tuple_to_list(R1),
%%  N2 = tuple_to_list(R2),
%%  ?LOGF("~p:~p~n", [N1, N2]),
%%  compare(N1, N2, Reverse).
