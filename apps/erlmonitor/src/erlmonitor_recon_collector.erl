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
-export([get_process_list/0]).


get_process_list() ->
  Self = self(),
  ProcessList =
    [ process_info_items(P)
      || P <- erlang:processes(), P /= Self ].


process_info_items(Pid) ->
  recon:info(Pid).