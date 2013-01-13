%% @author author <author@example.com>
%% @copyright YYYY author.

%% @doc TEMPLATE.

-module(stat).
-author('author <author@example.com>').
-export([start/0, stop/0]).

ensure_started(App) ->
    case application:start(App) of
        ok ->
            ok;
        {error, {already_started, App}} ->
            ok
    end.

%% @spec start() -> ok
%% @doc Start the stat server.
start() ->
    stat_deps:ensure(),
    ensure_started(crypto),
    application:start(stat).

%% @spec stop() -> ok
%% @doc Stop the stat server.
stop() ->
    Res = application:stop(stat),
    application:stop(crypto),
    Res.
