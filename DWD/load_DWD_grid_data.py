#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
 load data from DWD
 - grided data is downloaded in zipped files from opendata.dwd.de 
 - zipped files are unzipped in a seperate directory for ascii files and 
 - ascii files are converted and saved in the Numpy compressed binary format 
   to be used in other scripts
"""

import ftplib, gzip, glob, re
import numpy as np


# dimension of grids from header of ascii file
ncols = 654
nrows = 866

# url and folder on server
furl='opendata.dwd.de';
# gridded temperature in 2m height
# read the metadata! Temperature is saved as integer!
df='/climate_environment/CDC/grids_germany/annual/air_temperature_mean/';
# folder to save unzipped ascii files
outfolder='data_asc/'
# connect to server and get files
tf=ftplib.FTP(furl)
tf.login()
tf.cwd(df)
files=tf.nlst('*.asc.gz')
for dfile in files:
    ofile = "data/" + dfile
    tf.retrbinary("RETR " + dfile ,open(ofile, 'wb').write)
    with gzip.open(ofile, 'rb') as gzfile:
        with open(outfolder+dfile[0:-3], 'wb') as output_file:
            output_file.write(gzfile.read())
tf.close()
# convert to binary file for later use
allfiles=glob.glob('data_asc/*.asc')
zp=np.zeros(len(allfiles))
adata=np.zeros((nrows,ncols,len(allfiles)))
co = 0
for fname in allfiles:
    # temperature is saved with a resolution of 0.1°C as integer  
    tempmat = np.loadtxt(fname, skiprows= 6)/10
    # replave fill value with NaN for plotting
    ind = tempmat == -99.9
    tempmat[ind] = np.nan
    adata[:,:,co] = tempmat
    # timestamp
    substr=re.search('[1-2][0-9]{3}',fname)
    zp[co] = int(substr.group(0))
    co = co+1
    
# save data
np.savez_compressed('atmodata.npz',a=adata,b=zp)