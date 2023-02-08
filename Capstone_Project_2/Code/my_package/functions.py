import pandas as pd
import matplotlib.pyplot as plt

def make_image_table(dataframe, figsize=None, frame=False, axis='off', cellLoc='center', fontsize=None):
    fig, ax = plt.subplots(figsize=figsize)
    ax.set_frame_on(frame)
    ax.axis(axis)
    pd.plotting.table(ax, dataframe, fontsize=fontsize, cellLoc=cellLoc)
    plt.show()