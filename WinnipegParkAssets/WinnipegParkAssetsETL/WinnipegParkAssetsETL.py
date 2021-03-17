
# -*- coding: utf-8 -*-
"""
Created on Sat Mar 6 10:30:12 2021
This module extract Winnipeg Parks and Open Spaces data from the Open Data Portal API
@author: brunoi
"""

import requests
import pandas as pd
import sqlalchemy
from sqlalchemy import event, text

class DBOperations():
    """ Class to estabilish engine connection """
    def __init__(self):
        self.__driver = '{ODBC Driver 17 for SQL Server}'
        self.__server = 'opendatahackathon.database.windows.net'
        self.__db = 'datahackathon'
        self.__uid = 'opendata'
        self.__pwd = '##########'

    def initialize_db(self):
        """ Initialize DB engine """
        try:
            # Connect to Azure DB
            engine = sqlalchemy.create_engine(f'mssql://{self.__uid}:{self.__pwd}@{self.__server}/{self.__db}?Driver={self.__driver}?MARS_Connection=Yes')
    
            # Event Listener - Improve Insert Performance
            @event.listens_for(engine, 'before_cursor_execute')
            def receive_before_cursor_execute(conn, cursor, statement, params, context, executemany):
                if executemany:
                    cursor.fast_executemany = True
                    cursor.commit()                    
        except Exception as error:
            raise SystemExit(error)
        
        return engine
   
class ProcessOpenData():    
    """ Extracts data from Winnipeg Open Data portal and loads it to the Database """     

    def DataETL(api_list, engine):
        # Winnipeg Park and Open Spaces API call 
        parameters = { "$limit": 50000 }

        for api in api_list.values():            
            # Call Winnipeg Open Data API
            try:
                api_call = requests.get(api['url'], params=parameters)        
            except requests.exceptions.RequestException as e:
                raise SystemExit(e)
    
            # Store Request Results
            parks = api_call.json()
                
            # Convert JSON List results to Dataframe
            df = pd.DataFrame(parks)
                
            if api['has_location'] == True:
                # Extract Latitude and Longitude from Location Series column
                lat = []
                lon = []
                    
                for latlon in df['location']:
                    lat.append( latlon['latitude'] )
                    lon.append( latlon['longitude'] )                    
                
                # Add Lat/Lon columns to Dataframe and drop Location
                df = df.assign(latitude = lat)
                df = df.assign(longitude = lon)
                del df['location']            
                
            # Truncate Destination Table
            try:
                print('Run: ' + 'TRUNCATE TABLE raw.' + api['destination_table'])
                engine.execute(text('TRUNCATE TABLE raw.' + api['destination_table']).execution_options(autocommit=True))
            except Exception as error:
                print(error)
            
            # Insert into Database Table        
            try:
                print('Run: ' + 'LOAD DATA INTO ' + api['destination_table'])
                df.to_sql(api['destination_table'], engine, schema='raw', if_exists='append', index=False, chunksize=500)
            except Exception as error:
                print(error)
            
            # Run Merge Stored Procedure
            try:
                print('Run: ' + 'EXECUTE ' + api['merge_sproc'])
                engine.execute(text('EXECUTE ' + api['merge_sproc'] + ' 1').execution_options(autocommit=True))
            except Exception as error:
                print(error)

if __name__ == "__main__":     
    api_list = {0: {'url':'https://data.winnipeg.ca/resource/tx3d-pfxq.json', 'has_location':True, 'destination_table': 'Park', 'merge_sproc': 'Staging.MergePark'}, 
                1: {'url':'https://data.winnipeg.ca/resource/dk7c-zxyd.json', 'has_location':True, 'destination_table': 'Asset','merge_sproc': 'Staging.MergeAsset'} }
            
    engine = DBOperations().initialize_db()
    ProcessOpenData.DataETL(api_list, engine)
