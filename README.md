## Background 

Vector Tiles are utilised by a number of organisations due to the advantages related to storage space, speed and visualisation options.  For the majority of MapAction maps, the same layers are used but styled slightly differently, therefore being best suited to a vector tile format.  The aim of the project is to take advantage of the layers generated from the automation project and create a basemap that can be accessed in desktop GIS (Esri/QGIS) or web platforms (ArcGIS Online (AGOL)/open source).

A number of vector tile services already exist that MapAction could take advantage of, including the OSM tile service in AGOL which contains a lot of the required information already.  However, despite the obvious advantage of having access to the latest data and no required processing, some services contain a lot of information that is not required and it was therefore decided to concentrate on just those layers that MapAction need.  The vector tiles will contain data from just 22 layers that come from a range of sources.  

One of the key benefits of vector tiles is having the data stored once, but styled in multiple different ways, allowing the user to select a particular basemap, or a specific map element to be emphasised.  One of the main outputs of this project will be the development of a range of stylesheets based on specific themes.  This allows MapAction volunteers, other support teams or members of the public access to a range of data that can be styled based on their needs.

Having data already processed, styled and hosted brings benefits for volunteers in the field, especially in terms of not having to upload large datasets (e.g. road network) which can be timely and costly to publish and host.  For areas which may encounter low bandwidths, this will be extremely advantageous.  The ability to highlight where vector tiles will be hosted and how they will be accessed via different platforms will be a key consideration in the project.

## Current status

Below you will find information about our first attempt with static vector tiles, using a combination of Tippecanoe (tile creation), QGIS (styling), Mapbox (styling) and GeoServer (hosting).  The initial inspiration came from [this blog post](https://geovation.github.io/build-your-own-static-vector-tile-pipeline).  The example below produced mbtiles, with later research indicating that a directory of images may work better.  As we have begun to understand the process more, our attention has shifted to focus on dynamic vector tiles from PostgreSQL. 

## Focus

The main focus for this project includes:
- What is the best method for creating vector tiles? E.g. static/dynamic 
- Where is the best place to host the tiles? Can they be accessed by all the required platforms?
- Performance testing - what impacts useability e.g. size of layer, number of attributes etc
- Based on the chosen methodology, how would similar themed layers (e.g. administration boundaries) be grouped together? 

Creation of a number of stylesheets that allow a range of users to display the data how they wish (and access of these stylesheets by all platforms) 

## Initial Investigation

Hardware/software required:
- Ubuntu (set up on Windows)
- [Tippecanoe](https://github.com/mapbox/tippecanoe) (to generate tiles)

1. Convert all required shp into geojson format.  There are numerous ways this can be achieved (python, gdal etc) but FME is perfect for the task as it gives the user the opportunity to pick the exact layer they require (if numerous options exist e.g. from different sources) and which attributes are needed (and can be repeated quickly if changes are required).  Keeping file sizes down is essential for good performance and therefore it’s important to streamline the layers.  
2. Next up is generating the tiles in Tippecanoe.  There are many different settings that can be implemented based on requirements (full list can be found [here](https://github.com/mapbox/tippecanoe)) - we have only experimented with the very basic ones.  It is recommended to group similar types of data together to create a vector tile set e.g. admin layers, transport, physical.  The tiles can be checked in QGIS once produced (currently not viewable in ArcMap/Pro).
3. The key to vector tiles is styling and this can be achieved in [MapBox Studio](https://www.mapbox.com/mapbox-studio) (we would have preferred to use [Maputnik](https://maputnik.github.io/editor) but experienced problems with uploading the tiles).  The styling is advanced and covers all aspects from colours, line widths, zoom levels, labels etc allowing us to replicate ‘MapAction’ styles.  The stylesheet can then be downloaded and integrated into our own server alongside the tiles.  QGIS can also be used to create SLD styles that can be uploaded to GeoServer. 
4. The vector tiles and the SLD style sheets were published and tested in GeoServer.  

## Getting started

* Install docker & docker-compose
* Run `docker-compose build` from root of directory
* Run `docker-compose up` from root of directory
