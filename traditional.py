import numpy as np
import pdb
import timeit


from Bunch import Bunch  # class to mimic C structs


debug = False
n = 10 if debug else 1e6


def mkv(n, a):
    # random vector of size n from elements in array a
    return np.random.choice(a, size=n)


vf = mkv(n, np.array([100.0]))
vi = mkv(n, np.array([100]))
vs = mkv(n, np.array(['hp', 'ibm', 'cs', 'appl']))
vb = mkv(n, np.array([0, 1]))
if debug:
    print 'vf', vf[:10]
    print 'vi', vi[:10]
    print 'vs', vs[:10]
    print 'vb', vb[:10]
all = [vf, vi, vs, vb]

tests = {}


def avg():
    tests['avg'] = [np.mean(vf), np.mean(vi), np.mean(vb)]


def max():
    tests['max'] = [np.max(vf), np.max(vi), np.max(vb)]


def find_inst_of_first():
    tests['find_inst_of_first'] = [vf[0] == vf, vi[0] == vi, vb[0] == vb]


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


def time_all():
    n_reps = 1000

    def time_one(tag):
        stmt = '%s()' % tag
        setup = 'from __main__ import %s' % tag
        total_secs = timeit.timeit(stmt=stmt, setup=setup, number=n_reps)
        print '%s took %f seconds per call' % (tag, total_secs / n_reps)

    time_one('avg')
    time_one('max')
    time_one('find_inst_of_first')
    time_one('map_of_inst_using_group')
    time_one('map_of_inst_using_homebrew')
    time_one('ct_by_sym')
    time_one('avg_px_by_sym_by_date')
    time_one('max_profit_by_sym')
    time_one('pairwise_corr')

time_all()


if False:
    pdb.set_trace()  # avoid warning from pylint
