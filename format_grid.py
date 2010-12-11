import matplotlib.pyplot as plt
import matplotlib.image as mpimg
from pylab import *
import pylab
import matplotlib.colors
from matplotlib.colors import ListedColormap, BoundaryNorm
from mpl_toolkits.basemap import Basemap
import numpy as np
import sys
import os
from scipy.stats import scoreatpercentile

os.chdir('/Users/danhammer/Dropbox/n_drive/FCI')

width = 4320
height = 2160

data = np.load('fciout.npy')
grid = np.reshape(data, (height, width))

top = 6.6646
left = 94.5703125
bottom = -11.6953
right = 141.15234375

left_t 	= left + 180
right_t = right + 180
top_t 	= 90 - top
bottom_t= 90 - bottom

cell_left = (left_t/360)*width
cell_right = (right_t/360)*width
cell_top = (top_t/360)*height
cell_bottom = (bottom_t/360)*height

print cell_left
print cell_right
print cell_top
print cell_bottom

grid_idn = grid[cell_top:cell_bottom,cell_left:cell_right]
print grid_idn.shape

m = Basemap(projection='cyl',lat_0=0,lon_0=0, resolution='l',area_thresh=1000.)
m.drawcoastlines(linewidth=0.5)
m.drawcountries()

pylab.show()