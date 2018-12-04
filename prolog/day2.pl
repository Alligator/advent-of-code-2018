:- use_module(library(list_util)).

parse_input(I, R) :-
  split_string(I, "\n", " ", L),
  delete(L, "", R).

% identity predicate, used for group_with
% there must be something for this in the stdlib but i can't seem to
% find it!
identity(X, X).

% has_double(List)
% true if the list has at least one element that is repeated exactly
% twice
has_double(List) :-
  group_with(identity, List, Groups),
  length(Doubles, 2),
  member(Doubles, Groups).

% has_tripe(List)
% true if the list has at least one element that is repeated exactly
% three times
has_triple(List) :-
  group_with(identity, List, Groups),
  length(Triples, 3),
  member(Triples, Groups).

% one_apart(List1, List)
% true if exactly one element in List1 is different to the element in
% List2 at the same position
one_apart([Head1|Tail1], [Head1|Tail2]) :-
  one_apart(Tail1, Tail2).
one_apart([Head1|Tail], [Head2|Tail]) :-
  Head1 \= Head2.

% get_common(List1, List2, Common)
% true if Common is the list of elements in List1 that match the same
% element at the same position in List2
get_common(A, A, A).
get_common([], _, []).
get_common(_, [], []).
get_common([Head|Tail1], [Head|Tail2], Common) :-
  get_common(Tail1, Tail2, RestCommon),
  Common = [Head|RestCommon].
get_common([_|Tail1], [_|Tail2], Common) :-
  get_common(Tail1, Tail2, Common).

main(Result1, Result2) :-
  % example inputs
  % Input = ["abcdef", "bababc", "abbcde", "abcccd", "aabcdd", "abcdee", "ababab"],
  % Input = ["abcde", "fghij", "klmno", "pqrst", "fguij", "axcye", "wvxyz"],
  read_file_to_codes("../inputs/day2", File, []),
  % codes > string
  string_codes(Input, File),
  % string > list of strings
  parse_input(Input, StringInput),
  % list of strings > list of lists of codes
  maplist(string_codes, StringInput, Codes),

  % part 1
  % find the doubles
  include(has_double, Codes, Doubles),
  % find the triples
  include(has_triple, Codes, Triples),
  % do the dang thing
  length(Doubles, DoubleCount),
  length(Triples, TripleCount),
  Result1 is DoubleCount * TripleCount,

  % part 2
  % find all permutations
  append([_, [Fst], _, [Snd], _], Codes),
  one_apart(Fst, Snd),
  get_common(Fst, Snd, Diff),
  string_codes(Result2, Diff).
