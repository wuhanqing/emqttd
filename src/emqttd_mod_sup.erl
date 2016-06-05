%%--------------------------------------------------------------------
%% Copyright (c) 2012-2016 Feng Lee <feng@emqtt.io>.
%%
%% Licensed under the Apache License, Version 2.0 (the "License");
%% you may not use this file except in compliance with the License.
%% You may obtain a copy of the License at
%%
%%     http://www.apache.org/licenses/LICENSE-2.0
%%
%% Unless required by applicable law or agreed to in writing, software
%% distributed under the License is distributed on an "AS IS" BASIS,
%% WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
%% See the License for the specific language governing permissions and
%% limitations under the License.
%%--------------------------------------------------------------------

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

%%--------------------------------------------------------------------
%% API
%%--------------------------------------------------------------------

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

%%--------------------------------------------------------------------
%% Supervisor callbacks
%%--------------------------------------------------------------------

init([]) ->
    {ok, {{one_for_one, 10, 100}, []}}.


