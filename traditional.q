/
    A traditional set of q computations, to be used to compare speed wrt to other langs
\


// Utilities
tests:([name:`$()] fun:()); //test name and lambda to run
timeit:{ct:.z.P; r:x[]; %[;1e6] .z.P-ct} //timer function
nreps:1000
timeall:{update time:avg each timeit/[nreps;] each fun from `tests} //run the tests, nreps each time, avg time stored
mkv:{x?y} //random vector of length x from y
mktbl:{flip (`$"c",/:string til count x)!x} //add headers to matrix and flip to make table
register:{`tests upsert (x;y)} //register a new test
//set our seed for prng

\S 1 

n:`int$1e6 //1 mm elements in our vectors
vf:mkv[n;100.] //vector of floats
vi:mkv[n;100] //vector of ints
vsyms:mkv[n;`hp`ibm`cs`aapl] //vector of symbols
vb:mkv[n;10b] //vector of booleans 

//register averages to test suite
register[`avg_float;{avg vf}]
register[`avg_int;  {avg vi}]
register[`avg_bool; {avg vb}]

//register max to test suite
register[`max_float;{max vf}]
register[`max_int;  {max vi}]
register[`max_bool; {max vb}]

//all values equal to first element in vector
register[`find_inst_of_first_float;{vf where vf=first vf}]
register[`find_inst_of_first_int;  {vi where vi=first vi}]
register[`find_inst_of_first_bool; {vb where vb=first vb}]
register[`find_inst_of_first_sym;  {vsyms where vsyms=first vsyms}]


//return count of each element in vector
register[`ct_of_each_elem_int; {count each group vi}]
register[`ct_of_each_elem_bool;{count each group vb}]
register[`ct_of_each_elem_sym; {count each group vsyms}]

//create map from unique elements in vector to indices of that element (e.g. 1 1 2 3 -> {1:(0,1), 2:(2), 3:(3)}
//`tests upsert/:(`$"map_of_inst_using_group_",/:string `int`bool`sym),'{[x;y] group x}@/:(vi;vb;vsyms) //uses built-in group
//`tests upsert/:(`$"map_of_inst_using_homebrew_",/:string `int`bool`sym),'{[x;y] d!(where differ x ix) cut ix:iasc (d:distinct x)?x}@/:(vi;vb;vsyms) //own homebrew function

//let's consider our vector of floats to be a vector of prices
//find length of longest consecutive increases, return starting and ending index
//(akin to looking for bull run in a price series) 
//Treat first element in vector as an increase (to stay consistent with q's deltas built-in)
register[`longest_bull_run;{m,enlist (first;last)@\:ix s?m:max s:sum each d ix:(where differ d:0<deltas vf) cut til count vf}]
/
    line by line commented below (we avoid this in actual implementation to avoid creating temporaries
    rawix:til count vf //create a vector of indices for the float vector [0...len(vf)]
    pxincreases:0<deltas vf //boolean vector of true whenever price increases, false when decreases
    pxdirchg:differ pxincreases //create boolean vector whenever elem i is different from elem i - 1
    pxdirchgix:where pxdirchg //vector of indices corresponding to places where the pxdirchg = true
    marketruns:pxdirchgix cut rawix //create list of lists, where each sublist corresponds to indices of a continuous move up or down in prices
    increases:sum each pxincreases marketruns //use each sublist to index into the vector of price increases, and count how many continuous increases took place
    longestbull:max increases //longest bull run
    longestbullix:marketruns increases?longestbull //return the indices associated with period of longestbul
    startend:(first;last)@\:longestbullix //start and end index of that part of the vector
    return longestbull,startend
\



//Create a table of syms, ints, and floats
t:([] ticker:vsyms; date:vi; px:vf);
`date xasc `t //sort by date to avoid later sorting for each query that involves order
register[`ct_by_sym;{select ct:count i by ticker from t}]

register[`avg_px_by_sym_by_date;{select avg px by ticker, date from t}]

register[`max_profit_by_sym;{select maxprofit:max px-mins px by ticker from t}] //note t is already sorted by date

//pair-wise px correlation; since px vectors for each ticker might have a different length
//take the smallest of the two, and use latest prices 
//avoid repeating correlation calcs

//extract a vector of pxs for each of the 2 tickers in x, find the shortest length of the 2 (call this n)
//then take the n latest pxs (defined as prices[len(v)-n ...len(v)]) and calculate the correlation
//between the vectors
corhelp:{(cor) . (neg (&) . count each pxs) sublist/:pxs:value exec px by ticker from t where ticker in x}
//create a list of pairs of tickers, from the tickers in our table t
//created so that there are correlations to the same ticker, and that we don't repeat correlations (e.g. don't calculate corr(a,b) and then corr(b,a)
mkpairs:{raze i,/:'(1+til count i)_\:i:exec distinct ticker from t}
register[`pairwise_corr; {(`$"_"sv/:string pairs)!corhelp each pairs:mkpairs[]}]





