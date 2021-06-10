CREATE DATABASE QLNhapXuat
USE QLNhapXuat


CREATE TABLE SANPHAM
(
    MaSP CHAR(5) NOT NULL PRIMARY KEY,
    TenSP NVARCHAR(50),
    MauSac NVARCHAR(50),
    SoLuong INT,
    GiaBan MONEY,
)


CREATE TABLE Nhap
(
    SoHDN CHAR(5) NOT NULL PRIMARY KEY,
    MaSP CHAR(5),
    SoLuongN INT,
    NgayNhap DATETIME,
    CONSTRAINT fk_SANPHAM_Nhap FOREIGN KEY(MaSP) REFERENCES SANPHAM(MaSP)
)



CREATE TABLE Xuat
(
    SoHDX CHAR(5) NOT NULL PRIMARY KEY,
    MaSP CHAR(5),
    SoLuongX INT,
    NgayXuat DATETIME
    CONSTRAINT fk_SANPHAM_Xuat FOREIGN KEY(MaSP) REFERENCES SANPHAM(MaSP)
)


INSERT INTO SANPHAM
    VALUES  ('SP01', N'Bánh kẹo', N'Đỏ', 10, 10000),
            ('SP02', N'Kẹo đường', N'vàng', 20, 10000),
            ('SP03', N'Quả thanh long', N'Đỏ', 30, 20000)
            
        

INSERT INTO Nhap
    VALUES  ('HDN01', 'SP01', 30, '02/01/2001'),
            ('HDN02', 'SP02', 40, '03/02/2002'),
            ('HDN03', 'SP03', 50, '04/03/2003')
            
            
            

INSERT INTO Xuat
    VALUES  ('HDX01', 'SP01', 10, '02/01/2001'),
            ('HDX02', 'SP02', 10, '03/02/2002')



SELECT * FROM SANPHAM
SELECT * FROM Nhap
SELECT * FROM Xuat




--2

CREATE FUNCTION Cau2(@TenSP NVARCHAR(50))
RETURNS MONEY
AS
BEGIN
    DECLARE @tong INT
    SELECT @tong = SUM(SoLuongN * GiaBan)
    FROM SANPHAM x JOIN Nhap y ON x.MaSP = y.MaSP
    WHERE TenSP = @TenSP
    RETURN @tong
END

--TH1: Nhập đúng tên
SELECT dbo.Cau2(N'Bánh kẹo') AS 'Tong tien'
-- TH2: Nhập sai tên
SELECT dbo.Cau2(N'Bánh kẹo0') AS 'Tong tien'




-- 3
CREATE PROC Cau3 (@MaSP CHAR(5), @TenSP NVARCHAR(50), @MauSac NVARCHAR(50), @SoLuong INT, @GiaBan MONEY, @kq INT OUTPUT)
AS
BEGIN
    IF EXISTS(SELECT * FROM SANPHAM WHERE TenSP = @TenSP)
        BEGIN
            RAISERROR(N'Tên SP đã tồn tại', 16, 1)
            SET @kq = 1
        END
    ELSE 
        BEGIN
            INSERT INTO SANPHAM VALUES (@MaSP, @TenSP, @MauSac, @SoLuong, @GiaBan)
            SET @kq = 0
        END
END


-- TH1: Tên SP chưa tồn tại
DECLARE @kq INT
EXEC Cau3 'SP04', N'Bánh kem', N'Đỏ', 10, 10000, @kq OUTPUT
PRINT 'KQ: ' + CONVERT(CHAR(5), @kq)

-- TH2: Tên SP đã tồn tại
DECLARE @kq INT
EXEC Cau3 'SP05', N'Bánh kẹo', N'Đỏ', 10, 10000, @kq OUTPUT
PRINT 'KQ: ' + CONVERT(CHAR(5), @kq)


-- 4
 CREATE TRIGGER Cau4
 ON Xuat
 FOR INSERT
 AS
 BEGIN
    IF EXISTS(SELECT * FROM inserted x JOIN SANPHAM y ON x.MaSP = y.MaSP
                        WHERE SoLuongX > SoLuong)
        BEGIN
            RAISERROR(N'Số lượng xuất không hợp lệ', 16, 1)
            ROLLBACK TRANSACTION
        END
    UPDATE SANPHAM
    SET SoLuong = SoLuong - SoLuongX
    FROM inserted x JOIN SANPHAM y ON x.MaSP = y.MaSP
 END



SELECT * FROM Xuat
SELECT * FROM SANPHAM

-- TH1: Số lượng xuất hợp lệ
INSERT INTO Xuat VALUES('HDX03', 'SP01', 5, '02/01/2001')
-- TH2: Số lượng xuất không hợp lệ
INSERT INTO Xuat VALUES('HDX04', 'SP01', 100, '02/01/2001')

