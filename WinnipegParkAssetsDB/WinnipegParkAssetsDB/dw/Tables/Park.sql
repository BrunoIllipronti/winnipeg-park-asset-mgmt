CREATE TABLE [dw].[Park] (
    [ParkKey]                         INT             IDENTITY (1, 1) NOT NULL,
    [ParkId]                          INT             NOT NULL,
    [Park]                            VARCHAR (100)   NULL,
    [Category]                        VARCHAR (100)   NULL,
    [Address]                         VARCHAR (100)   NULL,
    [District]                        VARCHAR (100)   NULL,
    [Neighbouthood]                   VARCHAR (100)   NULL,
    [Electoral Ward]                  VARCHAR (100)   NULL,
    [Community Characterization Area] VARCHAR (100)   NULL,
    [Area (ha)]                       DECIMAL (14, 4) NULL,
    [Latitude]                        DECIMAL (14, 4) NULL,
    [Longitude]                       DECIMAL (14, 4) NULL,
    [LastUpdated]                     DATETIME2 (7)   DEFAULT (getdate()) NULL,
    [UpdatedBy]                       VARCHAR (50)    DEFAULT (suser_sname()) NULL,
    [RowHash]                         AS              (hashbytes('SHA2_512',concat_ws('|',[Park],[Category],[Address],[District],[Neighbouthood],[Electoral Ward],[Community Characterization Area],[Area (ha)],[Latitude],[Longitude]))),
    PRIMARY KEY CLUSTERED ([ParkKey] ASC)
);

