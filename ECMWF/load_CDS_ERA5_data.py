# 
# ERA5 Modellevels require long time for retrieval, use prtessure levels insted
# - native spatial resolution 0.25x0.25 degree 
# - hourly temporal resolution
#!/usr/bin/env python
import cdsapi
import calendar

# load surface data
atmo_surface = False
# load 3D Daten 
atmo_3dpl      = False # pressure levels
atmo_3dml      = True # auf model levels
# Region 
# Optional. Subset (clip) to an area. Specify as N/W/S/E in Geographic lat/long degrees. 
# Southern latitudes and western longitudes must be given as negative numbers. Requires "grid" to be set to a regular grid, e.g. "0.3/0.3".
# bei PL und surface heisst es area bei ML region
region = [64, -6, 42, 25] # Hannover+10Grad 

# hier fuer PL
#region = "70/-7/39/31", # Europa
#region = "55/5/47/15", # Germany 
# Year
year = 2018 
year_str = str(year)
# Month
month = 11 
month_str = "%02d" %(month)
# Number of days in month
numberOfDays = calendar.monthrange(year, month)[1]
# List of days for retrieval
daystart = 1
dayend = numberOfDays 
zeitraum = (list(map(str,range(daystart,dayend+1))))
# Combination of variables for time strings
startDate = '%04d%02d%02d' % (year, month, daystart)
lastDate = '%04d%02d%02d' % (year, month, dayend)
# Output filenames
target_s = "ERA5_%04d%02d%02d_surface.nc" % (year, month, daystart)
target_3dpl = "ERA5pl_%04d%02d%02d_europe_3d.nc" % (year, month, daystart)
target_3dml = "ERA5ml_%04d%02d%02d_europe_3d.nc" % (year, month, daystart)
requestDates = (startDate + "/TO/" + lastDate)
# API Aufruf
c = cdsapi.Client()
# surface daten
if atmo_surface:
    c.retrieve('reanalysis-era5-single-levels',{
        'product_type':'reanalysis',
        'format':'netcdf',
        'variable':[
            '2m_temperature','mean_sea_level_pressure','surface_pressure'
        ],
        'year': year_str,
        'month': month_str,
        'day':zeitraum,
        'time':[
            '00:00','01:00','02:00',
            '03:00','04:00','05:00',
            '06:00','07:00','08:00',
            '09:00','10:00','11:00',
            '12:00','13:00','14:00',
            '15:00','16:00','17:00',
            '18:00','19:00','20:00',
            '21:00','22:00','23:00'
        ]},
		target_s  # Zeitraum in Namen einfuegen
    )
# 3d daten fuer europa auf Luftdruckleveln
if atmo_3dpl:
    c.retrieve('reanalysis-era5-pressure-levels',{
        'product_type':'reanalysis',
        'format':'netcdf',
        'pressure_level':[
            '1','2','3',
            '5','7','10',
            '20','30','50',
            '70','100','125',
            '150','175','200',
            '225','250','300',
            '350','400','450',
            '500','550','600',
            '650','700','750',
            '775','800','825',
            '850','875','900',
            '925','950','975',
            '1000'
        ],
        'variable':[
            'geopotential','relative_humidity','temperature'
        ],
        'area': region,
        'time':[
            '00:00','01:00','02:00',
            '03:00','04:00','05:00',
            '06:00','07:00','08:00',
            '09:00','10:00','11:00',
            '12:00','13:00','14:00',
            '15:00','16:00','17:00',
            '18:00','19:00','20:00',
            '21:00','22:00','23:00'
        ],
        'year': year_str,
        'day': zeitraum,
        'month': month_str
		}, target_3dpl
    )
# 3d daten fuer europa auf Modelleveln
# "dataset": "era5",
# "time": "00:00:00/01:00:00/02:00:00/03:00:00/04:00:00/05:00:00/06:00:00/07:00:00/08:00:00/09:00:00/10:00:00/11:00:00/12:00:00/13:00:00/14:00:00/15:00:00/16:00:00/17:00:00/18:00:00/19:00:00/20:00:00/21:00:00/22:00:00/23:00:00",
# "levelist": "1/2/3/4/5/6/7/8/9/10/11/12/13/14/15/16/17/18/19/20/21/22/23/24/25/26/27/28/29/30/31/32/33/34/35/36/37/38/39/40/41/42/43/44/45/46/47/48/49/50/51/52/53/54/55/56/57/58/59/60/61/62/63/64/65/66/67/68/69/70/71/72/73/74/75/76/77/78/79/80/81/82/83/84/85/86/87/88/89/90/91/92/93/94/95/96/97/98/99/100/101/102/103/104/105/106/107/108/109/110/111/112/113/114/115/116/117/118/119/120/121/122/123/124/125/126/127/128/129/130/131/132/133/134/135/136/137",

if atmo_3dml:
    c.retrieve('reanalysis-era5-complete',{
        "class": "ea",
        "date": requestDates,
        "expver": "1",
        "levtype": "ml",
        "levelist": "1/to/137",
        "param": "129/130/133/152",  #129:Geopotential 130:Temp 133:specific Humidity 151:Log Surf Press
        "stream": "oper",
        "time": "00/to/23/by/1",
        "type": "an",
        "grid": "0.25/0.25",
        "area": region, #"73.5/-27/33/45", # Europa
        "format": "netcdf"},
        target_3dml
		)