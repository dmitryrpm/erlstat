%% @author author <author@example.com>
%% @copyright YYYY author.

%% @doc Callbacks for the stat application.

-module(stat_app).
-author('author <author@example.com>').

-behaviour(application).
-export([start/2, stop/1]).


%% @spec start(_Type, _StartArgs) -> ServerRet
%% @doc application start callback for stat.
start(_Type, _StartArgs) ->
    stat_deps:ensure(),
    stat_sup:start_link().

%% @spec stop(_State) -> ServerRet
%% @doc application stop callback for stat.
stop(_State) ->
    ok.


%%
%% Tests
%%
-include_lib("eunit/include/eunit.hrl").
-ifdef(TEST).
-endif.
