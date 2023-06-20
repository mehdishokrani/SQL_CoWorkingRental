/* 1- As a user, I can sign up for an account and provide my information (name, phone, and email). 
I can give my role as an owner or a coworker as option. */
INSERT INTO Users (FirstName, LastName, Email, Phone, Role)
VALUES ('John', 'Doe', 'john.doe@email.com', '1234567890', 'Owner'); 
-- Inserting a new user with the provided information (John Doe) and assigning the role as 'Owner'


/* 2- As an owner, I can list a property with its address, neighborhood, square feet, 
whether it has a parking garage, and whether it is reachable by public transportation. */
INSERT INTO Property (OwnerID, Address, Neighborhood, SquareFeet, HasParking, PublicTransportAccessible)
SELECT UserID, '012 High St', 'Downtown', 2800, 1, 1
FROM Users
WHERE UserID = 7 AND Role = 'Owner'; 
-- Inserting a new property with the specified details (Address, Neighborhood, SquareFeet, HasParking, PublicTransportAccessible) for the owner with UserID 7 and Role 'Owner'


/* 3- As an owner, I can select one of my properties and list workspaces for rent. Workspaces could be meeting rooms, private office rooms, 
or desks in an open work area. For each workspace, I can specify how many individuals it can seat, 
whether smoking is allowed or not, availability date, lease term (day, week, or month), and price. */
INSERT INTO Workspace (PropertyID, WorkspaceType, SeatingCapacity, IsSmokingAllowed, AvailabilityDate, LeaseTerm, Price)
SELECT 6, 'Meeting Room', 11, 0, '2023-07-01', 'Month', 900
FROM Users
WHERE UserID = (SELECT OwnerID FROM Property WHERE PropertyID = 1) AND Role = 'Owner';
-- Inserting a new workspace with the specified details (PropertyID, WorkspaceType, SeatingCapacity, IsSmokingAllowed, AvailabilityDate, LeaseTerm, Price)
-- The PropertyID 6 is selected for the workspace, which is owned by the owner with UserID retrieved from the Property table where PropertyID is 1
-- The owner's UserID and Role should be 'Owner' for the query to insert the workspace


/* 4- As an owner, I can modify the data for any of my properties or any of my workspaces. */
UPDATE Property
SET SquareFeet = 5600
WHERE PropertyID = 1
-- Updating the SquareFeet value to 5600 for the property with PropertyID 1
UPDATE Workspace
SET LeaseTerm = 'Week'
WHERE WorkspaceID = 6
-- Updating the LeaseTerm value to 'Week' for the workspace with WorkspaceID 6


/* 5- As an owner, I can delist or remove any of my properties or any of my workspaces from the database. */
DELETE FROM Workspace WHERE WorkspaceID = 1;
-- Deleting the workspace with WorkspaceID 1 from the Workspace table
DELETE FROM Property WHERE PropertyID = 1;
-- Deleting the property with PropertyID 1 from the Property table


/* 6- As a coworker, I can search for workspaces by address, neighborhood, square feet, 
with/without parking, with/without public transportation, number of individuals it can seat, 
with/without smoking, availability date, lease term, or price. */
SELECT * FROM Workspace
JOIN Property ON Workspace.PropertyID = Property.PropertyID
WHERE Property.Address = '456 Broad St' 
AND Property.Neighborhood = 'Uptown' 
AND Property.SquareFeet >= 2000 
AND Property.HasParking = 0
AND Property.PublicTransportAccessible = 1
AND Workspace.SeatingCapacity >= 15 
AND Workspace.IsSmokingAllowed = 1 
AND Workspace.AvailabilityDate <= '2023-07-01' 
AND Workspace.LeaseTerm = 'month' 
AND Workspace.Price <= 1500;
-- Retrieving all columns from the Workspace table by joining it with the Property table
-- Applying various conditions to filter the results:
-- - Property.Address should be '456 Broad St'
-- - Property.Neighborhood should be 'Uptown'
-- - Property.SquareFeet should be greater than or equal to 2000
-- - Property.HasParking should be 0 (No parking)
-- - Property.PublicTransportAccessible should be 1 (Accessible by public transportation)
-- - Workspace.SeatingCapacity should be greater than or equal to 15
-- - Workspace.IsSmokingAllowed should be 1 (Smoking allowed)
-- - Workspace.AvailabilityDate should be on or before '2023-07-01'
-- - Workspace.LeaseTerm should be 'Month'
-- - Workspace.Price should be less than or equal to 1500


/* 7- As a coworker, I can select a workspace and view its details. */
SELECT * FROM Workspace WHERE WorkspaceID = 1;
-- Retrieving all columns from the Workspace table where WorkspaceID is 1
SELECT * FROM Workspace WHERE LeaseTerm = 'Month';
-- Retrieving all columns from the Workspace table where LeaseTerm is 'Month'


/* 8- As a coworker, I can get the contact information of a workspace’s owner. */
SELECT Users.FirstName, Users.LastName, Users.Email, Users.Phone 
FROM Users 
JOIN Property ON Users.UserID = Property.OwnerID 
JOIN Workspace ON Property.PropertyID = Workspace.PropertyID 
WHERE Workspace.WorkspaceID = 3;
-- Retrieving the FirstName, LastName, Email, and Phone columns from the Users table
-- Joining the Users table with the Property table on UserID = OwnerID
-- Joining the Property table with the Workspace table on PropertyID
-- Applying the condition Workspace.WorkspaceID = 3 to filter the results


/* 9- As an owner, I want to see the occupancy rate of my workspaces.
This allows the owner to gauge how well their workspaces are doing. */
-- Replace 1 with the any UserID of the owner
SELECT Workspace.WorkspaceID, COUNT(Booking.WorkspaceID) AS NumberOfBookings 
FROM Workspace 
JOIN Property ON Workspace.PropertyID = Property.PropertyID 
LEFT JOIN Booking ON Workspace.WorkspaceID = Booking.WorkspaceID 
WHERE Property.OwnerID = 1 
GROUP BY Workspace.WorkspaceID;


/* 10- As a coworker, I want to see all my bookings within a specific date range.
This allows the coworkers to plan and review their bookings. */
SELECT * FROM Booking 
WHERE CoworkerID = 2 AND StartDate >= '2023-06-01' AND EndDate <= '2023-06-30';
-- Retrieving the WorkspaceID column from the Workspace table and the count of Booking.WorkspaceID as NumberOfBookings
-- Joining the Workspace table with the Property table on PropertyID
-- Performing a left join with the Booking table on Workspace.WorkspaceID = Booking.WorkspaceID
-- Applying the condition Property.OwnerID = 1 to filter workspaces belonging to the owner with OwnerID 1
-- Grouping the results by Workspace.WorkspaceID to count the number of bookings for each workspace


/* 11- As a coworker, I want to find all workspaces available on a specific date.
This will help coworkers plan their schedule accordingly. */
SELECT * FROM Workspace 
WHERE AvailabilityDate <= '2023-06-30';
-- Retrieving all columns from the Workspace table where the AvailabilityDate is on or before '2023-06-30'


/* 12- As a coworker, I want to see all available workspaces in a specific price range.
This allows the coworkers to find workspaces that fit within their budget. */
SELECT * FROM Workspace 
WHERE Price BETWEEN 100 AND 400;
-- Retrieving all columns from the Workspace table where the Price is between 100 and 400 (inclusive)


/* 13- As an owner, I want to see all the reviews of my workspaces.
This will allow the owners to get feedback about their workspaces and improve accordingly. */
SELECT * FROM Review 
JOIN Workspace ON Review.WorkspaceID = Workspace.WorkspaceID 
JOIN Property ON Workspace.PropertyID = Property.PropertyID 
WHERE Property.OwnerID = 1;
-- Retrieving all columns from the Review table
-- Joining the Review table with the Workspace table on Review.WorkspaceID = Workspace.WorkspaceID
-- Joining the Workspace table with the Property table on Workspace.PropertyID = Property.PropertyID
-- Applying the condition Property.OwnerID = 1 to filter the reviews for workspaces owned by the owner with OwnerID 1
