%%%-------------------------------------------------------------------
%% @doc erlmonitor public API
%% @end
%%%-------------------------------------------------------------------

-module(erlmonitor_app).

-behaviour(application).

%% Application callbacks
-export([start/2, stop/1]).

%%====================================================================
%% API
%%====================================================================

start(_StartType, _StartArgs) ->
  Dispatch = cowboy_router:compile([
    {'_', [
%%      {"/", erlmonitor_handler, []}
      {"/", cowboy_static, {priv_file, erlmonitor, "index.html"}},
      {"/static/[...]", cowboy_static, {priv_dir, erlmonitor, "static/"}},
      {"/js/[...]", cowboy_static, {priv_dir, erlmonitor, "js/"}},
      {"/normal/[...]", erlmonitor_handler, []},
      {"/ajax/:way", erlmonitor_ajax, []},
%%      {"/socket.io/", erlmonitor_socket_io, []},
      {"/websocket/", erlmonitor_websocket, []}
    ]}
  ]),
  {ok, Port} = application:get_env(port),
  {ok, _} = cowboy:start_clear(http, [
    {port, Port}], #{
      env => #{dispatch => Dispatch}
    }
  ),
  erlmonitor_sup:start_link().

%%--------------------------------------------------------------------
stop(_State) ->
  ok.

%%====================================================================
%% Internal functions
%%====================================================================
