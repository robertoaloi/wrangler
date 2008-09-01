%%%-------------------------------------------------------------------
%%% File    : wrangler_error_logger.erl
%%% Author  :  <Huiqing Li>
%%% Description : 
%%%
%%% Created : 31 Aug 2008 by  <Huiqing Li>
%%%-------------------------------------------------------------------
-module(wrangler_error_logger).

-behaviour(gen_server).

%% API
-export([start_wrangler_error_logger/0, check_logged_errors/0, add_error_to_logger/1]).

%% gen_server callbacks
-export([init/1, handle_call/3, handle_cast/2, handle_info/2,
	 terminate/2, code_change/3]).

-record(state, {errors=[]}).

%%====================================================================
%% API
%%====================================================================
%%--------------------------------------------------------------------
%% Function: start_wrangler_error_logger() -> {ok,Pid} | ignore | {error,Error}
%% Description: Starts the server
%%--------------------------------------------------------------------
start_wrangler_error_logger() ->
    gen_server:start_link({local, wrangler_error_logger}, ?MODULE, [], []).

check_logged_errors() ->
    gen_server:cast(wrangler_error_logger, check_errors).

add_error_to_logger(Error) ->
    gen_server:cast(wrangler_error_logger, {add, Error}).


%%====================================================================
%% gen_server callbacks
%%====================================================================

%%--------------------------------------------------------------------
%% Function: init(Args) -> {ok, State} |
%%                         {ok, State, Timeout} |
%%                         ignore               |
%%                         {stop, Reason}
%% Description: Initiates the server
%%--------------------------------------------------------------------
init([]) ->
    {ok, #state{}}.

%%--------------------------------------------------------------------
%% Function: %% handle_call(Request, From, State) -> {reply, Reply, State} |
%%                                      {reply, Reply, State, Timeout} |
%%                                      {noreply, State} |
%%                                      {noreply, State, Timeout} |
%%                                      {stop, Reason, Reply, State} |
%%                                      {stop, Reason, State}
%% Description: Handling call messages
%%--------------------------------------------------------------------
handle_call(_Request, _From, State) ->
    Reply = ok,
    {reply, Reply, State}.

%%--------------------------------------------------------------------
%% Function: handle_cast(Msg, State) -> {noreply, State} |
%%                                      {noreply, State, Timeout} |
%%                                      {stop, Reason, State}
%% Description: Handling cast messages
%%--------------------------------------------------------------------
handle_cast(check_errors, _State=#state{errors=Errors}) ->
      case Errors of 
		[] ->
		     ok; 
		_ ->
		    io:format("\n===============================WARNING===============================\n"),
		    io:format("Due to the following syntactical errors in the program, attributes/functions affected "
			      "by these errors were not affected by this refactoring!\n"),
		    lists:foreach(fun({FileName, Errs}) ->
				      Errs1 = lists:map(fun({Pos, _Mod, Msg}) -> {Pos, Msg} end, Errs),
				      io:format("File:\n ~p\n", [FileName]),
				      io:format("Error(s):\n"),
				      lists:foreach(fun({Pos, Msg}) -> io:format(" ** ~p:~s **\n", [Pos, Msg]) end, lists:reverse(Errs1)) %% lists:flatten(Msg)
			      end, Errors)
      end,
     {noreply, #state{}};
handle_cast({add, Error}, _State=#state{errors=Errors}) ->
    {noreply, #state{errors=lists:usort([Error|Errors])}}.

%%--------------------------------------------------------------------
%% Function: handle_info(Info, State) -> {noreply, State} |
%%                                       {noreply, State, Timeout} |
%%                                       {stop, Reason, State}
%% Description: Handling all non call/cast messages
%%--------------------------------------------------------------------
handle_info(_Info, State) ->
    {noreply, State}.

%%--------------------------------------------------------------------
%% Function: terminate(Reason, State) -> void()
%% Description: This function is called by a gen_server when it is about to
%% terminate. It should be the opposite of Module:init/1 and do any necessary
%% cleaning up. When it returns, the gen_server terminates with Reason.
%% The return value is ignored.
%%--------------------------------------------------------------------
terminate(_Reason, _State) ->
    ok.

%%--------------------------------------------------------------------
%% Func: code_change(OldVsn, State, Extra) -> {ok, NewState}
%% Description: Convert process state when code is changed
%%--------------------------------------------------------------------
code_change(_OldVsn, State, _Extra) ->
    {ok, State}.

%%--------------------------------------------------------------------
%%% Internal functions
%%--------------------------------------------------------------------
