import math
import numpy as np
import pandas as pd
import seaborn as sns
import matplotlib.pyplot as plt

sns.set_theme(style="darkgrid")

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
    # below is approximation
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

x_lim, y_lim = 10, 20
# bits
x = np.arange(1, x_lim)
# participants
y = np.arange(1, y_lim)
p = np.arange(2, y_lim + 1)
# result
Z = np.zeros((y_lim - 1, x_lim - 1))

X, Y = np.meshgrid(x, y)
# H = g(X, Y)

df = {'Number Of Participants': p,
      'Single NAND Gate Evaluation Time (seconds)': bench_1}

pdf = pd.DataFrame(df)
print(pdf)

pl = sns.lineplot(x=p, y=bench_1)

pl.set(xlabel="Number of Participants", ylabel="Gate Evaluation Time (in Seconds)")
plt.savefig('gate_eval.pdf', dpi=300)
plt.show()
