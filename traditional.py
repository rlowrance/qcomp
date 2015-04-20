import numpy as np
import pdb
import timeit


from Bunch import Bunch  # class to mimic C structs


# create test data

debug = False
n = 10 if debug else 1e6


def mkv(n, a):
    # random vector of size n from elements in array a
    return np.random.choice(a, size=n)


#vf = mkv(n, np.array([100.0]))  ##I think this should be 100 * np.random.random_sample(n)
vf = 100 * np.random.random_sample(n)
#vi = mkv(n, np.array([100]))  ##similarly random.random_integers(0, 100, n)
vi = np.random.random_integers(0, 100, n)
vs = mkv(n, np.array(['hp', 'ibm', 'cs', 'appl']))
vb = mkv(n, np.array([0, 1]))
if debug:
    print 'vf', vf[:10]
    print 'vi', vi[:10]
    print 'vs', vs[:10]
    print 'vb', vb[:10]
all = [vf, vi, vs, vb]


# define each test; which must be a function of no arguments


def avg_float():
    np.mean(vf)


def avg_int():
    np.mean(vi)


def avg_bool():
    np.mean(vb)


def max_float():
    np.max(vf)


def max_int():
    np.max(vi)


def max_bool():
    np.max(vb)


def find_inst_of_first_float():
    vf[0] == vf


def find_inst_of_first_int():
    vi[0] == vi


def find_inst_of_first_bool():
    vb[0] == vb


def ct_of_each_element_int():
    # TODO: determine exactly what does the q code creates
    # RESPONSE: creates a dictionary(map) where key is an item and value is # of times it appeared in the original vector
    pass


def ct_of_each_element_bool():
    # TODO: determine exactly what does the q code creates
    pass


def ct_of_each_element_sym():
    # TODO: determine exactly what does the q code creates
    pass


def map_of_inst_using_group():
    # not numpy-like, as the resulting array is ragged
    pass


def map_of_inst_using_homebrew():
    # not yet understood
    pass


def longest_bull_run():
    # not yet understood
    pass


# create table (parallel arrays) sorted by date
order = np.argsort(vi)
t = Bunch(ticker=vs[order], date=vi[order], px=vf[order])
# now we have t.ticker, t.date, t.px


def ct_by_sym():
    # select ct:count i by ticker from t
    pass


def avg_px_by_sym_by_date():
    # select avg px by ticker, date from t
    pass


def max_profit_by_sym():
    # select maxprofit:max px-mins px by ticker from t
    pass


def pairwise_corr():
    corhelp = None  # I don't yet understand the q code
    mkpairs = None  # I don't yet understand the q code
    if False:
        print corhelp, mkpairs  # avoid warning from pylint
    # !corhelp each pairs:mkpairs[]
    pass



def time_all(file_handle=None):
    n_reps = 1000
    print 'average times determined by %d function calls' % n_reps
    format_header = '%30s %15s'
    format_data = '%30s %f'
    print format_header % ('call', 'avg sec per call')
    
    if file_handle:
        file_handle.write("call, seconds\n")

    def time_one(test_name):
        # MAYBE: get rid of the function call, if the q code does not have it
        stmt = '%s()' % test_name
        setup = 'from __main__ import %s' % test_name
        total_secs = timeit.timeit(stmt=stmt, setup=setup, number=n_reps)
        print format_data % (test_name, total_secs / n_reps)
        if file_handle:
            file_handle.write("%s,%f\n" % (test_name, total_secs / n_reps))

    time_one('avg_float')
    time_one('avg_int')
    time_one('avg_bool')
    time_one('max_float')
    time_one('max_int')
    time_one('max_bool')
    time_one('find_inst_of_first_float')
    time_one('find_inst_of_first_int')
    time_one('find_inst_of_first_bool')
    # TODO: add other tests (once they are written)

results = open("python_results.csv","w")
time_all(results)
results.close()




if False:
    pdb.set_trace()  # avoid warning from pylint
