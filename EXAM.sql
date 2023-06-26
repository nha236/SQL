--C1
create database NTB_DB

-- C2
create table Location (
LocationID char(6),
Name nvarchar(50) not null,
Description nvarchar(100),
PRIMARY KEY (LocationID)
);

create table Land(
LandID int identity,
Title nvarchar(100) not null,
LocationID nvarchar(6),
Detail nvarchar(1000),
StartDate datetime not null,
EndDate datetime not null,
PRIMARY KEY(LandID),
CONSTRAINT FK_LocationID FOREIGN KEY (LocationID) REFERENCES Location(LocationID)
);
create table Building(
BuildingID int,
LandID int,
BuildingType nvarchar(50),
Area int default 50,
Floors int default 1,
Rooms int default 1,
Const money,
PRIMARY KEY(BuildingID),
CONSTRAINT FK_LandID FOREIGN KEY(LandID) REFERENCES Land(LandID)
);

--C3
INSERT INTO Location(LocationID,Name,Description)
VALUES ('101','Hà Nội','Phương Liệt,Thanh Xuân'),
		('102','Hà Nội','An Dương,Tây Hồ'),
		('103','Hà Nội','Trung Hòa,Cầu Giấy');

INSERT INTO Land(LandID,Title,LocationID,StartDate,EndDate)
VALUES ('11','NHA','101','2018-12-18','2020-3-3'),
		('12','Vinhomes','102','2016-3-2','2019-9-12'),
		('13','EuroWindow','103','2013-10-6','2016-6-8');

INSERT INTO Building(BuildingID,LandID,Area,Floors,Rooms)
VALUES ('5','11','80m2','23','203'),
		('6','12','68m2','16','601'),
		('7','13','70m2','9','903');

--C4
SELECT Area FROM Building WHERE Area >= 100

--C5
SELECT EndDate FROM Land WHERE EndDate < '2013-1-1'

--C6
SELECT Description FROM Location WHERE Description = ' Mỹ Đình ' 

--C7
CREATE VIEW v_Buildings AS
SELECT b.BuildingID, l.Title, loc.Name, b.BuildingType, b.Area, b.Floors
FROM Building b
JOIN Land l ON b.LandID = l.LandID
JOIN Location loc ON l.LocationID = loc.LocationID;
--C8
CREATE VIEW v_TopBuildings AS
SELECT TOP 5 b.BuildingID,l.Title,loc.Name,b.Area,b.Cost FROM Building b
join Land l ON l.LandId = b.LandID
join Location loc ON loc.LocationID = l.LocationID
order by Cost DESC
--C9
CREATE PROC sp_SearchLandByLocation @locationID char(6)
AS
BEGIN
	SELECT loc.LocationID,loc.Name,loc.Description,l.Title,l.StartDate,l.EndDate
	FROM Location loc
	join Land l On l.LocationID = loc.LocationID
	WHERE @locationID = loc.LocationID
END
--C10
CREATE PROC sp_SearchBuildingByLand @LandID int
AS
BEGIN
	select l.Title,.BuildingID,b.BuildingType,b.Area,b.Floors,b.Rooms,b.Cost
	from Land l
	join Building b ON b.LandID = l.LandId
	where @LandID = l.LandId
END
--C11
CREATE TRIGGER tg_RemoveLand
ON Land
INSTEAD OF DELETE
AS
BEGIN
    IF NOT EXISTS (SELECT * FROM Building WHERE LandID IN (SELECT LandID FROM deleted))
    BEGIN
        DELETE FROM Land WHERE LandID IN (SELECT LandID FROM deleted)
    END
    ELSE
    BEGIN
        RAISERROR('Không thể xóa khu đất này vì có tòa nhà được xây dựng trên đó.', 16, 1)
    END
END;