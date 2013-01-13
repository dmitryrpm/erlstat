%% @author author <author@example.com>
%% @copyright YYYY author.

%% @doc Web server for stat.

-module(stat_web).
-author('dtikhonov <admin@suwer.ru>').

-export([start/1, stop/0, loop/3]).

%% External API

start(Options) ->
    {DocRoot, Options1} = get_option(docroot, Options),
    {ok, C} = eredis:start_link(),
    Loop = fun (Req) ->
                   ?MODULE:loop(Req, DocRoot, C)
           end,
    mochiweb_http:start([{name, ?MODULE}, {loop, Loop} | Options1]).

stop() ->
    mochiweb_http:stop(?MODULE).

loop(Req, DocRoot, C) ->
    "/" ++ Path = Req:get(path),
    case Req:get(method) of
        Method when Method =:= 'GET'; Method =:= 'POST' ->

            %% static files
            case Path of
                "cors.html" ->
                    Req:serve_file(Path, DocRoot);
                "crossdomain.xml" ->
                    Req:serve_file(Path, DocRoot);
                _ -> ok
            end,

            %% parse Track_id and check result
            Track_id = parse_track_id(Req),
            case Track_id of
                Track when Track =:= undefined ->
                    fail_track_id(Req);
                _ ->
                    %% API: get, set mode
                    Key = string:concat(string:concat(Track_id, "_"), Req:get(peer)),
                    case Path of
                        Path when Path == "get"; Path == "get/" ->
                            Val = get_stat(Track_id, C),
                            success_track_id(Val, Req);
                        Path when Path == "set"; Path == "set/" ->
                            Count = get_ip(Key, C),
                            Val = case Count of
                                <<"1">> ->
                                    get_stat(Track_id, C);
                                _ ->
                                    set_ip(Key, C),
                                    set_stat(Track_id, C)
                            end,
                            success_track_id(Val, Req);
                        _ ->
                            fail_track_id(Req)
                    end
            end;
        _ ->
            Req:respond({501, [],
                ["{ \"error\" : \"Internal Server Error\" }"]})
    end.

get_option(Option, Options) ->
    {proplists:get_value(Option, Options), proplists:delete(Option, Options)}.


%% Results
fail_track_id(Req) ->
    Req:ok({"application/json", [{"Access-Control-Allow-Origin", "*"}],
        ["{\"error\":\"Incorrect 'track_id' param\"}"]}).

success_track_id(Val, Req) ->
    Req:ok({"application/json", [{"Access-Control-Allow-Origin", "*"}],
        ["{\"value\":\"" ++  binary_to_list(Val) ++ "\"}"]}).

parse_track_id(Req) ->
    proplists:get_value("track_id", Req:parse_qs()).

%% Internal Redis API
set_stat(Track_id, C) ->
    {ok, Val} = eredis:q(C, ["ZINCRBY", "STAT", 1, Track_id]),
    Val.

get_stat(Track_id, C) ->
    {ok, Val} = eredis:q(C, ["ZSCORE", "STAT", Track_id]),
    case Val of
        undefined -> <<"0">>;
        _ -> Val
    end.

set_ip(Key, C) ->
    {ok, Val} = eredis:q(C, ["SET", Key, 1]),
    {ok, _} = eredis:q(C, ["EXPIRE", Key, 3600]),
    Val.

get_ip(Key, C) ->
    {ok, Count} = eredis:q(C, ["GET", Key]),
    Count.

%%
%% Tests
%%
-include_lib("eunit/include/eunit.hrl").
-ifdef(TEST).
-endif.
