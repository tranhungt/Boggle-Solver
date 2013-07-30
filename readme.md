#Boggle Solver
This is the classic boggle game, played with a N x N  grid of letters.

#Possible Ways to solve
+ Brute force of exhaustive search would have been O((n^2)!)
+ A trie could have been used to traverse the dictionary from each point on the grid.
+ My method iterated through the dictionary, and checked to see if each word was in the grid,
which is at most O(n), where n is the dictionary size.

#Can the algorithm handle words within words? ie. 'her' inside 'catcher' ?
Yes. Since the algorithm searches through each word of the UNIX dictionary (~250k inputs), every word has the opportunity to find it's place in the world.

#Data Structures Used
+ Hash used for the dictionary, organized by the first letter.
+ Hash was also used to look up position of letters, and letter at each coord.
  Hash has O(1) lookup times, and each bucket can be removed/inserted very quickly.
  Trees could have been used to traverse the dictionary, as in a trie, but my algorithm called for a different approach. 
+ Array used to keep track of all valid words found on the grid.
  This is just simple data storage, anything could have worked, but this was simple to implement.
+ Nested Array (2D Matrix) used to format the grid of letters.

+ Set was used to keep track of all the indexes visited when tracing steps on the grid.
  Could have been an array, but Set has faster lookup time, O(1), compared to O(n) of an unsorted array.
  However, since the words are so short, this performance increase is minimal.

#How I optimized
+ Optimization was mostly through approach rather than specific methods.
+ Since my dictionary has been formatted in a hash, any words whose first letter did not show up on the grid could easily be excluded from the dictionary.
+ When iterating through each of the dictionary letter, the algorithm moves to the next word if the next letter could not be found in the grid sequence.
