%%%-------------------------------------------------------------------
%%% @author zhaoweiguo
%%% @copyright (C) 2018, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 07. Dec 2018 8:09 PM
%%%-------------------------------------------------------------------
-module(erlmonitor_util).
-author("zhaoweiguo").

%% API
-export([tuple_to_string/1, tuple_to_binary/1, datetime_to_string/1, datetime_to_binary/1]).
-export([format_json/1]).

tuple_to_string({A, B}) ->
  lists:flatten(io_lib:format("~w:~w", [A, B]));
tuple_to_string({A, B, C}) ->
  lists:flatten(io_lib:format("~w:~w:~w", [A, B, C]));
tuple_to_string({A, B, C, D}) ->
  lists:flatten(io_lib:format("~w:~w:~w:~w", [A, B, C, D]));
tuple_to_string({A, B, C, D, E}) ->
  lists:flatten(io_lib:format("~w:~w:~w:~w:~w", [A, B, C, D, E])).

tuple_to_binary(Tuple) ->
  list_to_binary(tuple_to_string(Tuple)).


datetime_to_string({{Year, Month, Day}, {Hour, Minute, Second}}) ->
  lists:flatten(
    io_lib:format("~4..0w-~2..0w-~2..0wT~2..0w:~2..0w:~2..0w",
      [Year, Month, Day, Hour, Minute, Second])).

datetime_to_binary(DateTime) ->
  binary_to_list(datetime_to_string(DateTime)).



format_json([]) ->
  "";
format_json({K, V}) when is_integer(V); is_atom(V); is_binary(V)->
  {K, V};
format_json({K, V}) when is_pid(V) ->
  {K, list_to_binary(pid_to_list(V))};
format_json({K, V}) when is_tuple(V) ->
  {K, tuple_to_binary(V)};
%%format_json({K, V = {{_Year, _Month, _Day}, {_Hour, _Minute, _Second}}}) ->
%%  {K, datetime_to_binary(V)};
format_json({K, V}) ->
  {K, format_json(V)};
format_json([Item | List]) ->
  NewItem = format_json(Item),
  NewList = format_json(List),
  [NewItem | NewList];
format_json(_Other) ->
  [].


