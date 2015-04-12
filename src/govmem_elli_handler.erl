-module(govmem_elli_handler).
-export([handle/2, handle_event/3]).

-include_lib("elli/include/elli.hrl").
-include_lib("kernel/include/file.hrl").
-behaviour(elli_handler).

handle(Req, _Args) ->
    %% Delegate to our handler function
    handle(Req#req.method, elli_request:path(Req), Req).

handle('GET',[<<"hello">>, <<"world">>], _Req) ->
    %% Reply with a normal response. 'ok' can be used instead of '200'
    %% to signal success.
    {ok, [], <<"Hello World!">>};
handle('GET',[], _Req)                 -> index_html();
handle('GET',[<<"index.html">>], _Req) -> index_html();
handle(_, _, _Req) ->
    {404, [], <<"Not Found">>}.

%% @doc: Handle request events, like request completed, exception
%% thrown, client timeout, etc. Must return 'ok'.
handle_event(Event, _Data, Args) ->
    lager:info("event=~p data=~p args=~p", [Event, no, Args]),
    ok.

index_html() ->
    Dir = code:priv_dir(govmem),
    F = filename:join(Dir, "index.html"),
    case file:read_file_info(F) of
	{ok, #file_info{type = regular, access = Perm, size = Size}}
	  when Perm =:= read orelse Perm =:= read_write ->
	    {ok, [{"Content-Length", Size}, {"Content-Type", "text/html; charset=utf-8"}], {file, F}};
	Err ->
	    lager:error("Error reading index.html: error=~p",[Err]),
	    throw(index_html_not_found)
    end.
