CREATE PROC staging.MergePark (@TaskKey INT) 
AS

MERGE dw.Park trg
	USING Staging.Park src
	ON trg.[ParkId] = src.[ParkId]

WHEN NOT MATCHED BY TARGET THEN
	INSERT (
		 [ParkId]                         
		,[Park]							  
		,[Category]						  
		,[Address]						  
		,[District]						  
		,[Neighbouthood]				  
		,[Electoral Ward]				  
		,[Community Characterization Area]
		,[Area (ha)]					  
		,[Latitude]						  
		,[Longitude]					  
		,[LastUpdated]                    
		,[UpdatedBy]					  
		)
	VALUES (
		 [ParkId]                         
		,[Park]							  
		,[Category]						  
		,[Address]						  
		,[District]						  
		,[Neighbouthood]				  
		,[Electoral Ward]				  
		,[Community Characterization Area]
		,[Area (ha)]					  
		,[Latitude]						  
		,[Longitude]					  
		,[LastUpdated]                    
		,[UpdatedBy]					  
	)

	when matched and trg.RowHash <> src.RowHash then 
	update set
		 [Park]							   = src.[Park]							  
		,[Category]						   = src.[Category]						  
		,[Address]						   = src.[Address]						  
		,[District]						   = src.[District]						  
		,[Neighbouthood]				   = src.[Neighbouthood]				  
		,[Electoral Ward]				   = src.[Electoral Ward]				  
		,[Community Characterization Area] = src.[Community Characterization Area]
		,[Area (ha)]					   = src.[Area (ha)]					  
		,[Latitude]						   = src.[Latitude]						  
		,[Longitude]					   = src.[Longitude]					  
		,[LastUpdated]                     = src.[LastUpdated]                    
		,[UpdatedBy]					   = src.[UpdatedBy]					  
	;