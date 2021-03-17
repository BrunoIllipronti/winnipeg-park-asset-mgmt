CREATE VIEW pbi.Asset AS
SELECT  [AssetId]    
	   ,[ParkId]     
	   ,[Asset Class]
	   ,[Type]       
	   ,[Size]       
	   ,[Latitude]   
	   ,[Longitude]  
FROM dw.Asset