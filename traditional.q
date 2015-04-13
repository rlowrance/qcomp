/
    A traditional set of q computations, to be used to compare speed wrt to other langs
\


// Utilities
tests:([name:`$()] fun:()); //test name and lambda to run
timeit:{ct:.z.P; r:x[]; %[;1e6] .z.P-ct} //timer function
run:{update time:timeit each fun from `tests} //run the tests and update time
mkv:{x?y} //random vector of length x from y
mktbl:{flip (`$"c",/:string til count x)!x} //add headers to matrix and flip to make table

//set our seed for prng

\S 1 

n:`int$1e6 //1 mm elements in our vectors
vf:mkv[n;100.] //vector of floats
vi:mkv[n;100] //vector of ints
vsyms:mkv[n;`hp`ibm`cs`aapl] //vector of symbols
vb:mkv[n;10b] //vector of booleans 

//adding averages to test suite
`tests upsert/:(`$"avg_",/:string `float`int`bool),'{[x;y] avg x}@/:(vf;vi;vb)
//adding max to test suite
`tests upsert/:(`$"max_",/:string `float`int`bool),'{[x;y] max x}@/:(vf;vi;vb)
//all values equal to first element in vector
`tests upsert/:(`$"find_inst_of_first_",/:string `float`int`bool`sym),'{[x;y] x where x=first x}@/:(vf;vi;vb;vsyms)
//create map from unique elements in vector to indices of that element (e.g. 1 1 2 3 -> {1:(0,1), 2:(2), 3:(3)}
`tests upsert/:(`$"map_of_inst_using_group_",/:string `int`bool`sym),'{[x;y] group x}@/:(vi;vb;vsyms) //uses built-in group
`tests upsert/:(`$"map_of_inst_using_homebrew_",/:string `int`bool`sym),'{[x;y] d!(where differ x ix) cut ix:iasc (d:distinct x)?x}@/:(vi;vb;vsyms) //own homebrew function

//let's consider our vector of floats to be a vector of prices
//find length of longest consecutive increases, return starting and ending index
//(akin to looking for bull run in a price series) 
//Treat first element in vector as an increase (to stay consistent with q's deltas built-in)
`tests upsert (`longest_bull_run; {x; m,enlist (first;last)@\:ix s?m:max s:sum each d ix:(where differ d:0<deltas vf) cut til count vf})


//Create a table of syms, ints, and floats
t:([] ticker:vsyms; date:vi; px:vf);
`date xasc `t //sort by date to avoid later sorting for each query that involves order
`tests upsert (`ct_by_sym;{select ct:count i by ticker from t})
`tests upsert (`avg_px_by_sym_by_date;{select avg px by ticker, date from t})
`tests upsert (`max_profit_by_sym;{select maxprofit:max px-mins px by ticker from t}) //note t is already sorted by date

//pair-wise px correlation; since px vectors for each ticker might have a different length
//take the smallest of the two, and use latest prices 
//avoid repeating correlation calcs
corhelp:{(cor) . (neg (&) . count each pxs) sublist/:pxs:value exec px by ticker from t where ticker in x}
mkpairs:{raze i,/:'(1+til count i)_\:i:exec distinct ticker from t}
`tests upsert (`pairwise_corr; {(`$"_"sv/:string pairs)!corhelp each pairs:mkpairs[]})




