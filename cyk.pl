%refer to https://ja.wikipedia.org/wiki/CYK法

% ?-s_new,[-'cyk.pl'],test.
test:-
	Morph = [[ '健','名詞'],['が','助詞'],['直美','名詞'],['を','助詞'], ['愛する','動詞'] ],
    T1 is cputime,
    length(Morph,Len),
    make_cyk(Len,Morph,CYK),
    make_tree(Len,CYK,TREE),
    T2 is cputime - T1,
    write('CYK Table'=CYK),nl,
    write('tree'=TREE),nl,
    write(T2),nl,!.

make_cyk(Len,Morph,CYK):-
	init_cyk(Morph,0,Len,CYK),
	set_cyk(0:Len,CYK),!.

%%init
init_cyk([],_,_,[]):-!.
init_cyk([Morph|ZM],N,L,[X|Z]):-
	init_cyk2(0:L,N,Morph,X),
	NN is N + 1,
	init_cyk(ZM,NN,L,Z).

init_cyk2(L:L,_,_,[]):-!.
init_cyk2(N:L,N,[Word,P],[[Word,P,[P,Word]]|X]):- B is N + 1,init_cyk2(B:L,N,Morph,X).
init_cyk2(A:L,N,Morph   ,[[_,_,_]|X]):-           B is A + 1,init_cyk2(B:L,N,Morph,X).

%%set
set_cyk(I:I,_):-!.
set_cyk(I:L,CYK):-
	II is I + 1,LL is L - I,
	set_cyk2(0:LL,II,CYK),
	set_cyk(II:L,CYK).

set_cyk2(M:M,_,_):-!.
set_cyk2(M:Len,I,CYK):-
	MM is M + 1,
	(J is I + M,( MM = J -> true ;
	              set_cyk3(MM:J,MM,Len,CYK) )
	; true),!,
	set_cyk2(MM:Len,I,CYK).

set_cyk3(N:N,M,  _,  _):-!.
set_cyk3(H:N,M,Len,CYK):-
	nnth([M,H],[WM,PM,TrM],CYK),nonvar(WM),             
	HH is H + 1,
	nnth([HH,N],[WN,PN,TrN],CYK),nonvar(WN),            
	( { N = Len,M = 1} -> last_phrase(Phrase) ; true ),
	phrase([PM,PN],Phrase),!,
	atom_append(WM,WN,WP),                              
	nnth([M,N],[WP,Phrase,[Phrase,TrM,TrN]],CYK),
	%name(NL,[31]),
	%write_listnl([ 
	% '  * ',[M,H],' - ',[HH,N],NL,
	% '    ',[WM,PM],NL,
	% '    ',[WN,PN],NL,
	% '    '=[WP,Phrase] ]).
	true.
set_cyk3(H:N,M,Len,CYK):-
    HH is H + 1, %write_listnl(['  - ',[M,H],' - ',[HH,N]]),
    set_cyk3(HH:N,M,Len,CYK).

%%tree
make_tree(Len,[IL|CYK],TREE):-
    last_phrase(Phrase),
    make_tree(1:Len,Phrase,IL,[IL|CYK],TREE),!.

make_tree(L:L,_,_,_,[]):-!.
make_tree(I:L,Phrase,[[WI,PI,TrI]|LIL],CYK,[[Phrase,TrI,TrJ]|TREE]):-
	nonvar(PI),
	J is I + 1, % write('WI'=WI),nl,write('PI'=PI),nl,write('Tr'=TrI),nl,
	nnth([J,L],[WJ,QJ,TrJ],CYK),nonvar(QJ),
	phrase([PI,QJ],Phrase),!,
	make_tree(J:L,Phrase,LIL,CYK,TREE).
    
make_tree(I:L,Phrase,[_|LIL],CYK,TREE):-
	J is I + 1,
	make_tree(J:L,Phrase,LIL,CYK,TREE).

% 句の定義
last_phrase(文).
phrase([名詞,動詞],動詞句).
phrase([名詞,名詞],名詞句).
phrase([名詞,助詞],名詞句).
phrase([名詞,接尾辞],名詞句).
phrase([名詞,助動詞],名詞句).
phrase([接頭辞,名詞],名詞句).
phrase([接頭辞,名詞句],名詞句).
phrase([動詞,名詞],名詞句).
phrase([動詞,代名詞],名詞句).
phrase([動詞,助動詞],動詞句).
phrase([動詞,助詞],動詞句).
phrase([代名詞,助詞],名詞句).
phrase([形容詞,名詞],名詞句).
phrase([形容詞,名詞句],名詞句).
phrase([形容詞,動詞],動詞句).
phrase([形容詞,助詞],形容詞句).
phrase([形容詞,連体詞],連体詞句).
phrase([形状詞,助詞],形容詞句).
phrase([連体詞,名詞],名詞句).
phrase([連体詞,代名詞],名詞句).
phrase([副詞,副詞],副詞句).
phrase([副詞,助詞],副詞句).
phrase([副詞,形容詞],形容詞句).
phrase([副詞,名詞],名詞句).
phrase([副詞,動詞],動詞句).

phrase([名詞句,助詞],名詞句).
phrase([名詞句,助動詞],名詞句).
phrase([名詞句,名詞],名詞句).
phrase([名詞句,名詞句],名詞句).
phrase([名詞句,動詞],動詞句).
phrase([名詞句,動詞句],動詞句).
phrase([名詞句,連体詞],連体詞句).
phrase([名詞句,形容詞],形容詞句).
phrase([名詞句,形容詞句],形容詞句).
phrase([名詞句,接尾辞],名詞句).
phrase([動詞句,名詞],名詞句).
phrase([動詞句,名詞句],名詞句).
phrase([動詞句,動詞],動詞句).
phrase([動詞句,代名詞],名詞句).
phrase([動詞句,助詞],動詞句).
phrase([動詞句,助動詞],動詞句).
phrase([動詞句,動詞句],動詞句).
phrase([副詞句,形容詞],形容詞句).
phrase([副詞句,名詞],名詞句).
phrase([副詞句,動詞],動詞句).
phrase([形容詞句,動詞],動詞句).

phrase([名詞句,動詞],文).
phrase([名詞句,動詞句],文).
phrase([名詞句,名詞],文).
phrase([名詞句,名詞句],文).
phrase([名詞句,助動詞],文).
phrase([名詞句,形容詞],文).
phrase([名詞句,形容詞句],文).
phrase([名詞句,接尾辞],文).
phrase([動詞句,動詞句],文).
phrase([動詞句,名詞],文).
phrase([動詞句,名詞句],文).
phrase([形容詞,名詞句],文).
phrase([連体詞,名詞],文).
phrase([連体詞句,名詞],文).
phrase([連体詞,代名詞],文).
phrase([連体詞句,代名詞],文).
phrase([副詞,名詞句],文).
phrase([副詞句,動詞句],文).

%% Util
nnth([I,J],X,T):-nth(I,A,T),nth(J,X,A).
nth(1,A,[A|_]).
nth(N,A,[_|L]):-M is N-1,nth(M,A,L).




/*

CYK Table=[[[健,名詞,[名詞,健]],[健が,名詞句,[名詞句,[名詞,健],[助詞,が]]],[健が直美,名詞句,[名詞句,
[名詞句,[名詞,健],[助詞,が]],[名詞,直美]]],[健が直美を,名詞句,[名詞句,[名詞句,[名詞,健],[助詞,が]],[
名詞句,[名詞,直美],[助詞,を]]]],[健が直美を愛する,動詞句,[動詞句,[名詞句,[名詞,健],[助詞,が]],[動詞
句,[名詞句,[名詞,直美],[助詞,を]],[動詞,愛する]]]]],[[_154,_155,_156],[が,助詞,[助詞,が]],[_196,_197
,_198],[_216,_217,_218],[_236,_237,_238]],[[_271,_272,_273],[_291,_292,_293],[直美,名詞,[名詞,直美]]
,[直美を,名詞句,[名詞句,[名詞,直美],[助詞,を]]],[直美を愛する,動詞句,[動詞句,[名詞句,[名詞,直美],[助
詞,を]],[動詞,愛する]]]],[[_388,_389,_390],[_408,_409,_410],[_428,_429,_430],[を,助詞,[助詞,を]],[_4
70,_471,_472]],[[_505,_506,_507],[_525,_526,_527],[_545,_546,_547],[_565,_566,_567],[愛する,動詞,[動
詞,愛する]]]]
tree=[
 [
  文,
     [名詞句,[名詞,健],[助詞,が]],
     [動詞句,[名詞句,[名詞,直美],[助詞,を]],
     [動詞,愛する]]
 ],
 [
  文,
     [名詞句,
      [名詞句,[名詞,健],[助詞,が]],
      [名詞句,[名詞,直美],[助詞,を]]
     ],
     [動詞,愛する]
 ]
]
0.000999927520751953

*/
