---
title: Introduction to SMAP
description: Learn how to visualize and analyze SMAP soil moisture data.
author: purplekrayon
tags: SMAP, soil, moisture, plot, time series, anomalies, water applications
date_published: 2023-04-04
---
<!--
Copyright 2023 The Google Earth Engine Community Authors

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

    https://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
-->
<img src="https://scontent-atl3-1.xx.fbcdn.net/v/t39.30808-6/278842550_300195778957924_8093208601931649083_n.png?_nc_cat=108&ccb=1-7&_nc_sid=e3f864&_nc_ohc=j81nUaBLNkIAX9ep93I&_nc_ht=scontent-atl3-1.xx&oh=00_AfAD1KUqM47GwXtUiS_Btc-KzTG10db2bfv2-jhNBrPBlQ&oe=6434DB2C" >
The thematic focus is learning about the SMAP instrument for applications water resources management applications.

The learning objectives of this tutorial are:
- understand how SMAP measures soil moisture from space
- know which SMAP products are available in GEE catalog and the differences between the products
- know how to import SMAP products into the code editor
- visualize SMAP by adding visualization parameters
- plot a time series of SMAP soil moisture for a point geometry

After completing this tutorial, you will be able to choose the optimal SMAP product for your analysis/applicaiton. And you will be able to import, vizualize, and analyze a time series of SMAP soil moisture data in Google Earth Engine.

## Soil Mositure Active Passive (SMAP)

### Mission objective
    
- The SMAP mission is an orbiting observatory that measures the amount of water in the surface soil everywhere on Earth. The prime mission phase of three years was completed in 2018, and since then SMAP has been in extended operation phase.

### Instrument description

- SMAP was launched in January 2015 and started operation in April 2015. The radar instrument, ceasing operation in early 2015 due to failure of radar power supply, collected close to 3 months of science data. The passive radiometer collects daily data at 6 am (descending) and 6 pm (ascending) for complete global coverage every 2-3 days. The radiometer specifications are described in the table below.
 
 
        | Frequency | Polarization           | Resolution                    | Relative accuracy |
        |-----------|------------------------|-------------------------------|-------------------|
        | 1.41 Ghz  | H, V, 3rd & 4th Stokes | 36-km orignial, 9-km enhanced | 1.3 K             |

[![Animation that shows how SMAP gathers data](https://smap.jpl.nasa.gov/rails/active_storage/blobs/eyJfcmFpbHMiOnsibWVzc2FnZSI6IkJBaHBVUT09IiwiZXhwIjpudWxsLCJwdXIiOiJibG9iX2lkIn19--e1ff707053f56355e399a893f09a179cab86e66d/SMAP_Animation_Gathering_Data_large.jpg?disposition=attachment)](https://www.youtube.com/watch?v=GAilsFVPmP4)
        
Click on the image above to watch an animation on how SMAP gathers data. [https://youtu.be/GAilsFVPmP4](https://youtu.be/GAilsFVPmP4)

### Passive Microwave Concepts

### What does SMAP measure?

- SMAP measures soil moisture, every 2-3 days. This permits changes, around the world, to be observed over time scales ranging from major storms to repeated measurements of changes over the seasons.
- SMAP measures how much water is in the top layer of soil everywhere on Earth not covered with water or not frozen. It also distinguishes between ground that is frozen or thawed. 
- Where the ground is not frozen, SMAP measures the amount of water found between the minerals, rocky material, and organic particles found in soil everywhere in the world (SMAP measures liquid water in the top layer of ground but is not able to measure the ice.)


## SMAP products in GEE

There are three different SMAP products availailable in the catalog.


1.  [SPL3SMP_E.005 Level 3 product](NASA_SMAP_SPL3SMP_E_005) 
    - This Level-3 (L3) soil moisture product provides a daily composite of global land surface conditions retrieved by the Soil Moisture Active Passive (SMAP) L-Band radiometer. The daily data here were collected from the descending (local solar time of 6 am) and ascending (local solar time of 6 pm) passes.
        | temporal resolution | gridded resolutions | availability                   |
        |---------------------|---------------------|--------------------------------|
        | daily               | 9 km                | March 31, 2015 - present       |
    - Data outages: June 19-July 23, 2019; September 20-October 6th, 2022

2.  [SPL4SMGP.007 Level 4 product](NASA_SMAP_SPL4SMGP_007)
    - The SMAP Level-4 (L4) Soil Moisture product includes surface soil moisture (0-5 cm vertical average), root-zone soil moisture (0-100 cm vertical average), and additional research products (not validated), including surface meteorological forcing variables, soil temperature, evapotranspiration, and net radiation.
        | temporal resolution | gridded resolutions | availability                   |
        |---------------------|---------------------|--------------------------------|
        | daily               | 11 km               | March 31, 2015 - present       |
    - SMAP L4 provides uninterrupted soil moisture data.  During outages of the SMAP instrument, SMAP L4 soil moisture is based on land model simulations alone, without the concomitant assimilation of SMAP brightness temperature observations.  Significant SMAP instrument outages occurred between 19 June and 23 July 2019 and between 6 August and 20 September 2022.

3.  [NASA-USDA Enhanced SMAP](NASA_USDA_HSL_SMAP10KM_soil_moisture)
    - The NASA-USDA Enhanced SMAP global soil moisture data provides soil moisture information across the globe at 10-km spatial resolution. This dataset includes: surface and subsurface soil moisture (mm), soil moisture profile (%), as well as surface and subsurface soil moisture anomalies (-).
    - The dataset is generated by integrating satellite-derived Soil Moisture Active Passive (SMAP) Level 2 soil moisture observations into the modified two-layer Palmer model using a 1-D Ensemble Kalman Filter (EnKF) data assimilation approach. Soil moisture anomalies were computed from the climatology of the day of interest. The climatology was estimated based on the full data record of the SMAP satellite observation and the 31-day-centered moving-window approach. The assimilation of the SMAP soil moisture observations help improve the model-based soil moisture predictions particularly over poorly instrumented areas of the world that lack good quality precipitation data.
    - This dataset was developed by the Hydrological Science Laboratory at NASA's Goddard Space Flight Center in cooperation with USDA Foreign Agricultural Services and USDA Hydrology and Remote Sensing Lab. 
    
        | temporal resolution | gridded resolutions | availability                   |
        |---------------------|---------------------|--------------------------------|
        | daily               | 10 km               | April 2, 2015 - August 2, 2022 | 
     - As of August 2022, the NASA-USDA Enhanced SMAP Global soil moisture product has been discontinued. 

The table below describes the surface soil moisture, root-zone soil moisture, and soil moisture anonaly bands available with each product.

Band description                 | [NASA-USDA Enhanced SMAP](NASA_USDA_HSL_SMAP10KM_soil_moisture) | [SPL4SMGP.007](NASA_SMAP_SPL4SMGP_007) | [SPL3SMP_E.005](NASA_SMAP_SPL3SMP_E_005)               |
|----------------------------------|-----------------------------------------------------------------|----------------------------------------|--------------------------------------------------------|
| Surface soil moisture            | ssm                                                             | sm_surface                             | soil_moisture_am,<br> soil_moisture_pm                 |
| Subsurface soil moisture         | susm                                                            | sm_rootzone                            | NA                                                     |
| Soil moisture profile            | smp                                                             | sm_profile                             | sm_profile                                             |
| Surface soil moisture anomaly    | ssma                                                            | sm_surface_anomaly                     | soil_moisture_am_anomaly,<br> soil_moisture_pm_anomaly |
| Subsurface soil moisture anomaly | susma                                                           | NA                                     | NA                                                     |

## Visualizing SMAP

In this section, you will learn ways to visualize SMAP in GEE based on your level of experience with the code editor.

### EASY
This first option does not require coding expertise. You can access the [SMAP visualization application (beta)](https://krayon.users.earthengine.app/view/soil-moisture-active-passive-smap) 

### BEGINNER

```js
// This code selects the Soil Moisture AM band from L3 SMAP Global soil moisture data 
```

### INTERMEDIATE

```js
// This code selects the Soil Moisture AM band from L3 SMAP Global soil moisture data 
// 1) masks the data with the retrieval quality flag.
// 2) computes a mean image from multiple images in a series 

//Import county polygons by ISO code
//This example uses Tanzania
var iso_code ='TZA'
var country = ee.FeatureCollection("USDOS/LSIB/2013").filter(ee.Filter.eq('iso_alpha3', iso_code));
var SMAPL3 = ee.ImageCollection(ee.ImageCollection("NASA/SMAP/SPL3SMP_E/005"))
print(SMAPL3)
//select 1 month of SMAP images to create mean composite
var dataset = SMAPL3.filter(ee.Filter.date('2022-07-01','2022-07-31'));
var soilMoisture = dataset.select('soil_moisture_am');
//set vizualization parameters for median image
var soilMoistureVis = {
  min: 0.0,
  max: 0.6,
  //palette: ['ff0303','efff07','8DD7BF' ,'00B0BA','0065A2'],
  palette: ['fC6238','FFEC59','8DD7BF' ,'00B0BA','0065A2'],
};
Map.setCenter(25, -10.00, 4);
//select AM soil moisture
var soilmoisture_am = dataset.select('soil_moisture_am').toBands();
var SM_MEAN = soilmoisture_am.reduce(ee.Reducer.mean());
//select QA values
var soilmoisture_am_qamask = dataset.select('retrieval_qual_flag_am').toBands();
//invert QA values to create mask
var QA_mask = soilmoisture_am_qamask.eq(0);  
//add QA mask to soil moisture
var SM_masked = soilmoisture_am.updateMask(QA_mask);
//reduce image stack to single image with median reducer
var SM_masked_MEAN = SM_masked.reduce(ee.Reducer.mean());
//Visualize Soil Moisture (cm3/cm3)*1000
Map.addLayer(SM_masked_MEAN, soilMoistureVis, 'Soil Mean Moisture Masked');
Map.addLayer(SM_MEAN, soilMoistureVis, 'Soil Mean Moisture');
//select this option to clip map to Tanzania
//Map.addLayer(SM_median.clip(country), soilMoistureVis, 'Soil Moisture Mean');

// Export with maps Mercator projection at 10 km scale.
var exportParams = {scale: 10000, region: country, crs: 'EPSG:3857'};
//create export task and go to Tasks tab to run
Export.image(SM_masked_MEAN, 'SM_MaskedJuly2022MEAN_TZA', exportParams);


// Export with maps Mercator projection at 10 km scale.
var exportParams = {scale: 10000, crs: 'EPSG:3857'};
//create export task and go to Tasks tab to run
Export.image(SM_MEAN, 'SM_July2022MEAN', exportParams);
```
## Plotting a time series of daily soil moisture

Use separate sections for related, but discrete, groups of steps.

Use code blocks to show users how to do something after describing it:

```js
// plots SMAP L4 version 7, 3-hourly soil moisture over user-determined time period
//Last edited by Karyn Tabor 01/10/2023
var SMAPL4 = ee.ImageCollection("NASA/SMAP/SPL4SMGP/007_RAW")
var point = ee.Geometry.Point([ -97.808804,34.975981,]);
Map.setCenter(-97.808804,34.975981,  7);
Map.addLayer(point,
             {'color': 'black'},
             'Geometry [black]: point');

//user input: set timeframe (June-July-August)
var startdate = ('2022-06-01');
var enddate = ('2022-08-31')

// Load the input collection, filter by date, and select the soil moisture data.
var soilMoisture = SMAPL4.filter(ee.Filter.date(startdate,enddate)).select(['sm_surface','sm_rootzone']);

var soilMoistureVis = {
  min: 0.0,
  max: 0.7,
  palette: ['a67c00', 'FFE625', 'C2E5D3','90DCD0', '2FBDBD','0C9BBD','068682'],
  //palette: ['ff0303','efff07','418504', '0300ff','8006f3'],
};

var soilMoisture1 = soilMoisture.filter(ee.Filter.date(enddate, enddate)).select(['sm_surface']);
var soilMoisture_oneday = soilMoisture1.reduce(ee.Reducer.mean());
Map.addLayer(soilMoisture.select('sm_surface'), soilMoistureVis, 'Soil Moisture');
Map.addLayer(point,
             {'color': 'black'},
             'Geometry [black]: point');
// Define the chart and print it to the console.
var chart =
    ui.Chart.image
        .series({
          imageCollection: soilMoisture,
          region: point,
          reducer: ee.Reducer.mean(),
          scale: 10000,
          xProperty: 'system:time_start'
        })
        .setSeriesNames(['root zone soil moisture', 'surface soil moisture'])
        .setOptions({
          title: 'SMAP L4 version 7, 3-hourly surface and root zone soil moisture (34.975981 N, 97.808804 W)',
          hAxis: {title: 'Date', titleTextStyle: {italic: false, bold: true}},
          vAxis: {
            title: 'Soil Moisture cm3/cm3',
            titleTextStyle: {italic: false, bold: true}
          },
          lineWidth: 5,
          colors: ['4F7942', 'C7EA46'],
          curveType: 'function'
        });
print(chart);
```
## Calculating weekly soil moisture anomalies

Use separate sections for related, but discrete, groups of steps.

Use code blocks to show users how to do something after describing it:

```js
// Use comments to describe details that can't be easily expressed in code.
// Always try making code more self descriptive before adding a comment.
// Similarly, avoid repeating verbatim what's already said in code
// (e.g., "assign ImageCollection to variable 'coll'").
var coll = ee.ImageCollection('LANDSAT/LC08/C01/T1_TOA');
```
## Advanced tutorial

Use separate sections for related, but discrete, groups of steps.

Use code blocks to show users how to do something after describing it:

```js
// Use comments to describe details that can't be easily expressed in code.
// Always try making code more self descriptive before adding a comment.
// Similarly, avoid repeating verbatim what's already said in code
// (e.g., "assign ImageCollection to variable 'coll'").
var coll = ee.ImageCollection('LANDSAT/LC08/C01/T1_TOA');
```
### Use subsections if appropriate

Consider breaking longer sections that cover multiple topics or span multiple
pages into subsections.
