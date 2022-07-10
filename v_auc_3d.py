import math
import numpy as np
import matplotlib.pyplot as plt

from matplotlib.ticker import MaxNLocator

# 217 real gates + approx
bench = [
    0.648346,  # 2 participants
    1.26761,  # 3
    2.19367,  # 4 etc..
    3.33782,
    4.65346,
    6.22218,
    8.14146,
    10.1053,
    12.4215,
    ### below is approximation
    14.938,
    17.688,
    20.671,
    23.886,
    27.333,
    31.012,
    34.924,
    39.068,
    43.444,
    48.052,
]

# 1 real
bench_1 = [
    0.669008,
    1.27034,
    2.13164,
    3.10742,
    4.31747,
    5.68777,
    7.37951,
    8.97089,
    11.113,
    13.5891,
    15.8807,
    21.3186,
    22.8755,  # 14
    24.3774,
    31.403,
    35.9517,
    37.5119,
    39.2345,
    44.107
]


def mux():
    return 4


def or_gate():
    return 3


def and_gate():
    return 2


def xnor_gate():
    return 5


def n_bit_and_gate(bits):
    return (bits - 1) * and_gate()


def and_gates_cmp(bits):
    nand_sum = 0
    for i in range(2, bits + 2):
        nand_sum += n_bit_and_gate(i)
    return nand_sum


def n_bit_mux(bit):
    return bit * mux()


def l(p):
    return math.ceil(math.log2(p))


def id_nand(participants):
    return (participants - 1) * n_bit_mux(l(participants))


def comparator(bits):
    return bits + and_gates_cmp(bits) + (bits - 1) * xnor_gate() + (bits - 1) * or_gate()
    # (4 not b's) + n_bit and gates + (n bit xnor) + (n bit or)


def bid_nand(bits, participants):
    return (n_bit_mux(bits) + comparator(bits)) * (participants - 1) + 1


def f(bid_bits, participants):
    return bid_nand(bid_bits, participants) + id_nand(participants)


# def g(bid_bits, participants):
#     return np.sin(bid_bits * 0.1) * np.sin(participants * 0.1)


# x_lim, y_lim = 32, 20
x_lim, y_lim = 20, 10
# bits
x = np.arange(1, x_lim)
# participants
y = np.arange(1, y_lim)
# result
Z = np.zeros((y_lim - 1, x_lim - 1))

print(f(4, 4))

for i in np.arange(1, x_lim - 1):
    for j in np.arange(2, y_lim - 1):
        Z[j, i] = (f(j, i) * bench_1[j - 2]) / 60.0

X, Y = np.meshgrid(x, y)
# H = g(X, Y)

# plt.style.use('dark_background')
fig = plt.figure()
ax = plt.axes(projection='3d')
ax.xaxis.set_major_locator(MaxNLocator(integer=True))
ax.plot_surface(X, Y, Z, rstride=1, cstride=1, cmap='viridis', edgecolor='none')
ax.set_xlabel('Bits per bid amount')
ax.set_ylabel('Participants')
# ax.set_zlabel('NAND gates')
ax.set_zlabel('Circuit Evaluation (min)')

plt.savefig('circuit_eval.pdf', dpi=300)
plt.show()
