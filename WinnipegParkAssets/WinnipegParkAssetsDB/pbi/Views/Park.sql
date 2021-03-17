CREATE VIEW pbi.Park AS
SELECT [ParkId]                         
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
FROM dw.Park