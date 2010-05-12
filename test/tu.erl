-module(tu).
-compile(export_all).

% test utils

same_ast(FnExpr, ErlExpr) ->
    FnAst = fn:get_ast(string, FnExpr ++ ";"),
    ErlAst = fn:erl_to_ast(ErlExpr ++ "."),
    try
        FnAst = ErlAst,
        ok
    catch
        error:_Error -> {error, FnAst, ErlAst}
    end.

same_mod_ast(FnMod, ErlMod, ModName) ->
    FnAst  = fn:mod_to_ast(FnMod, ModName ++ ".fn"),
    ErlAst = fn:erlmod_to_ast(ErlMod, ModName ++ ".erl"),
    try
        FnAst = ErlAst,
        ok
    catch
        error:_Error -> {error, FnAst, ErlAst}
    end.

same_ast_no_endl(FnExpr, ErlExpr) ->
    FnAst = fn:get_ast(string, FnExpr),
    ErlAst = fn:erl_to_ast(ErlExpr),
    try
        FnAst = ErlAst,
        ok
    catch
        error:_Error -> {error, FnAst, ErlAst}
    end.

test_ast(FnExpr, ErlExpr) ->
    test_ast(FnExpr, ErlExpr, same_ast).

test_ast(FnExpr, ErlExpr, Fun) ->
    Result = try
        ?MODULE:Fun(FnExpr, ErlExpr)
    catch
        _:Err -> {error, Err}
    end,

    case Result of
        ok -> io:format("ok: ~p = ~p~n", [FnExpr, ErlExpr]);
        {error, Error} -> io:format("error: ~p = ~p~n    ~p~n", [FnExpr, ErlExpr, Error]);
        {error, FnAst, ErlAst} -> io:format("error: ~p = ~p~n~p~n~p~n",
                [FnExpr, ErlExpr, FnAst, ErlAst])
   end.

test_mod_ast(FnMod, ErlMod, ModName) ->
    Result = try
        same_mod_ast(FnMod, ErlMod, ModName)
    catch
        _:Err -> {error, Err}
    end,

    case Result of
        ok -> io:format("ok: ~p = ~p~n", [FnMod, ErlMod]);
        {error, Error} -> io:format("error: ~p = ~p~n    ~p~n", [FnMod, ErlMod, Error]);
        {error, FnAst, ErlAst} -> io:format("error: ~p = ~p~n~p~n~p~n",
                [FnMod, ErlMod, FnAst, ErlAst])
   end.

test(Module) ->
    io:format("~ntesting ~p~n", [Module]),
    Module:all().

test(Module, Function) ->
    io:format("~ntesting ~p:~p~n", [Module, Function]),
    Module:Function().