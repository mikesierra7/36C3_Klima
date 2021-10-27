#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""

"""

import numpy as np
from scipy.interpolate import griddata
import matplotlib.pyplot as plt
from matplotlib.patches import Polygon
from matplotlib.collections import PatchCollection
import matplotlib.ticker as mticker
from cartopy import crs as ccrs
from cartopy.mpl.gridliner import LatitudeFormatter , LongitudeFormatter
import cartopy.feature as cfeature

def plot_fun2(lon, lat, dC,jahr,mycmap):
    '''
    Plot annual mean temperature map for Germany

    Parameters
    ----------
    lon : longitude
    lat : latitude
    dC : array of temperature
    jahr : string with year, which is used as title for plot
    mycmap : custom colormap

    Returns
    -------
    pname : filename of saved figure

    '''
    fig=plot_german_data(lon, lat, dC,[],jahr,mycmap, [-3, 4.5])
    pname='tplot'+jahr+'.png'
    fig.savefig(pname)
    return pname

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

def plot_stripes(zp,tempdata,mycmap,plottitle='location',meantemp=0):
    """
    Plot climate stripes and timeseries of annual mean temperature

    Parameters
    ----------
    zp : year
    tempdata : temperature data in 3D array
    mycmap : colormap
    plottitle : title of figure, optional
    meantemp : mean annual temperature in reference epoch 1961 to 1990, optional

    Returns
    -------
    None.

    """
    nds = len(zp)
    # create patches for climate stripes
    pats=[]
    for hi in range(0,nds):
        poly=Polygon([[zp[hi], -1.],[zp[hi]+1., -1.], [zp[hi]+1., 1.],[zp[hi], 1.] ], closed=True)
        pats.append(poly)
    pc=PatchCollection(pats,cmap=mycmap)
    # Plot climate stripes
    fig, ax = plt.subplots(figsize=(10,5) )
    ax.set_title(plottitle, fontsize=12)
    pc.set_array(np.array(tempdata))
    p=ax.add_collection(pc)
    cbar=plt.colorbar(p)
    cbar.set_label('°C', rotation=90)
    plt.autoscale(enable=True, tight=True)
    p.set_clim([-2.5 , 2.5])
    plt.tick_params(axis='y', which='both',left=False,right=False, labelleft=False)     
    plt.show()
    # timeseries plot
    fig1, ax1 = plt.subplots(figsize=(10,5) )
    ax1.set_title(plottitle, fontsize=12)
    ax1.plot(zp,tempdata+meantemp,label='annual mean temperature')
    plt.axhline(y=meantemp, color='r', linestyle='-',label='mean temperature 1961-1990')
    plt.legend()
    plt.show()
    
def plot_german_data(lon,lat,adata,pos=[],plottitle='',mycmap='RdBu_r', axlims=[]):
    """
    plot map of annual mean temperature

    Parameters
    ----------
    lon : 2D array of longitude
    lat : 2D array of latitute
    adata : 2D array of temperature
    pos : position for a single marker, optional
    plottitle : title of figure, optional
    mycmap : colormap, optional
    axlims : 1x2 array of colobar axis limits, optional

    Returns
    -------
    fig : figure handle

    """
    states_provinces = cfeature.NaturalEarthFeature(
        category='cultural',
        name='admin_0_countries',
        scale='10m',
        facecolor='none')
    fig=plt.figure(figsize=[10.5,8])
    ax = plt.subplot(projection=ccrs.PlateCarree())
    da=plt.scatter(lon,lat,c=adata,marker='.',cmap=mycmap)
    ax.add_feature(states_provinces, edgecolor='gray')
    ax.set_aspect('equal', 'box')
    if len(pos) !=0:
        plt.plot(pos[1],pos[0], marker="o")
    if len(plottitle) !=0:
        ax.set_title(plottitle, fontsize=12)
    lonLabels = np.arange(0, 18, 3)
    latLabels = np.arange(45, 60, 3)
    gl=ax.gridlines(draw_labels=True,color='k',linewidth=1.5)
    gl.xlocator = mticker.FixedLocator(lonLabels)
    gl.ylocator = mticker.FixedLocator(latLabels)
    gl.xformatter = LongitudeFormatter()
    gl.yformatter = LatitudeFormatter()
    cbar=plt.colorbar(da,pad=0.07)
    cbar.set_label('°C', rotation=90)
    if len(axlims) != 0:
        da.set_clim(axlims)
    plt.show()
    return fig