CREATE PROC staging.MergeAsset (@TaskKey INT) 
AS

MERGE dw.Asset trg
	USING Staging.Asset src
	ON trg.[AssetId] = src.[AssetId]

WHEN NOT MATCHED BY TARGET THEN
	INSERT (
		 [AssetId]    
		,[ParkId]	
		,[Asset Class]
		,[Type]		
		,[Size]		
		,[Latitude]	
		,[Longitude]	
		,[LastUpdated]
		,[UpdatedBy]	
		)
	VALUES (
		 [AssetId]    
		,[ParkId]	
		,[Asset Class]
		,[Type]		
		,[Size]		
		,[Latitude]	
		,[Longitude]	
		,[LastUpdated]
		,[UpdatedBy]	
	)

	WHEN MATCHED AND trg.RowHash <> src.RowHash THEN
	UPDATE SET
		 [AssetId]     = src.[AssetId]    
		,[ParkId]	   = src.[ParkId]	
		,[Asset Class] = src.[Asset Class]
		,[Type]		   = src.[Type]		
		,[Size]		   = src.[Size]		
		,[Latitude]	   = src.[Latitude]	
		,[Longitude]   = src.[Longitude]	
		,[LastUpdated] = src.[LastUpdated]
		,[UpdatedBy]   = src.[UpdatedBy]	
	;