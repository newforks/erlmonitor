%%%-------------------------------------------------------------------
%%% @author zhaoweiguo
%%% @copyright (C) 2018, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 07. Dec 2018 4:58 PM
%%%-------------------------------------------------------------------
-module(erlmonitor_worker).
-author("zhaoweiguo").

-behaviour(gen_server).

-include("erlmonitor.hrl").

%% API
-export([start_link/0]).

%% gen_server callbacks
-export([init/1,
  handle_call/3,
  handle_cast/2,
  handle_info/2,
  terminate/2,
  code_change/3]).

-define(SERVER, ?MODULE).
-compile({no_auto_import,[monitor/3]}).

-record(node, {
  node,
  cookie,
  type
}).

-record(static_data, {
  otp_version,
  erts_version,
  os_type,
  os_version,
  node_flags

}).

-record(state, {
  node,
  static_data,
  headerProplist,
  processesProplist,
%%  remote_collector = erlmonitor_collector,
  remote_collector = erlmonitor_demo_collector,
  interval = 2000,
  reverse_sort = true,
  sort = 0,
  connected = false,
  timer
%%  last_reductions = dict:new()  % @todo
}).

%%%===================================================================
%%% API
%%%===================================================================

%%--------------------------------------------------------------------
%% @doc
%% Starts the server
%%
%% @end
%%--------------------------------------------------------------------
-spec(start_link() ->
  {ok, Pid :: pid()} | ignore | {error, Reason :: term()}).
start_link() ->
  gen_server:start_link({local, ?SERVER}, ?MODULE, [], []).

%%%===================================================================
%%% gen_server callbacks
%%%===================================================================

init([]) ->
  Node = 'demo_cowboy@127.0.0.1',
  Cookie = 'demo_cowboy',
  NameType = longnames,
  State = monitor(Node, Cookie, NameType),
  Timer = erlang:send_after(State#state.interval, self(), collect),
  {ok, State#state{timer = Timer}}.

handle_call(get_header_data, _From, State=#state{headerProplist = HeaderProplist}) ->
%%  ?LOGF("get_data:~p~n", [HeaderProplist]),
  {reply, HeaderProplist, State};
handle_call(get_pidlist_data, _From, State=#state{processesProplist=ProcessesProplist}) ->
%%  ?LOGF("get_data:~p~n", [ProcessesProplist]),
  {reply, ProcessesProplist, State};
handle_call(_Request, _From, State) ->
  {reply, ok, State}.

handle_cast(_Request, State) ->
  {noreply, State}.

handle_info(collect, State) ->
  ?LOGLN("collect"),
  Collector = State#state.remote_collector,
  {ok, HeaderProplist, ProcessesProplist} = Collector:get_data(),
%%  ?LOGF("get_data:~p~n", [ProcessesProplist]),
  Timer = erlang:send_after(State#state.interval, self(), collect),
  {noreply, State#state{
    headerProplist = HeaderProplist,
    processesProplist=ProcessesProplist,
    timer = Timer
  }};
handle_info(_Info, State) ->
  {noreply, State}.

terminate(_Reason, _State) ->
  ok.

code_change(_OldVsn, State, _Extra) ->
  {ok, State}.

%%%===================================================================
%%% Internal functions
%%%===================================================================



%%monitors(Nodes) ->
%%  monitors(Nodes, []).
%%
%%monitors([], Results) ->
%%  Results;
%%monitors([Node | Others], Results) ->
%%  Result = monitor(Node),
%%  monitors(Others, [Result | Results]).

monitor(Node, Cookie, NameType) ->
%%  case net_kernel:start(NameType) of
%%    {ok, _} ->
      case maybe_set_cookie(Node, Cookie) of
        ok ->
          case start(Node) of
            error ->
              io:format("Unable to connect to '~p', check nodename, cookie and network~n", [Node]),
              throw(cant_connect);
            State ->
              State
          end;
        CE ->
          io:format("Cookie ~p is malformed, got error ~p~n", [Cookie, CE]),
          throw(CE)
%%      end;
%%    NetError ->
%%      io:format("Couldn't start network with ~p, got error ~p~n", [NameType, NetError]),
%%      throw(NetError)
  end.



start(Node) ->
  % @todo 多结点的情况
  case net_kernel:connect(Node) of
    true ->
      State = #state { node = Node, connected = true },
      Static_data = load_remote_static_data(Node),
      remote_load_code(State#state.remote_collector, Node),
      State#state{static_data = Static_data};
    false ->
      error
  end.


load_remote_static_data(Node) ->
  RPC = fun(M, F, A) -> rpc:call(Node, M, F, A) end,
  Otp = RPC(erlang, system_info, [otp_release]),
  Erts = RPC(erlang, system_info, [version]),
  Os = RPC(os, type, []),
  OsVers = RPC(os, version, []),
  Flags = [
    {cpus, RPC(erlang, system_info, [logical_processors])},
    {smp, RPC(erlang, system_info, [smp_support])},
    {a_threads, RPC(erlang, system_info, [thread_pool_size])},
    {kpoll, RPC(erlang, system_info, [kernel_poll])}
  ],
  #static_data{
    otp_version = Otp,
    erts_version = Erts,
    node_flags = Flags,
    os_type = Os,
    os_version = OsVers
  }.

remote_load_code(Module, Node) ->
  {_, Binary, Filename} = code:get_object_code(Module),
  rpc:call(Node, code, load_binary, [Module, Filename, Binary]).



maybe_set_cookie(_, undefined) -> ok;
maybe_set_cookie(Node, Cookie) ->
  case erlang:set_cookie(Node,Cookie) of
    true -> ok;
    E -> E
  end.

