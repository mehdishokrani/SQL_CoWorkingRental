
/*******************************************************************************
   CoWorkspace - Version 1.0
   Script: CoWorkspace.sql
   Description: Creates and populates the CoWorkspace database.
   DB Server: SqlServer
   Author: Mehdi Shokrani
********************************************************************************/

/*******************************************************************************
   Drop database if it exists
********************************************************************************/
IF EXISTS (SELECT name FROM master.dbo.sysdatabases WHERE name = N'CoWorkspace')
BEGIN
	ALTER DATABASE [CoWorkspace] SET OFFLINE WITH ROLLBACK IMMEDIATE;
	ALTER DATABASE [CoWorkspace] SET ONLINE;
	DROP DATABASE [CoWorkspace];
END

GO

/*******************************************************************************
   Create database
********************************************************************************/
CREATE DATABASE [CoWorkspace];
GO

USE [CoWorkspace];
GO

/*******************************************************************************
   Create Tables
********************************************************************************/
CREATE TABLE [dbo].[Users] (
    [UserID]    INT            IDENTITY (1, 1) NOT NULL,
    [FirstName] NVARCHAR (50)  NOT NULL,
    [LastName]  NVARCHAR (50)  NOT NULL,
    [Email]     NVARCHAR (100) NOT NULL,
    [Phone]     NVARCHAR (20)  NOT NULL,
    [Role]      NVARCHAR (10)  NOT NULL,
    PRIMARY KEY CLUSTERED ([UserID] ASC),
    CONSTRAINT [CHK_User_Role] CHECK ([Role]='Coworker' OR [Role]='Owner')
);
GO
CREATE TABLE [dbo].[Property] (
    [PropertyID]                INT            IDENTITY (1, 1) NOT NULL,
    [OwnerID]                   INT            NULL,
    [Address]                   NVARCHAR (255) NOT NULL,
    [Neighborhood]              NVARCHAR (100) NULL,
    [SquareFeet]                INT            NULL,
    [HasParking]                BIT            NULL,
    [PublicTransportAccessible] BIT            NULL,
    PRIMARY KEY CLUSTERED ([PropertyID] ASC),
    CONSTRAINT [FK_Property_OwnerID] FOREIGN KEY ([OwnerID]) REFERENCES [dbo].[Users] ([UserID])
);
GO
CREATE TABLE [dbo].[Workspace] (
    [WorkspaceID]      INT             IDENTITY (1, 1) NOT NULL,
    [PropertyID]       INT             NULL,
    [WorkspaceType]    NVARCHAR (50)   NULL,
    [SeatingCapacity]  INT             NULL,
    [IsSmokingAllowed] BIT             NULL,
    [AvailabilityDate] DATE            NULL,
    [LeaseTerm]        NVARCHAR (10)   NULL,
    [Price]            DECIMAL (10, 2) NULL,
    PRIMARY KEY CLUSTERED ([WorkspaceID] ASC),
    CONSTRAINT [CHK_Workspace_LeaseTerm] CHECK ([LeaseTerm]='month' OR [LeaseTerm]='week' OR [LeaseTerm]='day'),
    CONSTRAINT [CHK_Workspace_WorkspaceType] CHECK ([WorkspaceType]='Open Desk' OR [WorkspaceType]='Private Office' OR [WorkspaceType]='Meeting Room'),
    CONSTRAINT [FK_Workspace_PropertyID] FOREIGN KEY ([PropertyID]) REFERENCES [dbo].[Property] ([PropertyID])
);
GO
CREATE TABLE [dbo].[Booking] (
    [BookingID]   INT           IDENTITY (1, 1) NOT NULL,
    [WorkspaceID] INT           NULL,
    [CoworkerID]  INT           NULL,
    [StartDate]   DATE          NULL,
    [EndDate]     DATE          NULL,
    [Status]      NVARCHAR (50) NULL,
    PRIMARY KEY CLUSTERED ([BookingID] ASC),
    CONSTRAINT [CHK_Booking_Status] CHECK ([Status]='Cancelled' OR [Status]='Completed' OR [Status]='In Progress' OR [Status]='Booked'),
    CONSTRAINT [FK_Booking_CoworkerID] FOREIGN KEY ([CoworkerID]) REFERENCES [dbo].[Users] ([UserID]),
    CONSTRAINT [FK_Booking_WorkspaceID] FOREIGN KEY ([WorkspaceID]) REFERENCES [dbo].[Workspace] ([WorkspaceID])
);
GO
CREATE TABLE [dbo].[Review] (
    [ReviewID]    INT            IDENTITY (1, 1) NOT NULL,
    [WorkspaceID] INT            NULL,
    [CoworkerID]  INT            NULL,
    [Rating]      INT            NULL,
    [Comment]     NVARCHAR (255) NULL,
    PRIMARY KEY CLUSTERED ([ReviewID] ASC),
    CONSTRAINT [CHK_Review_Rating] CHECK ([Rating]>=(1) AND [Rating]<=(5)),
    CONSTRAINT [FK_Review_CoworkerID] FOREIGN KEY ([CoworkerID]) REFERENCES [dbo].[Users] ([UserID]),
    CONSTRAINT [FK_Review_WorkspaceID] FOREIGN KEY ([WorkspaceID]) REFERENCES [dbo].[Workspace] ([WorkspaceID])
);
GO

/*******************************************************************************
   Populate Tables
********************************************************************************/
-- Inserting 6 entries into User
INSERT INTO Users (FirstName, LastName, Email, Phone, Role)
VALUES
('Mehdi', 'Shokrani', 'mehdishokrani1@gmail.com', '5879689021', 'Owner'),
('Jane', 'Smith', 'jane.smith@example.com', '2345678901', 'Coworker'),
('Mark', 'Johnson', 'mark.johnson@example.com', '3456789012', 'Owner'),
('Sara', 'Williams', 'sara.williams@example.com', '4567890123', 'Coworker'),
('David', 'Jones', 'david.jones@example.com', '5678901234', 'Owner'),
('Emily', 'Brown', 'emily.brown@example.com', '6789012345', 'Coworker');

-- Inserting 6 entries into Property
INSERT INTO Property (OwnerID, Address, Neighborhood, SquareFeet, HasParking, PublicTransportAccessible)
VALUES
(1, '123 Main St', 'Downtown', 5000, 1, 1),
(1, '456 Broad St', 'Uptown', 3000, 0, 1),
(3, '789 Wall St', 'Midtown', 7000, 1, 0),
(3, '012 High St', 'Downtown', 4000, 1, 1),
(5, '345 Market St', 'Uptown', 3500, 0, 0),
(5, '678 King St', 'Midtown', 6000, 1, 1);

-- Inserting 6 entries into Workspace
INSERT INTO Workspace (PropertyID, WorkspaceType, SeatingCapacity, IsSmokingAllowed, AvailabilityDate, LeaseTerm, Price)
VALUES
(1, 'Meeting Room', 10, 0, '2023-06-15', 'day', 100.00),
(1, 'Private Office', 3, 0, '2023-07-01', 'week', 500.00),
(2, 'Open Desk', 20, 1, '2023-06-20', 'month', 1000.00),
(3, 'Meeting Room', 15, 0, '2023-07-10', 'day', 150.00),
(4, 'Private Office', 2, 0, '2023-08-01', 'week', 400.00),
(5, 'Open Desk', 30, 1, '2023-06-30', 'month', 1500.00);

-- Inserting 6 entries into Booking
INSERT INTO Booking (WorkspaceID, CoworkerID, StartDate, EndDate, Status)
VALUES
(1, 2, '2023-06-15', '2023-06-15', 'Booked'),
(1, 2, '2023-06-16', '2023-06-16', 'Booked'),
(2, 2, '2023-07-01', '2023-07-07', 'Booked'),
(3, 4, '2023-06-20', '2023-07-19', 'In Progress'),
(4, 4, '2023-07-10', '2023-07-10', 'Booked'),
(5, 6, '2023-08-01', '2023-08-07', 'Booked');

-- Inserting 6 entries into Review
INSERT INTO Review (WorkspaceID, CoworkerID, Rating, Comment)
VALUES
(1, 2, 4, 'Good meeting room with all facilities.'),
(1, 2, 5, 'Excellent service.'),
(2, 2, 3, 'Satisfactory private office space.'),
(3, 4, 4, 'Open desk was spacious and comfortable.'),
(4, 4, 2, 'Meeting room lacked basic facilities.'),
(5, 6, 5, 'Excellent private office, would book again.');

