
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
