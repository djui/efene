-module(fn_spec).
-export([convert/1]).


% convert ast to spec ast
convert(Ast) -> convert(Ast, []).

convert([], Accum) ->
    lists:reverse(Accum);
convert([{op, _Line, 'bor', _Ast1, _Ast2}=Bor|T], Accum) ->
    convert(T, [convert_union(Bor)|Accum]);
convert([H|T], Accum) ->
    convert(T, [convert_one(H)|Accum]).

convert_one({call, Line, {atom, _, tuple}, []}) ->
    {type, Line, tuple, any};
convert_one({call, Line, {atom, _, Name}, Args}) ->
    {type, Line, Name, Args};
convert_one({atom, _Line, _Name}=Atom) ->
    Atom;
convert_one({_, Line, _}=Node) ->
    throw({error, {Line, fn_parser, ["Invalid syntax in spec: ", Node]}}).

convert_union({op, Line, 'bor', Ast1, Ast2}) ->
    {type, Line, union, lists:flatten([convert_union_left(Ast1), [convert_one(Ast2)]])}.

convert_union_left({op, _Line, 'bor', Ast1, Ast2}) ->
    [convert_union_left(Ast1), convert_one(Ast2)];
convert_union_left(Ast) ->
    convert_one(Ast).

