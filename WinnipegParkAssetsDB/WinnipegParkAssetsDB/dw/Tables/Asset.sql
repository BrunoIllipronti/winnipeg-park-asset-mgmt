CREATE TABLE [dw].[Asset] (
    [AssetKey]    INT             IDENTITY (1, 1) NOT NULL,
    [AssetId]     INT             NOT NULL,
    [ParkId]      INT             NOT NULL,
    [Asset Class] VARCHAR (100)   NULL,
    [Type]        VARCHAR (100)   NULL,
    [Size]        VARCHAR (100)   NULL,
    [Latitude]    DECIMAL (14, 4) NULL,
    [Longitude]   DECIMAL (14, 4) NULL,
    [LastUpdated] DATETIME2 (7)   DEFAULT (getdate()) NULL,
    [UpdatedBy]   VARCHAR (50)    DEFAULT (suser_sname()) NULL,
    [RowHash]     AS              (hashbytes('SHA2_512',concat_ws('|',[ParkId],[Asset Class],[Type],[Size],[Latitude],[Longitude]))),
    PRIMARY KEY CLUSTERED ([AssetKey] ASC)
);

