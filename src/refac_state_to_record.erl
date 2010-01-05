%% Copyright (c) 2009, Huiqing Li, Simon Thompson
%% All rights reserved.
%%
%% Redistribution and use in source and binary forms, with or without
%% modification, are permitted provided that the following conditions are met:
%%     %% Redistributions of source code must retain the above copyright
%%       notice, this list of conditions and the following disclaimer.
%%     %% Redistributions in binary form must reproduce the above copyright
%%       notice, this list of conditions and the following disclaimer in the
%%       documentation and/or other materials provided with the distribution.
%%     %% Neither the name of the copyright holders nor the
%%       names of its contributors may be used to endoorse or promote products
%%       derived from this software without specific prior written permission.
%%
%% THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS ''AS IS''
%% AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE 
%% IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE 
%% ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDERS AND CONTRIBUTORS 
%% BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR 
%% CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF 
%% SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR 
%% BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, 
%% WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR 
%% OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF 
%% ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
%% ============================================================================================
%% Refactoring: Introduce a ?LET.
%%
%% Author contact: hl@kent.ac.uk, sjt@kent.ac.uk
%% 
%% =============================================================================================

%% =============================================================================================
-module(refac_state_to_record).

-export([eqc_statem_to_record/3, eqc_statem_to_record_1/7,
	 eqc_statem_to_record_eclipse/3, eqc_statem_to_record_1_eclipse/7,
	 eqc_fsm_to_record/3,  eqc_fsm_to_record_1/7,
	 eqc_fsm_to_record_eclipse/3, eqc_fsm_to_record_1_eclipse/7,
	 gen_fsm_to_record/3,  gen_fsm_to_record_1/7,
	 gen_fsm_to_record_eclipse/3, gen_fsm_to_record_1_eclipse/7]).

-include("../include/wrangler.hrl").

-define(DEBUG, true).

-ifdef(DEBUG).
-define(debug(__String, __Args), ?wrangler_io(__String, __Args)).
-else.
-define(debug(__String, __Args), ok).
-endif.


-define(Msg, "Wrangler failed to infer the current data type of the state.").

%% =============================================================================================
-spec(eqc_statem_to_record/3::(filename(),[dir()], integer()) -> {'ok', non_tuple, [{atom(), atom(), integer()}]} | 
								 {'ok', {tuple, integer()}, [{atom(), atom(), integer()}]}).

eqc_statem_to_record(FileName, SearchPaths, TabWidth) ->
    ?wrangler_io("\nCMD: ~p:eqc_statem_to_record(~p,~p, ~p).\n",
		 [?MODULE, FileName,SearchPaths, TabWidth]),
    eqc_statem_to_record(FileName, SearchPaths, TabWidth, emacs).

eqc_statem_to_record_eclipse(FileName, SearchPaths, TabWidth) ->
    eqc_statem_to_record(FileName,SearchPaths, TabWidth, eclipse).


eqc_statem_to_record(FileName, SearchPaths, TabWidth, _Editor) ->
    state_to_record(FileName, SearchPaths, TabWidth, eqc_statem).


eqc_statem_to_record_1(FileName, RecordName, RecordFields, StateFuns, IsTuple, SearchPaths, TabWidth) ->
    format_args(FileName, RecordName, RecordFields, StateFuns, IsTuple, SearchPaths, TabWidth,	"eqc_statem_to_record_1"),
    eqc_statem_to_record(FileName, RecordName, RecordFields, StateFuns, IsTuple, SearchPaths, TabWidth, emacs, "").

eqc_statem_to_record_1_eclipse(FileName, RecordName, RecordFields, StateFuns, IsTuple, SearchPaths, TabWidth) ->
    eqc_statem_to_record(FileName, RecordName, RecordFields, StateFuns, IsTuple, SearchPaths, TabWidth, eclipse, "").

eqc_statem_to_record(FileName, RecordName, RecordFields, StateFuns, IsTuple, SearchPaths, TabWidth, Editor, Cmd) ->
    state_to_record_1(FileName, RecordName, RecordFields, StateFuns, IsTuple, 
		      eqc_statem, SearchPaths, TabWidth, Editor, Cmd).


%% =============================================================================================
-spec(eqc_fsm_to_record/3::(filename(),[dir()], integer()) -> {'ok', non_tuple, [{atom(), atom(), integer()}]} | 
		                                              {'ok', {tuple, integer()}, [{atom(), atom(),integer()}]}).
eqc_fsm_to_record(FileName, SearchPaths, TabWidth) ->
    ?wrangler_io("\nCMD: ~p:eqc_fsm_to_record(~p,~p, ~p).\n", [?MODULE, FileName,SearchPaths, TabWidth]),
    eqc_fsm_to_record(FileName, SearchPaths, TabWidth, emacs).

eqc_fsm_to_record_eclipse(FileName, SearchPaths, TabWidth) ->
    eqc_fsm_to_record(FileName,SearchPaths, TabWidth, eclipse).


eqc_fsm_to_record(FileName, SearchPaths, TabWidth, _Editor) ->
    state_to_record(FileName, SearchPaths, TabWidth, eqc_fsm).

eqc_fsm_to_record_1(FileName, RecordName, RecordFields, StateFuns, IsTuple, SearchPaths, TabWidth) ->
    format_args(FileName, RecordName, RecordFields, StateFuns, IsTuple, SearchPaths, TabWidth,	"eqc_fsm_to_record_1"),
    eqc_fsm_to_record(FileName, RecordName, RecordFields, StateFuns,
		      IsTuple, SearchPaths, TabWidth, emacs, "").

eqc_fsm_to_record_1_eclipse(FileName, RecordName, RecordFields, StateFuns, IsTuple, SearchPaths, TabWidth) ->
    eqc_fsm_to_record(FileName, RecordName, RecordFields, StateFuns, IsTuple, SearchPaths, TabWidth, eclipse, "").

eqc_fsm_to_record(FileName, RecordName, RecordFields, StateFuns, IsTuple, SearchPaths, TabWidth, Editor, Cmd) ->
    state_to_record_1(FileName, RecordName, RecordFields, StateFuns, IsTuple, 
		      eqc_fsm, SearchPaths, TabWidth, Editor, Cmd).



%% =============================================================================================
-spec(gen_fsm_to_record/3::(filename(),[dir()], integer()) -> {'ok', non_tuple, [{atom(), atom(), integer()}]} | 
							      {'ok', {tuple, integer()}, [{atom(), atom(), integer()}]}).

gen_fsm_to_record(FileName, SearchPaths, TabWidth) ->
    ?wrangler_io("\nCMD: ~p:gen_fsm_to_record(~p,~p, ~p).\n", [?MODULE, FileName,SearchPaths, TabWidth]),
    gen_fsm_to_record(FileName, SearchPaths, TabWidth, emacs).

gen_fsm_to_record_eclipse(FileName, SearchPaths, TabWidth) ->
    gen_fsm_to_record(FileName,SearchPaths, TabWidth, eclipse).


gen_fsm_to_record(FileName, SearchPaths, TabWidth, _Editor) ->
    state_to_record(FileName, SearchPaths, TabWidth, gen_fsm).


gen_fsm_to_record_1(FileName, RecordName, RecordFields, StateFuns, IsTuple, SearchPaths, TabWidth) ->
    format_args(FileName, RecordName, RecordFields, StateFuns, IsTuple, SearchPaths, TabWidth, "gen_fsm_to_record_1"),
    gen_fsm_to_record(FileName, RecordName, RecordFields, StateFuns, IsTuple, SearchPaths, TabWidth, emacs, "").

gen_fsm_to_record_1_eclipse(FileName, RecordName, RecordFields, StateFuns, IsTuple, SearchPaths, TabWidth) ->
    gen_fsm_to_record(FileName, RecordName, RecordFields, StateFuns, IsTuple, SearchPaths, TabWidth, eclipse, "").

gen_fsm_to_record(FileName, RecordName, RecordFields, StateFuns, IsTuple, SearchPaths, TabWidth, Editor, Cmd) ->
    state_to_record_1(FileName, RecordName, RecordFields, StateFuns, IsTuple, 
		      gen_fsm, SearchPaths, TabWidth, Editor, Cmd).


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%  format refactoring command                                                 %%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
format_args(FileName, RecordName, RecordFields, StateFuns, IsTuple, SearchPaths, TabWidth, FunName) ->
    ?wrangler_io("\nCMD: ~p:" ++ FunName ++ "(~p,~p,", [?MODULE, FileName, RecordName]),
    ?wrangler_io(format_field_names(RecordFields) ++ ",", []),
    ?wrangler_io(format_state_funs(StateFuns), []),
    ?wrangler_io(",~p,~p, ~p).\n", [IsTuple, SearchPaths, TabWidth]).


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Pre-condition check                                                        %%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

pre_cond_check(RecordName, FieldNames, ModInfo) ->
    check_record_and_field_names(RecordName, FieldNames),
    FieldNames1 = [list_to_atom(F) || F <-FieldNames],
    check_existing_records(list_to_atom(RecordName),  FieldNames1, ModInfo).


check_record_and_field_names(RecordName, FieldNames) ->
    case refac_util:is_fun_name(RecordName) of
      true ->
	    ok;
	_ -> throw({error, "Invalid record name."})
    end,
    lists:foreach(
      fun (F) ->
	      case refac_util:is_fun_name(F) of
		true ->
		    ok;
		_ -> throw({error, "Invalid field name: " ++ F ++ "."})
	      end
      end, FieldNames),
    case length(lists:usort(FieldNames))=/= length(FieldNames) of
	true ->
	    throw({error, "Some field names are the same."});
	false ->
	    ok
    end.

check_existing_records(RecordName, FieldNames, Info) ->
    case lists:keysearch(records, 1, Info) of 
	{value, {records, RecordList}} ->
	    case lists:keysearch(RecordName, 1, RecordList) of 
		{value, {RecordName, Fields}} ->
		    case length(Fields) =/= length(FieldNames) of
			true ->
			    throw({error, "Record with the same name, "
				   "but different number of fields, "
				   "is already in scope."});
			false ->
			    ok
		    end,
		    FieldNames1 = [F || {F, _V} <- Fields],
		    case lists:usort(FieldNames)== lists:usort(FieldNames1) of 
			true ->
			    true;
			false ->
			    throw({error, "Record with the same name, "
				   "but different field names, "
				   "is already in scope."})
		    end
	    end;
	false ->
	    false
    end.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%    
%%                  Transformation                                             %%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

state_to_record(FileName, SearchPaths, TabWidth, SM) ->
    {ok, {_,  ModInfo}} = refac_util:parse_annotate_file(FileName, true, SearchPaths, TabWidth),
    {value, {module, ModName}} = lists:keysearch(module, 1, ModInfo),
    case is_statemachine_used(ModInfo, SM) of
	true ->
	    check_current_state_type(FileName, ModName, ModInfo, SM);
	{error, Msg}-> throw({error, Msg})
    end.


state_to_record_1(FileName, RecordName, RecordFields, StateFuns, IsTuple, SM, SearchPaths, TabWidth, Editor, Cmd) ->
    {ok, {AnnAST, Info}} = refac_util:parse_annotate_file(FileName, true, SearchPaths, TabWidth),
    {value, {module, ModName}} = lists:keysearch(module, 1, Info),
    RecordExists = pre_cond_check(RecordName, RecordFields, Info),
    RecordFields1 = [list_to_atom(F) || F <- RecordFields],
    AnnAST1 = do_state_to_record(ModName, Info, AnnAST, list_to_atom(RecordName), RecordFields1, 
				 StateFuns,RecordExists, IsTuple, SM),
    case Editor of
	emacs ->
	    refac_util:write_refactored_files_for_preview([{{FileName, FileName}, AnnAST1}], Cmd),
	    {ok, [FileName]};
	eclipse ->
	    Content = refac_prettypr:print_ast(refac_util:file_format(FileName), AnnAST1),
	    {ok, [{FileName, FileName, Content}]}
    end.



do_state_to_record(ModName, ModInfo,  AnnAST, RecordName, RecordFields, StateFuns, RecordExists, IsTuple, SM) ->
    Forms = refac_syntax:form_list_elements(AnnAST),
    TupleToRecordFunName = tuple_to_record_fun_name(ModInfo, RecordName),
    RecordToTupleFunName = record_to_tuple_fun_name(ModInfo, RecordName),
    Fun = fun (F) ->
		  case refac_syntax:type(F) of
		    function ->
			do_state_to_record_1(ModName, F, RecordName, RecordFields, StateFuns, IsTuple, SM, 
					     TupleToRecordFunName, RecordToTupleFunName);
		    _ -> F
		  end
	  end,
    Forms1 = [Fun(F) || F <- Forms],
    Forms2 = add_util_funs(Forms1, RecordName, RecordFields,TupleToRecordFunName, RecordToTupleFunName),
    case RecordExists of
      true ->
	  refac_syntax:form_list(Forms2);
      false ->
	  RecordDef = mk_record_attribute(RecordName, RecordFields),
	  NewForms =  insert_record_attribute(Forms2, RecordDef),
	  refac_syntax:form_list(NewForms)
    end.

do_state_to_record_1(ModName, Fun, RecordName, RecordFields, StateFuns, IsTuple, 
		     SM, TupleToRecordFunName, RecordToTupleFunName) ->
    As = refac_syntax:get_ann(Fun),
    {value, {fun_def, {M, F, A, _, _}}} = lists:keysearch(fun_def, 1, As),
    CallBacks =  callbacks(ModName, StateFuns, SM),
    NewFun = case lists:keysearch({M, F, A}, 1, CallBacks) of
		 {value, {{M, F, A}, {PatIndex, ReturnState}}} ->
		     ?debug("MFA1:\n~p\n", [{M,F,A}]),
		     do_state_to_record_in_callback_fun(
		       PatIndex, Fun, RecordName, RecordFields, IsTuple, ReturnState, SM, 
		       TupleToRecordFunName, RecordToTupleFunName);
		 false -> Fun
	     end,
    wrap_fun_interface(NewFun, ModName, RecordName, RecordFields, IsTuple, StateFuns, SM,
		      TupleToRecordFunName, RecordToTupleFunName).
	  
		 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
 
do_state_to_record_in_callback_fun(PatIndex, Fun, RecordName, RecordFields, IsTuple, ReturnState, SM,
				  TupleToRecordFunName, RecordToTupleFunName) ->
    FunName = refac_syntax:function_name(Fun),
    Cs = refac_syntax:function_clauses(Fun),
    Cs1 = [do_state_to_record_in_callback_clause(PatIndex, C, RecordName, RecordFields, 
						 IsTuple, ReturnState, SM, TupleToRecordFunName, 
						 RecordToTupleFunName) 
	   || C <- Cs],
    refac_util:rewrite(Fun, refac_syntax:function(FunName, Cs1)).


do_state_to_record_in_callback_clause(PatIndex, C, RecordName, RecordFields, IsTuple, ReturnState, SM, 
				     TupleToRecordFunName, RecordToTupleFunName) ->
    Ps = refac_syntax:clause_patterns(C),
    G = refac_syntax:clause_guard(C),
    B = refac_syntax:clause_body(C),
    {Ps1, DefPs}  = do_state_to_record_in_pats(Ps, PatIndex, RecordName, RecordFields, IsTuple), 
    B1 = do_state_to_record_in_callback_fun_clause_body(
	   B, RecordName, RecordFields, DefPs, IsTuple, ReturnState, SM,TupleToRecordFunName, RecordToTupleFunName),
    B2= remove_record_tuple_conversions(refac_syntax:block_expr(B1), TupleToRecordFunName, RecordToTupleFunName),
    B3= refac_syntax:block_expr_body(B2),
    refac_util:rewrite(C, refac_syntax:clause(Ps1, G, B3)).


do_state_to_record_in_pats(Ps, PatIndex, RecordName, RecordFields, IsTuple) ->
    Res =[do_state_to_record_in_pats_1({P, Index}, PatIndex, RecordName, RecordFields, IsTuple) || 
	     {P, Index}<- lists:zip(Ps, lists:seq(1, length(Ps)))],
    {NewPs, DefPs} =lists:unzip(Res),
    {NewPs, lists:append(DefPs)}.

do_state_to_record_in_pats_1({P, Index}, PatIndex, RecordName, RecordFields, IsTuple) ->
    case lists:member(Index, PatIndex) of 
	true ->
	    do_state_to_record_in_pats_2(P, RecordName, RecordFields, IsTuple);
	false ->
	    {P,[]}
    end.

do_state_to_record_in_pats_2(P, RecordName, RecordFields, IsTuple) ->
    case refac_syntax:type(P) of
	variable ->
	    {P, [refac_syntax:get_pos(P)]};
	tuple when IsTuple ->
	    RecordExpr = tuple_to_record_expr(P, RecordName, RecordFields),
	    {refac_util:rewrite(P, RecordExpr),[]};
	match_expr ->
	    tuple_to_record_in_match_expr_pattern(
	      P, RecordName, RecordFields, IsTuple);
	underscore ->
	    {P, []};
	_ when IsTuple ->
	    Pos = refac_syntax:get_pos(P),
	    throw({error, "Wrangler did not know how to transform the pattern at location: " 
		   ++ io_lib:format("~p", [Pos])});
	_ when length(RecordFields) == 1 ->
	    Fields = [mk_record_field(hd(RecordFields), P)],
	    P1 = refac_util:rewrite(P, mk_record_expr(RecordName, Fields)),
	    {P1, []};
      _ ->
	  Pos = refac_syntax:get_pos(P),
	  throw({error, "Wrangler did not know how to transform the pattern at location: " 
		 ++ io_lib:format("~p", [Pos])})
    end.

tuple_to_record_in_match_expr_pattern(State, RecordName, RecordFields, IsTuple)->	   
    P=refac_syntax:match_expr_pattern(State),
    B = refac_syntax:match_expr_body(State),
    {P1, Pos1} =
	do_state_to_record_in_pats_2(P, RecordName, RecordFields, IsTuple),
    {B1, Pos2} = 
	do_state_to_record_in_pats_2(B, RecordName, RecordFields, IsTuple),
    {refac_util:rewrite(State, refac_syntax:match_expr(P1,B1)), Pos1++Pos2}.


do_state_to_record_in_callback_fun_clause_body(Body, RecordName, RecordFields, 
					       DefPs, IsTuple, ReturnState, SM,
					      TupleToRecordFunName, RecordToTupleFunName) ->
    ?debug("RecordFields:\n~p\n", [RecordFields]),
    Fun = fun (Node, _Others) ->
		  case refac_syntax:type(Node) of
		      application when IsTuple ->
			  As = refac_syntax:get_ann(refac_syntax:application_operator(Node)),
			  case lists:keysearch(fun_def, 1, As) of
			      {value, {fun_def, {erlang, element, 2, _, _}}} ->
				  element_to_record_access(RecordName, RecordFields, DefPs, Node,RecordToTupleFunName);
			      {value, {fun_def, {erlang, setelement, 3, _, _}}} ->
				  setelement_to_record_expr(Node, RecordName, RecordFields, DefPs, IsTuple,
							  TupleToRecordFunName, RecordToTupleFunName);			  
			      _ -> Node
			  end;
		      variable ->
			  As = refac_syntax:get_ann(Node),
			  case lists:keysearch(def, 1, As) of
			      {value, {def, DefinePos}} ->
				  case DefinePos -- DefPs =/= DefinePos of
				      true ->
					  make_record_to_tuple_app(Node, RecordName, RecordFields, IsTuple, 
								  TupleToRecordFunName, RecordToTupleFunName);
				      false ->
					  Node
				  end;
			      false -> Node
			  end;
		      _ -> Node
		  end
	  end,
    Body1 = refac_util:full_buTP(Fun, refac_syntax:block_expr(Body), {}),
    Body2 = is_tuple_to_is_record(Body1, RecordName,RecordToTupleFunName),
    Body3 = refac_syntax:block_expr_body(Body2),
    case ReturnState of 
	true ->
 	    do_state_to_record_in_init_fun_clause_body(
	      Body3, RecordName, RecordFields, DefPs, IsTuple, SM,
	      TupleToRecordFunName, RecordToTupleFunName);
	false ->
	    Body3
    end.


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

do_state_to_record_in_init_fun_clause(C, RecordName, RecordFields, IsTuple, SM,
				     TupleToRecordFunName, RecordToTupleFunName) ->
    P = refac_syntax:clause_patterns(C),
    G = refac_syntax:clause_guard(C),
    B = refac_syntax:clause_body(C),
    B1=do_state_to_record_in_init_fun_clause_body(B, RecordName, RecordFields,[], IsTuple, SM,
						 TupleToRecordFunName, RecordToTupleFunName),
    refac_util:rewrite(C, refac_syntax:clause(P, G, B1)).

 
		      
do_state_to_record_in_init_fun_clause_body(Body, RecordName, RecordFields, DefPs, IsTuple, SM, 
					 TupleToRecordFunName, RecordToTupleFunName) ->
    Msg = "Wrangler did not know how to transform the expression at location: ",
    [LastExpr| Exprs] = lists:reverse(Body),
    Pos = refac_syntax:get_pos(LastExpr),
    case refac_syntax:type(LastExpr) of
	tuple when IsTuple ->
	    case SM of
		gen_fsm ->
		    LastExpr1= tuple_to_record_in_gen_fsm(
			       LastExpr, RecordName, RecordFields, IsTuple, Msg, Pos,
				TupleToRecordFunName, RecordToTupleFunName),
		    lists:reverse([LastExpr1| Exprs]);		
		_ -> 
		    LastExpr1= tuple_to_record_expr(LastExpr, RecordName, RecordFields),
		    lists:reverse([LastExpr1| Exprs])
	    end;
	variable  ->
	    As = refac_syntax:get_ann(LastExpr),
	    case lists:keysearch(def, 1, As) of
		{value, {def, DefinePos}} ->
		    case is_used_only_once(refac_syntax:block_expr(Body), DefinePos) of
			true ->
			    {Body1, Modified} =
				do_state_to_record_in_match_expr(
				  refac_syntax:block_expr(Body), LastExpr, DefinePos, RecordName, RecordFields, IsTuple, 
				  SM, TupleToRecordFunName, RecordToTupleFunName),
			    case Modified of
				true ->
				    refac_syntax:block_expr_body(Body1);
				false ->
				    fail_or_tuple_to_record_app(Body, RecordName, RecordFields, IsTuple, SM,
							       TupleToRecordFunName, RecordToTupleFunName)
			    end;
			false ->
			    fail_or_tuple_to_record_app(Body, RecordName, RecordFields, IsTuple, SM,
						       TupleToRecordFunName, RecordToTupleFunName)
		    end;
		_ ->
		    fail_or_tuple_to_record_app(Body, RecordName, RecordFields, IsTuple, SM,
					       TupleToRecordFunName, RecordToTupleFunName) 
	    end;
	case_expr ->
	    Args = refac_syntax:case_expr_argument(LastExpr),
	    Cs = refac_syntax:case_expr_clauses(LastExpr),
	    Cs1 = [do_state_to_record_in_init_fun_clause(C, RecordName, RecordFields, IsTuple, SM,
							TupleToRecordFunName, RecordToTupleFunName) || C <- Cs],
	    LastExpr1 = refac_util:rewrite(LastExpr, refac_syntax:case_expr(Args, Cs1)),
	    lists:reverse([LastExpr1| Exprs]);
	if_expr ->
	    Cs = refac_syntax:if_expr_clauses(LastExpr),
	    Cs1 = [do_state_to_record_in_init_fun_clause(C, RecordName, RecordFields, IsTuple, SM,
							TupleToRecordFunName, RecordToTupleFunName) || C <- Cs],
	    LastExpr1 = refac_util:rewrite(LastExpr, refac_syntax:if_expr(Cs1)),
	    lists:reverse([LastExpr1| Exprs]);
	cond_expr ->
	    Cs = refac_syntax:cond_expr_clauses(LastExpr),
	    Cs1 = [do_state_to_record_in_init_fun_clause(C, RecordName, RecordFields, IsTuple, SM,
							 TupleToRecordFunName, RecordToTupleFunName) || C <- Cs],
	    LastExpr1 = refac_util:rewrite(LastExpr, refac_syntax:cond_expr(Cs1)),
	    lists:reverse([LastExpr1| Exprs]);
	block_expr ->
	    B = refac_syntax:block_expr_body(LastExpr),
	    B1 = do_state_to_record_in_init_fun_clause_body(B, RecordName, RecordFields, DefPs, IsTuple, SM,
							   TupleToRecordFunName, RecordToTupleFunName),
	    LastExpr1 = refac_util:rewrite(LastExpr, refac_syntax:block_expr(B1)),
	    lists:reverse([LastExpr1| Exprs]);
	receive_expr ->
	    Cs = refac_syntax:receive_expr_clauses(LastExpr),
	    T = refac_syntax:receive_expr_timeout(LastExpr),
	    A = refac_syntax:receive_expr_action(LastExpr),
	    Cs1 = [do_state_to_record_in_init_fun_clause(C, RecordName, RecordFields, IsTuple, SM,
							TupleToRecordFunName, RecordToTupleFunName) || C <- Cs],
	    LastExpr1 = refac_util:rewrite(LastExpr, refac_syntax:receive_expr(Cs1, T, A)),
	    lists:reverse([LastExpr1| Exprs]);
	atom when SM ==gen_fsm ->
	    Body;
	_ when IsTuple ->
	    fail_or_tuple_to_record_app(Body, RecordName, RecordFields, IsTuple, SM, 
					TupleToRecordFunName, RecordToTupleFunName);
	_ when SM==gen_fsm ->
	     throw({error, Msg ++ io_lib:format("~p", [Pos])});
	_ ->
	    Fields = [mk_record_field(hd(RecordFields), LastExpr)],
	    LastExpr1 = refac_util:rewrite(LastExpr, mk_record_expr(RecordName, Fields)),
	    lists:reverse([LastExpr1| Exprs])
    end.

fail_or_tuple_to_record_app(Body, RecordName, RecordFields, IsTuple, SM, 
			    TupleToRecordFunName, RecordToTupleFunName) ->
    Msg = "Wrangler did not know how to transform the expression at location: ",
    [LastExpr| Exprs] = lists:reverse(Body),
    Pos = refac_syntax:get_pos(LastExpr),
    case SM of 
	gen_fsm ->
	    throw({error, Msg ++ io_lib:format("~p", [Pos])});
	_ ->
	    LastExpr1 = make_tuple_to_record_app(LastExpr, RecordName, RecordFields, IsTuple,
						TupleToRecordFunName, RecordToTupleFunName),
	    lists:reverse([LastExpr1| Exprs])
    end.
	    
do_state_to_record_in_match_expr(Body, _LastExpr, DefinePos, RecordName, RecordFields, _IsTuple, SM,
				_TupleToRecordFunName, RecordToTupleFunName)
    when SM == eqc_statem orelse SM == eqc_fsm ->
    Fun = fun (Node, _Others) ->
		  case refac_syntax:type(Node) of
		    match_expr ->
			P = refac_syntax:match_expr_pattern(Node),
			B = refac_syntax:match_expr_body(Node),
			case refac_syntax:type(P) of
			  variable ->
			      Pos = refac_syntax:get_pos(P),
			      case lists:member(Pos, DefinePos) of
				true ->
				    case refac_syntax:type(B) of
					tuple ->
					    B1 = tuple_to_record_expr(B, RecordName, RecordFields),
					    Node1 = refac_syntax:match_expr(P, refac_util:rewrite(B, B1)),
					    {refac_util:rewrite(Node, Node1), true};
					application ->
					    case is_app(B, {RecordToTupleFunName, 1}) of
						true ->
						    [T] = refac_syntax:application_arguments(B),
						    {T, true};
						false ->
						    {Node, false}
					    end;
				      _ ->
					  {Node, false}
				    end;
				false ->
				    {Node, false}
			      end;
			  _ -> {Node, false}
			end;
		    _ -> {Node, false}
		  end
	  end,
    refac_util:stop_tdTP(Fun, Body, {});

do_state_to_record_in_match_expr(Body, LastExpr, DefinePos, RecordName, RecordFields, IsTuple, SM,
				TupleToRecordFunName, RecordToTupleFunName)
    when SM == gen_fsm ->
    Msg = "Wrangler did not know how to transform the expression at location: ",
    Pos = refac_syntax:get_pos(LastExpr),
    Fun1 = fun (B) ->
		   case refac_syntax:type(B) of
		       tuple -> {tuple_to_record_in_gen_fsm(B,RecordName, RecordFields, 
							    IsTuple, Msg, Pos, TupleToRecordFunName, 
							    RecordToTupleFunName), true};
		       variable ->
			   {B, false};
		       _ ->
			   throw({error, Msg ++ io_lib:format("~p", [Pos])})
		   end
	   end,
    Fun = fun (Node, _Others) ->
		  case refac_syntax:type(Node) of
		    match_expr ->
			P = refac_syntax:match_expr_pattern(Node),
			B = refac_syntax:match_expr_body(Node),
			case refac_syntax:type(P) of
			  variable ->
			      Pos1 = refac_syntax:get_pos(P),
			      case lists:member(Pos1, DefinePos) of
				  true ->
				      {B1, Modified} = Fun1(B),
				      case Modified of
					  true ->
					      Node1 = refac_syntax:match_expr(P, B1),
					      {refac_util:rewrite(Node, Node1), true};
					  false ->
					      {Node, false}
				      end;
				  false ->
				    {Node, false}
			      end;
			  _ -> {Node, false}
			end;
		    _ -> {Node, false}
		  end
	  end,
    refac_util:stop_tdTP(Fun, Body, {}).

tuple_to_record_in_gen_fsm(Tuple, RecordName, RecordFields, IsTuple, Msg, Pos,
			   TupleToRecordFunName, RecordToTupleFunName) ->
    Es = refac_syntax:tuple_elements(Tuple),
    Size = length(Es),
    case Size =< 2 of
	true -> Tuple;
	false ->
	    Tag = hd(Es),
	    case refac_syntax:type(Tag) of
		atom ->
		    case refac_syntax:atom_value(Tag) of
			ok ->
			    gen_fsm_state_to_record(RecordName, RecordFields, Tuple, 3, IsTuple, 
						   TupleToRecordFunName, RecordToTupleFunName);
			next_state ->
			    gen_fsm_state_to_record(RecordName, RecordFields, Tuple, 3, IsTuple,
						   TupleToRecordFunName, RecordToTupleFunName);
			reply ->
			    gen_fsm_state_to_record(RecordName, RecordFields, Tuple, 4, IsTuple,
						   TupleToRecordFunName, RecordToTupleFunName);
			stop ->
			    gen_fsm_state_to_record(RecordName, RecordFields, Tuple, Size, IsTuple,
						   TupleToRecordFunName, RecordToTupleFunName);
			_ ->
			    throw({error, Msg ++ io_lib:format("~p", [Pos])})
		    end;
		_ -> throw({error, Msg ++ io_lib:format("~p", [Pos])})
	    end
    end.

gen_fsm_state_to_record(RecordName, RecordFields, B, Nth, IsTuple, 
			TupleToRecordFunName, RecordToTupleFunName) ->
    Es = list_to_tuple(refac_syntax:tuple_elements(B)),
    State = element(Nth, Es),
    case refac_syntax:type(State) of
	tuple when IsTuple ->
	    State1 =tuple_to_record_expr(State, RecordName, RecordFields),
	    Es1=tuple_to_list(setelement(Nth, Es, State1)),
	    refac_util:rewrite(B, refac_syntax:tuple(Es1));	    
	_ -> 
	    State1 = make_tuple_to_record_app(State, RecordName, RecordFields, IsTuple, 
					     TupleToRecordFunName, RecordToTupleFunName),
	    Es1= tuple_to_list(setelement(Nth, Es, State1)),
	    refac_util:rewrite(B, refac_syntax:tuple(Es1))
    end.



wrap_fun_interface(Form, ModName, RecordName, RecordFields, IsTuple, StateFuns,SM,
		  TupleToRecordFunName, RecordToTupleFunName) ->
    Form1 = wrap_fun_interface_in_arg(Form, ModName, RecordName, RecordFields, IsTuple, StateFuns,SM,
				     TupleToRecordFunName, RecordToTupleFunName),
    wrap_fun_interface_in_return(Form1, ModName, RecordName, RecordFields, IsTuple, StateFuns, SM,
				TupleToRecordFunName, RecordToTupleFunName).

wrap_fun_interface_in_return(Form, ModName, RecordName, RecordFields,IsTuple, StateFuns, SM,
			    TupleToRecordFunName, RecordToTupleFunName) ->
    Fun= fun(Node, _Others) ->
		 case is_callback_fun_app(Node, ModName, StateFuns, SM) of
		     {true, _PatIndex, true} ->
			 case SM of 
			     gen_fsm ->
				 throw({error, "Callback functions are called as normal functions."});
			     _ ->
				 make_record_to_tuple_app(Node, RecordName, RecordFields, IsTuple,
							 TupleToRecordFunName, RecordToTupleFunName)
			 end;
		     false ->
			 Node
		 end
	 end,
    refac_util:full_buTP(Fun, Form, {}).
    

wrap_fun_interface_in_arg(Form, ModName, RecordName, RecordFields, IsTuple, StateFuns, SM,
			 TupleToRecordFunName, RecordToTupleFunName) ->
    Fun= fun(Node, _Others) ->
		 case is_callback_fun_app(Node, ModName, StateFuns,SM) of
     		      {true, PatIndex, _} ->
     		  	 do_transform_actual_pars(Node, PatIndex, RecordName, RecordFields, IsTuple,
						 TupleToRecordFunName, RecordToTupleFunName);
     		      false ->
     		  	 Node
    		 end	
     	 end,
    refac_util:full_buTP(Fun, Form, {}).

do_transform_actual_pars(Node, PatIndexes, RecordName, RecordFields, IsTuple,
			 TupleToRecordFunName, RecordToTupleFunName) ->
    Op = refac_syntax:application_operator(Node),
    Args = refac_syntax:application_arguments(Node),
    NewArgs = [do_transform_actual_pars_1({A, Index}, PatIndexes, RecordName, RecordFields, IsTuple,
					 TupleToRecordFunName, RecordToTupleFunName)
	       ||{A, Index} <- lists:zip(Args, lists:seq(1, length(Args)))],
    Node1 = refac_syntax:application(Op, NewArgs),
    refac_util:rewrite(Node, Node1).

do_transform_actual_pars_1({Arg, Index}, PatIndexes, RecordName, RecordFields, IsTuple,
			  TupleToRecordFunName, RecordToTupleFunName) ->
    case lists:member(Index, PatIndexes) of
	true ->
	    case refac_syntax:type(Arg) of
		tuple when IsTuple->
		    tuple_to_record_expr(Arg, RecordName, RecordFields);
		_ ->
		    make_tuple_to_record_app(Arg, RecordName, RecordFields, IsTuple, 
					     TupleToRecordFunName, RecordToTupleFunName)
	    end;
	false ->
	    Arg		    
    end.
	
	    

is_callback_fun_app(Node, ModName, StateFuns, SM) ->
    case refac_syntax:type(Node) of
	application ->
	    Op = refac_syntax:application_operator(Node),
	    case refac_syntax:type(Op) of 
		atom ->
		    FunName = refac_syntax:atom_value(Op),
		    Args = refac_syntax:application_arguments(Node),
		    Arity = length(Args),
		    CallBacks = callbacks(ModName,StateFuns, SM),
		    case lists:keysearch({ModName, FunName, Arity},1, CallBacks) of
			{value, {{ModName, FunName, Arity}, {PatIndex, ReturnState}}} ->
			    {true, PatIndex, ReturnState};
			false ->
			    false
		    end;
		_ -> false
	    end;
	_ -> false
    end.

record_to_tuple_fun_name(ModInfo, RecordName) ->
    FunName = list_to_atom(atom_to_list(RecordName) ++ "_to_tuple"),
    {value, {module, ModName}} = lists:keysearch(module, 1, ModInfo),
    InscopeFuns = refac_util:inscope_funs(ModInfo),
    gen_fun_name(ModName, FunName, InscopeFuns, 0).

tuple_to_record_fun_name(ModInfo, RecordName) ->
    FunName = list_to_atom("tuple_to_" ++ atom_to_list(RecordName)),
    {value, {module, ModName}} = lists:keysearch(module, 1, ModInfo),
    InscopeFuns = refac_util:inscope_funs(ModInfo),
    gen_fun_name(ModName, FunName, InscopeFuns, 0).


gen_fun_name(ModName, FunName, InscopeFuns, I) ->
    NewFunName = case I of 
		     0 -> FunName;
		     _ -> 
			 list_to_atom(atom_to_list(FunName)++"_"++integer_to_list(I))			  
		 end,
    case lists:member({ModName, NewFunName, 1}, InscopeFuns) of 
	true ->
	    gen_fun_name(ModName, FunName, InscopeFuns, I+1);
	 false ->
	     NewFunName
     end.
    

add_util_funs(Forms, RecordName, RecordFields, TupleToRecordFunName, RecordToTupleFunName) ->
    Fun = fun (Node, Acc) ->
		  case refac_syntax:type(Node) of
		    application ->
			case is_app(Node, {RecordToTupleFunName, 1}) of
			  true ->
			      [{RecordToTupleFunName, 1}| Acc];
			  false ->
			      case is_app(Node, {TupleToRecordFunName, 1}) of
				true ->
				    [{TupleToRecordFunName, 1}| Acc];
				false ->
				    Acc
			      end
			end;
		    _ -> Acc
		  end
	  end,
    Acc = lists:append([refac_syntax_lib:fold(Fun, [], F) || F <- Forms]),
    case lists:member({RecordToTupleFunName, 1}, Acc) of
      true ->
	  F1 = mk_record_to_tuple_fun(RecordName, RecordFields,RecordToTupleFunName),
	  case lists:member({TupleToRecordFunName, 1}, Acc) of
	    true ->
		F2 = mk_tuple_to_record_fun(RecordName, RecordFields,TupleToRecordFunName),
		Forms ++ [F1, F2];
	    false ->
		Forms ++ [F1]
	  end;
      false ->
	  case lists:member({TupleToRecordFunName, 1}, Acc) of
	    true ->
		F2 = mk_tuple_to_record_fun(RecordName, RecordFields, TupleToRecordFunName),
		Forms ++ [F2];
	    false ->
		Forms
	  end
    end.
%% ======================================================================

is_statemachine_used(ModuleInfo, gen_fsm) ->
    CallBacks = [{init, 1}],
    case lists:keysearch(attributes, 1, ModuleInfo) of 
	{value, {attributes, Attrs}} ->
	    lists:member({behaviour, gen_fsm}, Attrs);
	false ->
	    case lists:keysearch(functions, 1, ModuleInfo) of
		{value, {functions, Funs}} ->
		    CallBacks -- Funs == [];
		false ->
		    {error, "gen_fsm callback function init/1 is not defined."}
	    end
    end;

is_statemachine_used(ModuleInfo, eqc_statem) ->
    CallBacks = [{initial_state, 0}, {precondition, 2}, {command, 1},
		 {postcondition, 3}, {next_state, 3}],
    is_statemachine_used_1(ModuleInfo, CallBacks, eqc_statem);
   

is_statemachine_used(ModuleInfo, eqc_fsm) ->
    CallBacks = [{initial_state_data, 0}, {next_state_data, 5}, 
		 {precondition, 4}, {postcondition, 5}],
    is_statemachine_used_1(ModuleInfo, CallBacks, eqc_fsm).


is_statemachine_used_1(ModuleInfo, CallBacks, SM) ->
    Msg = atom_to_list(SM)++".hrl is not imported by this module.",
    case lists:keysearch(imports, 1, ModuleInfo) of
	{value, {imports, Imps}} ->
	    Ms = [M || {M, _} <- Imps],
	    case lists:member(SM, Ms) of 
		true ->
		    case lists:keysearch(functions, 1, ModuleInfo) of
			{value, {functions, Funs}} ->
			    case CallBacks -- Funs of
				[] -> 
				    true;
				Fs -> 
				    case length(Fs) of
					1 ->
					    {error, atom_to_list(SM)++" callback function, " 
					     ++  format_funs(Fs) ++ ", is not defined."};
					_ ->
					    {error, atom_to_list(SM)++" callback functions: "
					     ++ format_funs(Fs)++ ", are not defined."}
				    end
			    end;
			false ->
			    {error, "none of the "++atom_to_list(SM)++" callback functions is defined."}
		    end;
		false ->
		    {error, Msg}
	    end;
	false ->
	    {error, Msg}
    end.

format_funs([]) ->
     "";
format_funs([{F,A}|T]) ->
    atom_to_list(F)++"/"++integer_to_list(A) ++
   	case T of 
	    [] -> format_funs(T);
	    [_T1] -> " and "++ format_funs(T);
	    _ -> ","++format_funs(T)
	end.
		   

%%=====================================================================


check_current_state_type(File, ModName, ModInfo, SM) ->
    TypeInfo = try refac_type_info:get_type_info_using_typer(File) of
		   V -> V
	       catch
		   _E1:E2 ->
		       throw(E2)
	       end,
    ?debug("TypeInfo:\n~p\n", [TypeInfo]),
    TypeInfo1 =[{F, Type} || {F, Type} <-TypeInfo, F == File],
    Type = case TypeInfo1 of
	       [] ->
		   throw({error, ?Msg});
	       [{File, T}] ->
		   T
	   end,
    {Ts, StateFuns} =get_current_state_type_1(Type, ModName, ModInfo, SM),
    ?debug("Current Type:\n~p\n", [Ts]),
    Ts1 = lists:usort([case Tag of 
			   tuple -> {Tag, length(Es)};   %% Question: what is the different between tuple and tuple_set?
			   tuple_set ->{tuple, length(Es)};
			   _ -> Tag
		       end 
		       ||{c,Tag, Es, _} <-lists:usort(Ts) --[any],
			is_list(Es)]),
    case Ts1 of
	[record] ->
	    throw({error, "The state of the state machine is already a record."});
	[{tuple, A}|Tail] ->
	    case Tail of 
		[] ->
		    {ok,{tuple, A}, StateFuns};
		_ ->
		    throw({error, ?Msg})
	    end;
	_ ->
	    {ok, non_tuple, StateFuns}
    end.
    
 
get_current_state_type_1(TypeInfo, ModName, _ModInfo, eqc_statem) ->    %% 0 in the [0] means the return type.
    Pars = [{{ModName, initial_state, 0}, [0]}, {{ModName, precondition, 2}, [1]},
	    {{ModName, command, 1}, [1]}, {{ModName, postcondition, 3}, [1]},
	    {{ModName, next_state, 3}, [0, 1]}],    
    get_current_state_type_2(TypeInfo, [], Pars);

get_current_state_type_1(TypeInfo, ModName, _ModInfo, eqc_fsm) ->
    Pars0 = [{{ModName, initial_state_data, 0}, [0]}, {{ModName, next_state_data, 5}, [0, 3]},
	     {{ModName, postcondition, 5}, [3]}, {{ModName, precondition, 4}, [3]}],
    StateFuns = get_eqc_fsm_state_functions(ModName, TypeInfo),
    Pars1 = [{{M, F, A}, [1]} || {M, F, A} <- StateFuns],
    Pars = Pars0 ++ Pars1,
    get_current_state_type_2(TypeInfo, StateFuns, Pars);

get_current_state_type_1(TypeInfo, ModName, ModInfo, gen_fsm) ->
    Pars0 = [{{ModName, init, 1}, {[], true}},
	     {{ModName, handle_event, 3}, {[3], true}},
	     {{ModName, handle_sync_event, 4}, {[4], true}},
	     {{ModName, handle_info, 3}, {[3], true}},
	     {{ModName, terminate, 3}, {[3], false}},
	     {{ModName, code_change, 4}, {[3], true}},
	     {{ModName, enter_loop, 4}, {[4], false}},
	     {{ModName, enter_loop, 5}, {[4], false}},
	     {{ModName, enter_loop, 6}, {[4], false}}],
    StateFuns = get_gen_fsm_state_functions(ModName, ModInfo, TypeInfo),
    Pars1 = [{{M, F, A}, {[A], true}} || {M, F, A} <- StateFuns],
    Pars = Pars0 ++ Pars1,
    ?debug("Pars:\n~p\n", [Pars]),
    Fun = fun ({{M, F, A}, RetType, ArgTypes}) ->
		  case lists:keysearch({M, F, A}, 1, Pars) of
		    {value, {{M, F, A}, {Is, _ReturnState}}} ->
			get_gen_fsm_return_types(RetType) ++ 
			      [lists:nth(I, ArgTypes) || I <- Is];
		    false ->
			[]
		  end
	  end,
    {lists:append([Fun(T) || T <- TypeInfo]), StateFuns}.

get_current_state_type_2(TypeInfo, StateFuns, Pars) ->
    Fun = fun ({{M, F, A}, RetType, ArgTypes}) ->
		  case lists:keysearch({M, F, A}, 1, Pars) of
		      {value, {{M, F, A}, Is}} ->
			  [case I of
			       0 -> RetType;
			       _ -> lists:nth(I, ArgTypes)
			   end || I <- Is];
		    false ->
			  []
		  end
	  end,
    {lists:append([Fun(T) || T <- TypeInfo]), StateFuns}.

get_gen_fsm_return_types(RetType) ->
    case RetType of 
	{c, tuple, Es, _} ->
	    case length(Es)>2 of 
		true ->
		    Tag = hd(Es),
		    case Tag of
			{c, atom, [ok], _} ->
			    [lists:nth(3, Es)];
			{c, atom, [next_state], _} ->
			    [lists:nth(3, Es)];
			{c, atom, [reply], _} ->
			    [lists:nth(4, Es)];
			{c, atom, [stop], _} ->
			    [lists:last(Es)];
			_ -> 
			    []
		    end;			
		false ->
		    []
	    end;
	_ -> []
    end.

get_eqc_fsm_state_functions(ModName, TypeInfo) ->
    case lists:keysearch({ModName, initial_state, 0}, 1, TypeInfo) of
      {value, {{ModName, initial_state, 0}, RetType, _ArgsType}} ->
	  case RetType of
	    {c, atom, [StateName], _} ->
		get_eqc_fsm_state_functions_1(ModName, TypeInfo, [StateName]);
	    _ -> throw({error, "Wrangler failed to infer the initial state of the fsm."})
	  end;
      false ->
	  throw({error, "eqc_fsm callback function initial_state/0 is not defined."})
    end.

get_eqc_fsm_state_functions_1(ModName, TypeInfo, StateNames) ->
    StateNames1 = get_eqc_fsm_state_functions_2(TypeInfo, StateNames),
    case StateNames == StateNames1 of
	true ->
	    [{ModName, S, 1} || S <- StateNames, S /= history];
	_ ->
	    get_eqc_fsm_state_functions_1(ModName, TypeInfo,
					  lists:usort(StateNames ++ StateNames1))
    end.

get_eqc_fsm_state_functions_2(TypeInfo, StateNames) ->
    Fun = fun ({{_M, F, A}, RetType, _ArgTypes}) ->
		  case A == 1 andalso lists:member(F, StateNames) of
		      true ->
			  case RetType of
			      {c, list, Es, _} ->
				  case Es of
				      [{c, tuple_set, [{_, Tuples}], _}| _] ->
					  SNames = [[S || {c, atom, S, _} <- [T]] || {c, tuple, [T| _], _} <- Tuples],
					  lists:flatten(SNames);
				      [] ->
					  [];
				      _ ->
					  throw({error, "Wrangler failed to infer the target state of '"
						 ++ atom_to_list(F) ++ "'."})
				  end;
			      _ ->
				  throw({error, "Wrangler failed to infer the target state of '"
					 ++ atom_to_list(F) ++ "'."})
			  end;
		      false ->
			  []
		  end
	  end,
    Res = lists:append([Fun(T) || T <- TypeInfo]),
    lists:usort(Res).

get_gen_fsm_state_functions(ModName, ModInfo, TypeInfo) ->
    case lists:keysearch({ModName, init, 1}, 1, TypeInfo) of 
	{value, {{ModName, init, 1}, RetType, _ArgsType}} ->
	    ?debug("RetType:\n~p\n", [RetType]),
	    case RetType of 
		{c, tuple ,[_, {c, atom, [StateName], _}|_],_} ->
		    get_gen_fsm_state_functions_1(ModName, ModInfo, TypeInfo,[StateName]);
		_ -> throw({error, "Wrangler failed to infer the initial state name of the fsm."})
	    end;
	false ->
	    throw({error, "gen_fsm callback function init/1 is not defined."})
   end.
    
get_gen_fsm_state_functions_1(ModName, ModInfo, TypeInfo, StateNames) ->
    StateNames1 = get_gen_fsm_state_functions_2(TypeInfo, StateNames),
    case StateNames == StateNames1 of 
	true ->
	    StateFuns =lists:append([[{ModName, S, 2}, {ModName, S, 3}] || S <- StateNames]),
	    case lists:keysearch(functions,1, ModInfo) of
		{value, {functions, Funs}} ->
		    [{M, F, A}||{M, F, A}<-StateFuns, lists:member({F, A}, Funs)];
		_ ->
		    []
	    end;
	false ->
	    get_gen_fsm_state_functions_1(ModName, ModInfo, TypeInfo, 
					  lists:usort(StateNames++StateNames1))
    end.

get_gen_fsm_state_functions_2(TypeInfo, StateNames) ->
    Fun = fun ({{_M, F, A}, RetType, _ArgTypes}) ->
		  case lists:member(A, [2, 3]) andalso lists:member(F, StateNames) of
		    true ->
			  ?debug("RetType0:\n~p\n", [RetType]),
			case RetType of
			  {c, tuple, Es, _} ->
				?debug("RetType1:\n~p\n", [RetType]),
			      case Es of
				[{c, atom, [next_state], _},
				 {c, atom, S, _}| _T] ->
				    S;
				_ ->
				      throw({error, "Wrangler failed to infer the next state of '"
						    ++ atom_to_list(F) ++ "'."})
			      end;
			  _ ->
				throw({error, "Wrangler failed to infer the next state of '"
					      ++ atom_to_list(F) ++ "'."})
			end;
		    false ->
			[]
		  end
	  end,
    Res = lists:append([Fun(T) || T <- TypeInfo]),
    lists:usort(Res).


is_tuple_to_is_record(Tree, RecordName,RecordToTupleFunName) ->
    ?debug("\nis_tuple_to_is_record\n",[]),
    Fun = fun(Node, _Others) ->
		  case is_app(Node, {erlang, is_tuple, 1}) of 
		      true ->
			  [Arg] = refac_syntax:application_arguments(Node),
			  case is_app(Arg, {RecordToTupleFunName, 1}) of 
			      true ->
				  [T] = refac_syntax:application_arguments(Arg),
				  refac_syntax:application(refac_syntax:atom(is_record),
							   [T, refac_syntax:atom(RecordName)]);
			      _ -> Node
			  end;
		      _ -> Node
		  end
	  end,
    refac_util:full_buTP(Fun, Tree, {}).


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%    
%%                 Transformation: element to record access                    %%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

element_to_record_access(RecordName, RecordFields, DefPs, Node,RecordToTupleFunName) ->
    [N, T] = refac_syntax:application_arguments(Node),
    case {refac_syntax:type(N), refac_syntax:type(T)} of
	{integer, variable} ->
	    As1 = refac_syntax:get_ann(T),
	    case lists:keysearch(def, 1, As1) of
		{value, {def, DefinePos}} ->
		    case DefinePos -- DefPs =/= DefinePos of
			true -> 
			    element_to_record_access_1(T, N, RecordName, RecordFields);
			false ->
			    Node
		    end;
		false ->
		    Node
	    end;
	{integer, application} ->
	    case is_app(T, {RecordToTupleFunName, 1}) of
		true ->
		    [Arg] = refac_syntax:application_arguments(T),		
		    element_to_record_access_1(Arg, N, RecordName, RecordFields);
		false ->
		    Node
	    end;
	_ -> Node
    end.

element_to_record_access_1(Tuple, Nth, RecordName, RecordFields) ->
    FieldName = lists:nth(refac_syntax:integer_value(Nth), RecordFields),
    RecordName1 = refac_syntax:atom(RecordName),
    FieldName1 = refac_syntax:atom(FieldName),
    refac_syntax:record_access(Tuple, RecordName1, FieldName1).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%    
%%                 Transformation: setelement to record expression             %%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

setelement_to_record_expr(Node, RecordName, RecordFields, DefPs, IsTuple,
			 TupleToRecordFunName, RecordToTupleFunName) ->
    [Index, T, V] = refac_syntax:application_arguments(Node),
    case {refac_syntax:type(Index), refac_syntax:type(T)} of
      {integer, variable} ->
	  As1 = refac_syntax:get_ann(T),
	  case lists:keysearch(def, 1, As1) of
	    {value, {def, DefinePos}} ->
		case DefinePos -- DefPs =/= DefinePos of
		  true ->
		      setelement_to_record_expr_1(T, Index, V, RecordName, RecordFields, IsTuple,
						 TupleToRecordFunName, RecordToTupleFunName);
		  false ->
		      Node
		end;
	    false -> Node
	  end;
      {integer, application} ->
	  case is_app(T, {RecordToTupleFunName, 1}) of
	    true ->
		[Arg] = refac_syntax:application_arguments(T),		
		setelement_to_record_expr_1(Arg, Index, V, RecordName, RecordFields, IsTuple,
					   TupleToRecordFunName, RecordToTupleFunName);
	    false ->
		Node
	  end;
      _ -> Node
    end.

setelement_to_record_expr_1(Expr, Index, Val, RecordName, RecordFields, IsTuple, 
			   TupleToRecordFunName, RecordToTupleFunName) ->
    FieldName = lists:nth(refac_syntax:integer_value(Index), RecordFields),
    Field = mk_record_field(FieldName, Val),
    RecordExpr = mk_record_expr(Expr, RecordName, [Field]),
    make_record_to_tuple_app(RecordExpr, RecordName, RecordFields, IsTuple, 
			     TupleToRecordFunName, RecordToTupleFunName).



remove_record_tuple_conversions(Tree, TupleToRecordFunName, RecordToTupleFunName) ->
    Fun = fun(Node, Acc) ->
		  case refac_syntax:type(Node) of
		      match_expr ->
			  P = refac_syntax:match_expr_pattern(Node),
			  B = refac_syntax:match_expr_body(Node),
			  case {refac_syntax:type(P), refac_syntax:type(B)} of
			      {variable, application} ->
				  Pos = refac_syntax:get_pos(P),
				  case is_app(B, {RecordToTupleFunName,1}) of 
				      true ->
					  case check_sole_use_of_var(Tree, Pos, TupleToRecordFunName) of
					      true ->
						  [{Pos, TupleToRecordFunName}|Acc];
					      false ->
						  Acc
					  end;
				      false ->
					  case is_app(B, {TupleToRecordFunName, 1}) of
					      true ->
						  case check_sole_use_of_var(Tree, Pos, RecordToTupleFunName) of
						      true ->
							  [{Pos, RecordToTupleFunName}|Acc];
						      false ->
							  Acc
						  end;
					      false ->
						  Acc
					  end
				  end;
			      _ -> Acc
			  end;
		      _ -> Acc
		  end
	  end,
    Fun1 = fun(Node, {Pos, FunName}) ->
		   case refac_syntax:type(Node) of
		       application ->
			   case is_app(Node, {FunName, 1}) of
			       true ->
				   [T] = refac_syntax:application_arguments(Node),
				   case refac_syntax:type(T) of
				       variable ->
					    As1 = refac_syntax:get_ann(T),
					   case lists:keysearch(def, 1, As1) of
					       {value, {def, [Pos]}} ->
						   T;
					       false ->
						   Node
					   end;
				       _ -> Node
				   end;
			       false -> Node
			   end;
		       match_expr ->
			   P = refac_syntax:match_expr_pattern(Node),
			   B = refac_syntax:match_expr_body(Node),
			   case {refac_syntax:type(P), refac_syntax:type(B)} of
			       {variable, application} ->
				   case refac_syntax:get_pos(P) of
				       Pos ->
					   [T] =refac_syntax:application_arguments(B),
					   refac_util:rewrite(Node, refac_syntax:match_expr(P,T));
				       _ -> Node
				   end;
			       _ -> Node
			   end;
		       _ -> Node
		       end
	   end,
    Vs = refac_syntax_lib:fold(Fun, [], Tree),
    Fun2 = fun(V, Node) ->  refac_util:full_buTP(Fun1,Node, V) end,
    lists:foldl(Fun2, Tree, Vs).
    
	
check_sole_use_of_var(Tree, Pos, FunName) ->    
     Fun = fun(Node, {Acc1, Acc2}) ->
		   case refac_syntax:type(Node) of
		       variable ->
			   case refac_syntax:get_pos(Node) of
			       Pos -> {Acc1, Acc2};
			       _ ->
				   As = refac_syntax:get_ann(Node),
				   case lists:keysearch(def, 1, As) of
				       {value, {def, [Pos]}} ->
					   {[refac_syntax:get_pos(Node)|Acc1], Acc2};
				       _ ->
					   {Acc1, Acc2}
				   end
			   end;
		       application ->
			   case is_app(Node, {FunName, 1}) of
			       true ->
				   [T] = refac_syntax:application_arguments(Node),
				   case refac_syntax:type(T) of
				       variable ->
					   As1 = refac_syntax:get_ann(T),
					   case lists:keysearch(def, 1, As1) of
					       {value, {def, [Pos]}} ->
						   {Acc1, [refac_syntax:get_pos(T)|Acc2]};
					       _ ->
						   {Acc1, Acc2}
					   end;
				       _ ->
					   {Acc1, Acc2}
				   end;
			       false ->  
				   {Acc1, Acc2}
			   end;
		       _ ->
			   {Acc1, Acc2}
		   end
	   end,
    {Acc1, Acc2} = refac_syntax_lib:fold(Fun, {[],[]}, Tree),
    ?debug("Acc1Acc2:\n~p\n", [{Acc1, Acc2}]),
    Acc1 == Acc2.

%%====================================================================================
%%
%% Some utility functions 
%%
%%====================================================================================



callbacks(ModName, _StateFuns, eqc_statem) ->
    [{{ModName, initial_state, 0}, {[], true}},
     {{ModName, precondition, 2}, {[1], false}},
     {{ModName, command, 1}, {[1], false}},
     {{ModName, postcondition, 3}, {[1], false}},
     {{ModName, next_state, 3}, {[1], false}}];

callbacks(ModName, StateFuns, eqc_fsm) ->
    CallBacks0 = [{{ModName, initial_state_data, 0}, {[], true}},
		  {{ModName, next_state_data, 5}, {[3], true}},
		  {{ModName, precondition, 4}, {[3], false}},
		  {{ModName, postcondition, 5}, {[3], false}}],
    StateFunCallBacks = [{{M, F, A}, {[A], false}} 
			 || {M, F, A} <- StateFuns],
    CallBacks0 ++ StateFunCallBacks;

callbacks(ModName, StateFuns, gen_fsm) ->
    CallBacks0 = [{{ModName, init, 1}, {[], true}},
		  {{ModName, handle_event, 3}, {[3], true}},
		  {{ModName, handle_sync_event, 4}, {[4], true}},
		  {{ModName, handle_info, 3}, {[3], true}},
		  {{ModName, terminate, 3}, {[3], false}},
		  {{ModName, code_change,4}, {[3], true}},
		  {{ModName, enter_loop, 4}, {[4], false}},
		  {{ModName, enter_loop, 5}, {[4], false}},
		  {{ModName, enter_loop, 6}, {[4], false}}],		  
    StateFunCallBacks = [{{M, F, A}, {[A], true}}
			 || {M, F, A} <- StateFuns],
    CallBacks0 ++ StateFunCallBacks.
	

mk_tuple_to_record_fun(RecordName, RecordFields, FunName) ->
    Pars = [refac_syntax:variable("E" ++ integer_to_list(I))
	    || I <- lists:seq(1, length(RecordFields))],
    Fields = mk_record_fields(RecordFields, Pars),
    RecordExpr = mk_record_expr(RecordName, Fields),
    C = refac_syntax:clause([refac_syntax:tuple(Pars)], none, [RecordExpr]),
    refac_syntax:function(refac_syntax:atom(FunName), [C]).

mk_record_to_tuple_fun(RecordName, RecordFields, FunName) ->
    Pars = [refac_syntax:variable("E" ++ integer_to_list(I))
	    || I <- lists:seq(1, length(RecordFields))],
    Fields = mk_record_fields(RecordFields, Pars),
    RecordExpr = mk_record_expr(RecordName, Fields),
    C = refac_syntax:clause([RecordExpr], none, [refac_syntax:tuple(Pars)]),
    refac_syntax:function(refac_syntax:atom(FunName), [C]).

make_tuple_to_record_app(Expr, RecordName, RecordFields, IsTuple, TupleToRecordFunName, RecordToTupleFunName) ->
    case IsTuple of
      false ->
	  Field = mk_record_field(hd(RecordFields), Expr),
	  mk_record_expr(RecordName, [Field]);
      true ->
	    NewExpr = refac_util:rewrite(
		      Expr, refac_syntax:application(
			      refac_syntax:atom(TupleToRecordFunName), [Expr])),
	  case is_app(Expr, {RecordToTupleFunName, 1}) of
	    true ->
		hd(refac_syntax:application_arguments(Expr));
	    false ->
		NewExpr
	  end
    end.
 
   	    
make_record_to_tuple_app(Expr, RecordName, RecordFields, IsTuple, TupleToRecordFunName, RecordToTupleFunName) ->
    case IsTuple of 
	false ->
	    refac_syntax:record_access(Expr, refac_syntax:atom(RecordName),
				       refac_syntax:atom(hd(RecordFields)));
	true ->
	    NewExpr = refac_util:rewrite(Expr,
					 refac_syntax:application(
					   refac_syntax:atom(RecordToTupleFunName), [Expr])),
	    case is_app(Expr, {TupleToRecordFunName, 1}) of
		true ->
	    hd(refac_syntax:application_arguments(Expr));
		false ->
		    NewExpr
	    
	    end
    end.


mk_record_field(Name, Val) ->
    refac_syntax:record_field(refac_syntax:copy_pos(Val, refac_syntax:atom(Name)),
			      refac_syntax:remove_comments(Val)).

mk_record_fields(RecordFields, Es) ->
    [mk_record_field(Name, Val)|| {Name, Val} <- lists:zip(RecordFields, Es),
				  refac_syntax:type(Val) =/= underscore].

mk_record_expr(RecordName, Fields) ->
    refac_syntax:record_expr(refac_syntax:atom(RecordName), Fields).

mk_record_expr(T, RecordName,Fields) ->
    refac_syntax:record_expr(T, refac_syntax:atom(RecordName),Fields).


mk_record_attribute(RecordName, RecordFields) ->
    RecordName1 = refac_syntax:atom(RecordName),
    RecordFields1 = [refac_syntax:record_field(refac_syntax:atom(FieldName))
		     || FieldName <- RecordFields],
    refac_syntax:attribute(refac_syntax:atom(record),
	  [RecordName1, refac_syntax:tuple(RecordFields1)]).

insert_record_attribute(Forms, RecordDef) ->
    {Fs1, Fs2} = lists:splitwith(
		   fun (F) ->
			   refac_syntax:type(F) == comment 
			       orelse is_not_type_attrubute(F)
		   end,
		   Forms),
    {Fs11, Fs12} = lists:splitwith(
		     fun (F) -> 
			     refac_syntax:type(F) == comment 
		     end,
		     lists:reverse(Fs1)),
    lists:reverse(Fs12) ++ [RecordDef] ++ lists:reverse(Fs11) ++ Fs2.



tuple_to_record_expr(Tuple, RecordName, RecordFields) ->
    Es = refac_syntax:tuple_elements(Tuple),
    Fields = mk_record_fields(RecordFields, Es),
    refac_util:rewrite(Tuple, mk_record_expr(RecordName, Fields)).
    
is_app(Expr, {F, A}) ->
    case refac_syntax:type(Expr) of
	application ->
	    Op = refac_syntax:application_operator(Expr),
	    case refac_syntax:type(Op) of
		atom->
		    Args = refac_syntax:application_arguments(Expr),
		    {F, A} =={refac_syntax:atom_value(Op),length(Args)};
		_ -> false
	    end;
	_ -> false
    end;
is_app(Expr, {M,F,A}) ->
    case refac_syntax:type(Expr) of
	application ->
	    As = refac_syntax:get_ann(refac_syntax:application_operator(Expr)),
	    case lists:keysearch(fun_def,1,As) of
		{value, {fun_def, {M, F, A, _ ,_}}}->
		    true;
		_ ->
		    false
	    end;
	_ -> false
    end.
    
is_not_type_attrubute(F) ->
    case refac_syntax:type(F) of
      attribute ->
	  Name = refac_syntax:attribute_name(F),
	  case refac_syntax:type(Name) of
	    atom ->
		not lists:member(refac_syntax:atom_value(Name),
				 ['type', 'spec']);
	    _ ->
		false
	  end;
      _ -> false
    end.
		
is_used_only_once(Body, DefinePos) ->
    Fun= fun(Node, Acc) ->
	     case refac_syntax:type(Node) of 
		 variable ->
		     As = refac_syntax:get_ann(Node),
		     case lists:keysearch(def, 1, As) of 
			 {value, {def, DefinePos}} ->
			     Pos = refac_syntax:get_pos(Node),
			     case lists:member(Pos, DefinePos) of
				 true ->
				    Acc; 
				 false ->
				     [Node|Acc]
			     end;
			 _->
			     Acc
		     end;
		 _ -> Acc
	     end
	 end,
    length(refac_syntax_lib:fold(Fun, [], Body))==1.

format_state_funs([]) -> "[]";
format_state_funs(MFAs) ->
     "[" ++ format_state_funs_1(MFAs).

format_state_funs_1([]) ->
    "";
format_state_funs_1([{M,F,A}|T]) ->
    case T of 
	[] ->
	   io_lib:format("~p]", [{M, F, A}])++
		format_state_funs_1(T);
	_ ->
	    io_lib:format("~p,", [{M, F, A}])++
		format_state_funs_1(T)
    end.
    
format_field_names([]) -> "[]";
format_field_names(MFAs) ->
     "[" ++ format_field_names_1(MFAs).

format_field_names_1([]) ->
    "";
format_field_names_1([F|T]) ->
    case T of 
	[] ->
	   io_lib:format("~p]", [F])++
		format_field_names_1(T);
	_ ->
	    io_lib:format("~p,", [F])++
		format_field_names_1(T)
    end.
    