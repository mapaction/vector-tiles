
-- WORKING
WITH
bounds AS (
--SELECT ST_Extent(yaar.geom)::geometry as geom FROM osm.osm.yem_admn_ad1_reproj yaar
SELECT ST_Extent(ST_Transform(geom, 3857))::geometry AS geom FROM osm.osm.bounding_box bb
),
mvtgeom AS (SELECT ST_AsMVTGeom(
	yaar.geom,
	bounds.geom,
	4096, 0, false) AS geom
	FROM osm.osm.yem_admn_ad1_reproj yaar, bounds
	)
SELECT * FROM mvtgeom

-- RM Edit v1: same as above but using new 3857 layer. This is now generating tiles but positioning them at Null Island (0,0)
WITH
bounds AS (
--SELECT ST_Extent(yaar.geom)::geometry as geom FROM osm.osm.yem_admn_ad1_reproj yaar
SELECT ST_Extent(ST_Transform(geom, 3857))::geometry AS geom FROM osm.osm.yeman_admin1_3857 bb
),
mvtgeom AS (SELECT ST_AsMVTGeom(
	yaar.geom,
	bounds.geom,
	3857, 0, false) AS geom
	FROM osm.osm.yeman_admin1_3857 yaar, bounds
	)
SELECT * FROM mvtgeom

-- RM Edit v2: Example from video: https://www.youtube.com/watch?v=t8eVmNwqh7M.
-- Running but returning odd results
WITH mvtgeom as (
	SELECT
		ST_AsMVTGeom(geom,
			ST_TileEnvelope(2,2,1)) as geom,
			adm1_en
	FROM osm.osm.yeman_admin1_3857
	WHERE ST_Intersects (
		geom,
		ST_TileEnvelope(2,2,1))
	)
SELECT ST_AsMVT(mvtgeom.*) AS mvt
FROM mvtgeom;

-- RM Edit v2.1
WITH mvtgeom as (
	SELECT
		st_transform(geom, 3857),
		ST_TileEnvelope(2,2,1)) AS geom,
		adm1_en
	FROM osm.osm.yeman_admin1_3857
	WHERE ST_Intersects (
		geom,
		st_transform(st_tileenvelope(2,2,1),3857))
	)
SELECT ST_AsMVT(mvtgeom.*) AS mvt
FROM mvtgeom;

-- RM Edit 3: from stack exchange - https://gis.stackexchange.com/questions/360197/using-st-asmvt-with-st-tileenvelope-clipping-in-mapbox/360259#360259
-- getting error message saying wkb_geometry does not exist
WITH webmercator(envelope) AS (
      SELECT ST_TileEnvelope(2, 2, 1)
    ),
    wgs84(envelope) AS (
      SELECT ST_Transform((SELECT envelope FROM webmercator), 3857)
    ),
    b(bounds) AS (
      SELECT ST_MakeEnvelope(41.5,10.7,54.9,20.4,3857)
    ),
    geometries(wkb_geometry) AS (
      SELECT
        CASE WHEN ST_Covers(b.bounds, wkb_geometry)
             THEN ST_Transform(wkb_geometry,3857)
             ELSE ST_Transform(ST_Intersection(b.bounds, wkb_geometry),3857)
             END
      FROM osm.osm.yem_admn_ad1_reproj
      CROSS JOIN b
      WHERE wkb_geometry && (SELECT envelope FROM wgs84)
    )
    SELECT ST_AsMVT(tile) as mvt FROM (
      SELECT  ST_AsMVTGeom(wkb_geometry, (SELECT envelope FROM webmercator))
      FROM geometries
    ) AS tile		 
