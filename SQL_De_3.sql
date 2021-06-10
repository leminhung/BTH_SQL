CREATE DATABASE QLKHO

DROP TABLE XUAT


CREATE TABLE Ton
(
    MAVT CHAR(4) NOT NULL PRIMARY KEY,
    TenVT NVARCHAR(70),
    SoLuongT INT,
)

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

SELECT * FROM Nhap
SELECT * FROM Xuat
SELECT * FROM Ton


--2.
ALTER PROCEDURE pr_Cau2(@SoHDX CHAR(4), @MaVT CHAR(4), @SoLuongX INT, @DonGiaX MONEY, @NgayX DATETIME)
AS 
BEGIN
    IF EXISTS(SELECT * FROM Ton WHERE @SoLuongX > SoLuongT)
        BEGIN
            RAISERROR(N'Số lượng xuất không hợp lệ', 16, 1)
            RETURN
        END
    INSERT INTO Xuat
        VALUES  (@SoHDX, @MaVT, @SoLuongX, @DonGiaX, @NgayX)
END

EXECUTE pr_Cau2 'HD11', 'VT01', 40, 7500, '2021-06-02'
EXECUTE pr_Cau2 'HD11', 'VT01', 33, 7500, '2021-06-02'

SELECT * FROM Xuat
SELECT * FROM Ton

--3.
CREATE FUNCTION fn_Cau3(@NgayN DATETIME, @TenVT NVARCHAR(70))
RETURNS INT
AS
BEGIN
    DECLARE @TienNhap MONEY
    SELECT @TienNhap = SoLuongN * DonGiaN
    FROM Nhap x JOIN Ton y ON x.MaVT = y.MAVT
    WHERE NgayN = @NgayN AND TenVT = @TenVT
    RETURN @TienNhap
END

SELECT dbo.fn_Cau3('2021-01-02', N'Bánh gai Thanh Hóa')
SELECT dbo.fn_Cau3('2021-01-09', N'Bánh gai Thanh Hóa')
SELECT dbo.fn_Cau3('2021-01-02', N'Bánh gai Hà Nội')
SELECT * FROM Nhap


--4.
ALTER TRIGGER tg_Cau4
ON Nhap
FOR INSERT  
AS
BEGIN
    IF NOT EXISTS(SELECT * FROM inserted x JOIN Ton y ON x.MaVT = y.MAVT)
        BEGIN
            RAISERROR(N'Mã VT chưa có mặt trong bảng Ton', 16, 1)
            ROLLBACK TRANSACTION
            RETURN
        END
    UPDATE Ton
    SET SoLuongT = SoLuongT + SoLuongN
    FROM inserted x JOIN Ton y ON x.MaVT = y.MAVT
END


SELECT * FROM Nhap
SELECT * FROM Ton


ALTER TABLE Nhap
NOCHECK CONSTRAINT ALL


INSERT INTO Nhap
    VALUES  ('HD02', 'VT01', 50, 3500, '2021-01-02')

INSERT INTO Nhap
    VALUES  ('HD08', 'VT01', 50, 3500, '2021-01-02')

INSERT INTO Nhap
    VALUES  ('HD02', 'VT08', 50, 3500, '2021-01-02')





