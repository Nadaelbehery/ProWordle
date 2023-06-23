:-dynamic word/2.
build_kb:-
         write('Please enter a word and its category on separate lines:'),nl,
		 read(W),((W=done,write('Done building the words database...'),nl);(W\=done,read(C),assert(word(W,C)),build_kb)).
is_category(C):-word(_,C).
categories(L):-setof(C,is_category(C),L).
available_length(L):-word(X,_),atom_chars(X,Y),length(Y,L).
pick_word(W,L,C):-
			 available_length(L),
			 word(W,C).
correct_letters(L1,L2,CL):- intersection(L1,L2,CL).
correct_positions([], [], []).
correct_positions([X|A], [X|B], [X|C]) :-
    correct_positions(A, B, C).
correct_positions([X|A], [Y|B], C) :- 
    X\==Y, 
    correct_positions(A, B, C).
insert(X,L,[X|L]).
insert(X,[Y|L],[Y|L1]):-insert(X,L,L1).
getlength(L,L2):-
     write('Choose a length:'),nl,
	 read(L),
	 (pick_word(W,L,H),write('Game started. You have '),L2 is L+1,write(L2),write(' guesses'),nl;
	 \+pick_word(W,L,H),
	 write('There are no words of this length'),nl,
	 getlength(L1,L2)).
getWordss(W,L3,1):- write('Enter a word composed of '),write(L3),write(' letters: '),nl,
                   read(W1),
                   ((W\==W1,write('You Lost!'));
				   (W==W1,write('You Won!'))).
getWordss(W,L3,L2):- write('Enter a word composed of '),write(L3),write(' letters: '),nl,
    read(W1),((  string_length(W,L),string_length(W1,Lx),atom_chars(W,Ww1),atom_chars(W1,Ww2),correct_letters(Ww1,Ww2,X),
                  correct_positions(Ww1,Ww2,X1),((   W==W1,!,write('You won!'));(   write('Correct letters are: '),
                                                                                      write(X),nl,write('Correct letters in correct positions are: '),write(X1),nl,
                                                                                      write('Remaining Guesses are '),L4 is L2-1,write(L4),nl,getWordss(W,L3,L4))));
             
             ( string_length(W,L),string_length(W1,Lx),L\==Lx,write('Word is not composed of '),write(L3),write(' Letters. Try again'),nl,write('Remaining Guesses are '),write(L2),
                 nl,getWordss(W,L3,L2))).

getCat(C,L):-
         write('Choose a category:'),nl,
		 read(C),
		 insert(C,L,X),
		 (is_category(C),L=X;\+is_category(C),write('This category does not exist.'),nl,getCat(C1,X)).
		 


play:-
     write('The available categories are:'),categories(L1),write(L1),nl,
	 getCat(C,[H|T]),
	 getlength(L,L2),L3 is L2-1,
	 pick_word(W,L3,H),getWordss(W,L3,L2).
main:- write('Welcome to Pro-Wordle!'),nl,write('---------------------'),nl,build_kb,nl,play.
      
    

	
 