#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
 Plot of warming stripes for Leipzig and Germany from DWD data. The
 individual location is interpolated in the dataset
"""
import scipy.io as sp
from scipy.interpolate import griddata
import numpy as np
import multiprocessing as mp
from matplotlib.colors import ListedColormap
#from pyfunc.DWD_func import plot_german_data, plot_stripes


def ifun(l1,l2,d,x1,x2):
    """
    Interpolate chosen position in grid

    Parameters
    ----------
    l1 : longitute gridpoints as vector
    l2 : latitute gridpoints as vector
    d : data as vector
    x1 : longitude interpolation point
    x2 : latitude interpolation point

    Returns
    -------
    erg : interpolated temperature

    """
    erg=griddata((l1,l2),d,(x1,x2), method='linear')
    return erg

if __name__ == '__main__':
    from pyfunc.DWD_func import plot_german_data, plot_stripes
    # atmospheric data downloaded and processed with load_DWD_grid_data.m
    h = np.load('atmodata.npz')
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
    latv=lat.ravel()
    lon=np.reshape(x[:,1],(ncols,nrows)).T
    lonv=lon.ravel()
    # Leipzig
    pos=[51.3, 12.37]
    # Plot Location and first dataset
    plot_german_data(lon, lat, adata,pos)
    # create colormap for climate stripes
    # Colormap 2 in 36C3 design (RGB)
    # Destruction: 254 80 0
    #        Hope:  0 187 49
    # cmap1: blue:white:red
    # cmap2: hope:white:destruction
    mat_contents = sp.loadmat('data/cmap1.mat')
    pcmap = mat_contents.get("cmap")
    mycmap = ListedColormap(pcmap)
    # climate stripes Germany
    # Annual mean temperatures Germany
    temp_annual=np.nanmean(adata,axis=(0,1))
    # subtract mean temperature 1961-1990 for Germany
    ind = np.where((zp>1960.) & (zp<1991.))
    temp_annual_st=temp_annual-np.mean(temp_annual[ind])
    plot_stripes(zp,temp_annual_st,mycmap,'Germany',np.mean(temp_annual[ind]))
    # interpolation of data for chosen location with multiprocessing package
    p = mp.Pool(mp.cpu_count())
    res=[p.apply_async(ifun, args = (lonv,latv, adata[:,:,hi].ravel(), pos[1],pos[0])) 
          for hi in range(0,nds) ]
    p.close()
    p.join()
    tpos=np.zeros(nds)
    for hi in range(0,nds):
        tpos[hi] = res[hi].get()
    # subtract mean temperature 1961-1990 for chosen location
    tpos_st=tpos-np.mean(tpos[ind])
    plot_stripes(zp,tpos_st,mycmap,'Leipzig',np.mean(tpos[ind]))
    