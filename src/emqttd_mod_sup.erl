%%%-----------------------------------------------------------------------------
%%% Copyright (c) 2012-2015 eMQTT.IO, All Rights Reserved.
%%%
%%% Permission is hereby granted, free of charge, to any person obtaining a copy
%%% of this software and associated documentation files (the "Software"), to deal
%%% in the Software without restriction, including without limitation the rights
%%% to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
%%% copies of the Software, and to permit persons to whom the Software is
%%% furnished to do so, subject to the following conditions:
%%%
%%% The above copyright notice and this permission notice shall be included in all
%%% copies or substantial portions of the Software.
%%%
%%% THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
%%% IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
%%% FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
%%% AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
%%% LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
%%% OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
%%% SOFTWARE.
%%%-----------------------------------------------------------------------------
%%% @doc emqttd module supervisor.
%%%
%%% @author Feng Lee <feng@emqtt.io>
%%%-----------------------------------------------------------------------------
-module(emqttd_mod_sup).

-behaviour(supervisor).

-include("emqttd.hrl").

%% API
-export([start_link/0, start_mod/1, start_mod/2, stop_mod/1]).

%% Supervisor callbacks
-export([init/1]).

-define(SUPERVISOR, ?MODULE).

%% Helper macro for declaring children of supervisor
-define(CHILD(Mod, Type), {Mod, {Mod, start_link, []},
                               permanent, 5000, Type, [Mod]}).

-define(CHILD(Mod, Type, Opts), {Mod, {Mod, start_link, [Opts]},
                                     permanent, 5000, Type, [Mod]}).

%%%=============================================================================
%%% API
%%%=============================================================================

start_link() ->
    supervisor:start_link({local, ?SUPERVISOR}, ?MODULE, []).

%%%=============================================================================
%%% API
%%%=============================================================================
start_mod(Mod) ->
	supervisor:start_child(?SUPERVISOR, ?CHILD(Mod, worker)).

start_mod(Mod, Opts) ->
	supervisor:start_child(?SUPERVISOR, ?CHILD(Mod, worker, Opts)).

stop_mod(Mod) ->
	case supervisor:terminate_child(?SUPERVISOR, Mod) of
        ok ->
            supervisor:delete_child(?SUPERVISOR, Mod);
        {error, Reason} ->
            {error, Reason}
	end.

%%%=============================================================================
%%% Supervisor callbacks
%%%=============================================================================

init([]) ->
    {ok, {{one_for_one, 10, 3600}, []}}.


