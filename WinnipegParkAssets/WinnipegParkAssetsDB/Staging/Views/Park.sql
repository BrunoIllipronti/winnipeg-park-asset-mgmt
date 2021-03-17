CREATE VIEW Staging.Park AS
WITH Parks AS (
	SELECT  CONVERT(INT, park_id)                      AS [ParkId],
		    CONVERT(VARCHAR(100),park_name)            AS [Park],
		    CONVERT(VARCHAR(100),park_category)        AS [Category],
	        CONVERT(VARCHAR(100),location_description) AS [Address],
			CONVERT(VARCHAR(100),district)             AS [District],
			CONVERT(VARCHAR(100),neighbourhood)        AS [Neighbouthood],
			CONVERT(VARCHAR(100),electoral_ward)       AS [Electoral Ward],
			CONVERT(VARCHAR(100), cca)                 AS [Community Characterization Area],
			CONVERT(DECIMAL(14,4), area_in_hectares)   AS [Area (ha)],
			CONVERT(DECIMAL(14,4), latitude)           AS [Latitude],
			CONVERT(DECIMAL(14,4), longitude)          AS [Longitude],
			GETDATE()                                  AS [LastUpdated],
			SUSER_SNAME()                              AS [UpdatedBy]
	FROM raw.Park
)
SELECT [ParkId],
	   [Park],
	   [Category],
	   [Address],
	   [District],
	   [Neighbouthood],
	   [Electoral Ward],
	   [Community Characterization Area],
	   [Area (ha)],
	   [Latitude],
	   [Longitude],  
	   [LastUpdated],
	   [UpdatedBy],
	   [RowHash] = hashbytes('SHA2_512',
						CONCAT_WS('|',				         																											
							 [Park]
							,[Category]     
							,[Address]
							,[District]
							,[Neighbouthood]
							,[Electoral Ward]
							,[Community Characterization Area]
							,[Area (ha)]
							,[Latitude]
							,[Longitude]
						)
					)
FROM Parks