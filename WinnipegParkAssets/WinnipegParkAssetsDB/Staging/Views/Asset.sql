CREATE VIEW Staging.Asset AS
WITH Assets AS (
	SELECT  CONVERT(INT, asset_id)             AS [AssetId],
	        CONVERT(INT, park_id)              AS [ParkId],
			CONVERT(VARCHAR(100), asset_class) AS [Asset Class],
			CONVERT(VARCHAR(100), asset_type)  AS [Type],
			CONVERT(VARCHAR(100), asset_size)  AS [Size],
			CONVERT(DECIMAL(14,4), latitude)   AS [Latitude],
			CONVERT(DECIMAL(14,4), longitude)  AS [Longitude],
			GETDATE()                          AS [LastUpdated],
			SUSER_SNAME()                      AS [UpdatedBy]
	FROM raw.Asset
)
SELECT [AssetId],
	   [ParkId],
	   [Asset Class],
	   [Type],
	   [Size],
	   [Latitude],
	   [Longitude],
	   [LastUpdated],
	   [UpdatedBy],
	   [RowHash] = hashbytes('SHA2_512',
						CONCAT_WS('|',				         																				
							 [Asset Class] 
							,[Type]
							,[Size]     
							,[Latitude]
							,[Longitude]							
						)
					)
FROM Assets