CREATE DATABASE QLKHOO


CREATE TABLE Nhap
(
    SoHDN CHAR(4) NOT NULL,
    MaVT CHAR(4) NOT NULL,
    SoLuongN INT,
    DonGiaN MONEY,
    NgayN DATETIME,
    CONSTRAINT fk_Nhap PRIMARY KEY(SoHDN, MAVT),
    CONSTRAINT fk_Nhap_Ton FOREIGN KEY(MaVT) REFERENCES Ton(MaVT)
)

CREATE TABLE Xuat
(
    SoHDX CHAR(4) NOT NULL,
    MaVT CHAR(4) NOT NULL,
    SoLuongX INT,
    DonGiaX MONEY,
    NgayX DATETIME,
    CONSTRAINT fk_Xuat PRIMARY KEY(SoHDX, MAVT),
    CONSTRAINT fk_Xuat_Ton FOREIGN KEY(MaVT) REFERENCES Ton(MaVT)
)

CREATE TABLE Ton
(
    MAVT CHAR(4) NOT NULL PRIMARY KEY,
    TenVT NVARCHAR(70),
    SoLuongT INT,
)


INSERT INTO Ton
    VALUES  ('VT01', N'Bánh gai Thanh Hóa', 34),
            ('VT02', N'Nem chua Thanh Hóa', 35),
            ('VT03', N'Ổi Thanh Hóa', 36),
            ('VT04', N'Vải Thanh Hóa', 37)


INSERT INTO Nhap
    VALUES  ('HD01', 'VT01', 50, 3500, '2021-01-02'),
            ('HD02', 'VT02', 53, 4500, '2021-05-02'),
            ('HD03', 'VT03', 50, 3500, '2021-07-03')

INSERT INTO Xuat
    VALUES  ('HD10', 'VT01', 40, 7500, '2021-06-02'),
            ('HD20', 'VT02', 34, 8500, '2021-07-02'),
            ('HD30', 'VT03', 45, 9500, '2021-08-03')


--2.
CREATE FUNCTION fn_Cau2(@MaVT CHAR(4), @NgayN DATETIME)
RETURNS @bang3 TABLE(NgayN DATETIME, MaVT CHAR(4), TenVT NVARCHAR(70), TongTienNhap MONEY)
AS
BEGIN
    INSERT INTO @bang3
    SELECT NgayN, x.MaVT, TenVT, SoLuongN*DonGiaN
    FROM Nhap x JOIN Ton y ON x.MaVT = y.MAVT
    WHERE x.MaVT = @MaVT AND NgayN = @NgayN
    RETURN
END

SELECT * FROM dbo.fn_Cau2 ('VT01', '2021-01-02')
SELECT * FROM dbo.fn_Cau2 ('VT02', '2021-01-02')

SELECT * FROM Nhap
SELECT * FROM Ton

--3
CREATE FUNCTION fn_Cau3(@TenVT NVARCHAR(70), @NgayX DATETIME)
RETURNS MONEY
AS
BEGIN
    DECLARE @Tong MONEY
    SELECT @Tong = SoLuongX * DonGiaX
    FROM Xuat x JOIN Ton y ON x.MaVT = y.MAVT
    WHERE TenVT = @TenVT AND NgayX = @NgayX
    RETURN @Tong
END

SELECT dbo.fn_Cau3(N'Bánh gai Thanh Hóa', '2021-06-02')
SELECT dbo.fn_Cau3(N'Bánh gai Thanh Hóa', '2021-06-03')
SELECT dbo.fn_Cau3(N'Ổi Thanh Hóa', '2021-06-02')

SELECT * FROM Xuat
SELECT * FROM Ton




--4.
ALTER TRIGGER tg_Cau4
ON Xuat
FOR UPDATE
AS
BEGIN
    IF NOT EXISTS(SELECT * FROM inserted x JOIN Ton y ON x.MaVT = y.MAVT WHERE SoLuongX <= SoLuongT)
        BEGIN
            RAISERROR(N'Kiểm tra lại mã VT hoặc số lượng xuất', 16, 1)
            ROLLBACK TRAN
            RETURN
        END

    DECLARE @cu INT, @moi INT
    SET @cu = (SELECT SoLuongX FROM deleted) 
    SET @moi = (SELECT SoLuongX FROM inserted)

    UPDATE Ton
    SET SoLuongT = SoLuongT - (@moi - @cu)
    FROM inserted x JOIN Ton y ON x.MaVT = y.MAVT
END

SELECT * FROM Xuat
SELECT * FROM Ton

ALTER TABLE Xuat
NOCHECK CONSTRAINT ALL

UPDATE Xuat
SET SoLuongX = 50
WHERE SoHDX = 'HD10' AND MaVT = 'VT01'

UPDATE Xuat
SET SoLuongX = 10
WHERE SoHDX = 'HD20' AND MaVT = 'VT02'
