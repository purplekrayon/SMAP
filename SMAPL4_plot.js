// plots SMAP L4 3-hourly soil moisture over the last 90 days
//Last edited by Karyn Tabor 01/04/2023
var SMAPL4 = ee.ImageCollection("NASA/SMAP/SPL4SMGP/007_RAW")
var point = ee.Geometry.Point([-105.211389480038,41.288222095560215]);
Map.setCenter(-105.211389480038,41.288222095560215, 4);
Map.addLayer(point,
             {'color': 'black'},
             'Geometry [black]: point');
//getting today's date
var enddate = ee.Date(Date.now('UTC'));
print(enddate, "today's date");
//getting date 31 days ago
var startdate = enddate.advance(-90,"day");
print(startdate, "90 days ago");

// Load the input collection, filter by date, and select the soil moisture data.
var soilMoisture = SMAPL4.filter(ee.Filter.date(startdate,enddate)).select(['sm_surface','sm_rootzone']);
var soilMoistureVis = {
  min: 0.0,
  max: 0.8,
  palette: ['ff0303','efff07','418504', '0300ff','8006f3'],
};
Map.setCenter(-105.211389480038,41.288222095560215, 5);
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
          title: '3-hourly surface vs. root zone soil moisture',
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
