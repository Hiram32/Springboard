import pandas as pd
import matplotlib.pyplot as plt

def make_image_table(dataframe, figsize, figheight=0.1, frame=False, axis='off'):
    fig, ax = plt.subplots(figsize=figsize)
    fig.set_figheight(figheight)
    ax.set_frame_on(frame)
    ax.axis(axis)
    pd.plotting.table(ax, dataframe)
    plt.show()