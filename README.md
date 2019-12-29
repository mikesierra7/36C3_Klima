work in progress V.0.5.20191229

# 36C3_Klima
Support Material for the presentation 'Nutzung öffentlicher Klimadaten' given at 36C3, 27.-30. December 2019, Leipzig, Germany.

Links to publications/websites from the talk
--------------------------------------------
* [Zeit online 10. December 2019 "Viel zu warm hier"](https://www.zeit.de/wissen/umwelt/2019-12/klimawandel-globale-erwaermung-warming-stripes-wohnort)
* [Warming stripes globally](https://showyourstripes.info) and related [data repository](http://berkeleyearth.org)

Links to data providers
-----------------------
**Deutscher Wetterdienst (DWD)**
* [DWD main site](https://www.dwd.de)
* [Climate Data Center FTP access](https://opendata.dwd.de) to ascii formated time series and gridded products
* [Climate Data Center Portal](https://www.dwd.de/DE/leistungen/cdc_portal/cdc_portal.html) interactive data access tool

**European Center for medium-range weather forecasts (ECMWF)**
* [ECMWF main site](https://www.ecmwf.int)
* [Data catalogue](https://www.ecmwf.int/en/forecasts/datasets/browse-reanalysis-datasets) of reanalysis datasets. Latest reanalysis is at CDS (see below).

**Copernicus**
* [Copernicus EU-Program main site](https://www.copernicus.eu)
* [Copernicus Climate Change Service](https://cds.climate.copernicus.eu) for access to data catalogue, CDS api and online toolbox

**NASA**
* [EOSDIS](https://earthdata.nasa.gov/eosdis) Earth Observing System Data and Information System, provides access to datasets to the different Distributed Active Archive Centers (DAAC)
* [Worldview](https://worldview.earthdata.nasa.gov/) visualizes satellite observations and provides data download ([Source on GitHub](https://github.com/nasa-gibs/worldview))

Software
========
This is a collection of scripts in MATLAB and Python for the retrieval, analysis and visualization of data from *DWD* and *ECMWF* repositories. The scripts are sorted into directories according to the service. No additional Software is provided for *NASA* services. Running the MATLAB scripts in Octave requires the mapping and NetCDF packages.

DWD
---
The scripts download, unzip and plot time series and gridded data. Documentation is not downloaded and can be found in the same directory as the data on [opendata.dwd.de](https://opendata.dwd.de).
* **load_DWD_grid_data.m** downloads the annual mean temperatures for Germany from 1881 to 2018. Files are unzipped and converted to the binary MATLAB format. These are used in scripts for plotting the data.
* **ani_DWD_grid.m** display all years and save to animated gif.
* **streifen_DWD_grid.m** calculate warming stripes for arbitrary positions within DWD gridded dataset
ECMWF
* **timeseries_DWD.m** download station descriptions, plot of map and download time series of Potsdam air temperature
* **data**-folder contains necessary colormaps and a file of geographical coordinates to be used instead of the Gauß-Grüger coordinates in the DWD data files.

ECMWF
----
The ERA5 data is hosted at the Copernicus Climate Data Store (CDS), which provides access via a [python api](https://cds.climate.copernicus.eu/api-how-to). Alternatively data can be searched and downloaded in the data catalogue website.
* **ERA5_snow.py** load snow related data for example MATLAB script.
* **load_CDS_ERA5_data.py** download different 2d and 3D datasets.
