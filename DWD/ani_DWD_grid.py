#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
 Plot of annual mean temperature for Germany from DWD data and save as 
 individual plots and animated gif. 
"""
import scipy.io as sp
import numpy as np
import imageio
from matplotlib.colors import ListedColormap
import multiprocessing as mp
#import pyfunc.DWD_func as dwdf
#from pyfunc.DWD_func import plot_fun2

def myfun():
    from pyfunc.DWD_func import plot_fun2
    # atmospheric data downloaded and processed with load_DWD_grid_data.m
    h = np.load('atmodata.npz')
    #with np.load('atmodata.npz') as data:
    adata = h['a']
    zp = h['b']
    nds=len(zp)
    # dimension of grids from header of ascii file
    ncols = 654
    nrows = 866
    # grid of geographical coordinates to be used instead of Gauss-Krueger
    mat_contents = sp.loadmat('data/coordlatlon.mat')
    x = mat_contents.get("clatlon")
    lat=np.reshape(x[:,0],(ncols,nrows)).T
    lon=np.reshape(x[:,1],(ncols,nrows)).T
    # subtract mean temperature 1961-1990 for each data point
    ind = np.where((zp>1960.) & (zp<1991.))
    tepoch=adata[:,:,ind[0]]
    mtp = np.nanmean(tepoch,axis=2)
    # Colormap
    mat_contents = sp.loadmat('data/cmap3.mat')
    pcmap = mat_contents.get("cmap")
    mycmap = ListedColormap(pcmap)
    # generate plots with multiprocessing
    pnames=[]
    p = mp.Pool(mp.cpu_count())
    resi=[p.apply_async(plot_fun2, args = (lon, lat, adata[:,:,hi]-mtp,str(int(zp[hi])),mycmap)) 
               for hi in range(0,nds) ]
    p.close()
    p.join()
    for hi in range(0,nds):
        pname=resi[hi].get()
        pnames.append(pname)
    # save individual files as animated gif
    with imageio.get_writer('tempgif.gif', mode='I') as writer:
        for pname1 in pnames:
            image = imageio.imread(pname1)
            writer.append_data(image)

if __name__ == '__main__':
    myfun()

