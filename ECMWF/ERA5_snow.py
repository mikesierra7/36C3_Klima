#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
ECMWF datafile access
 example for access of data in a netCDF file and interpolation of a single coordinate.
 t2m: air temperature in 2m height
 sd: snow depth expressed as a water layer covering the grid cell
 sf: snowfall expressed as a water layer
"""

import numpy as np
from netCDF4 import Dataset
import cftime
from scipy.interpolate import interp2d
import matplotlib.pyplot as plt

# Leipzig
pos = [51.3, 12.37]
# Datafile downloaded with ERA5_snow.py
dfile = 'ERA5_snow_monthly025.nc'
# Open file
fid = Dataset(dfile)
print(fid)
# coordinate grid
lon = np.array(fid['longitude'])
lat = np.array(fid['latitude'])
glat,glon =np.meshgrid(lat,lon)
# time
nctime = np.array(fid['time'])
nctimeunit = fid.variables['time'].units
zp=[]
zp.append(cftime.num2pydate(nctime, units=nctimeunit))
nds = len(zp[0])
# Data
at2m = np.array(fid['t2m'])
asd = np.array(fid['sd'])
asf = np.array(fid['sf'])
# iterpolation
t2m = np.zeros(nds)
sd = np.zeros(nds)
sf = np.zeros(nds)
expver=0
for hi in range(0, nds):
    if at2m[hi,expver,1,1]==-32767:
        expver=1
    ifun = interp2d(lon,lat, at2m[hi,expver,:,:],kind='linear')
    t2m[hi] = ifun(pos[1],pos[0])-278.5651
    ifun = interp2d(lon,lat, asd[hi,expver,:,:],kind='linear')
    sd[hi] = ifun(pos[1],pos[0])
    ifun = interp2d(lon,lat, asf[hi,expver,:,:],kind='linear')
    sf[hi] = ifun(pos[1],pos[0])
    
fig, ax = plt.subplots(3,1,figsize=(7,9))
plt.subplots_adjust(hspace=.0)
ax[0].plot_date(np.transpose(zp),t2m,'-')
ax[0].set_ylabel('Mean air temp at 2m / °C')
ax[0].grid()
ax[1].plot_date(np.transpose(zp),sd*1000,'-')
ax[1].set_ylabel('Snowdepth water equiv. /  mm')
ax[1].grid()
ax[2].plot_date(np.transpose(zp),sf*1000,'-')
ax[2].set_ylabel('Snowfall water equiv. /  mm')
ax[2].grid()

plt.show()