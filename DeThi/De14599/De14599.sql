CREATE DATABASE QLXe
USE QLXe

CREATE TABLE Xe
(
    MaXe CHAR(5) NOT NULL PRIMARY KEY,
    TenXe NVARCHAR(50),
    SoLuong INT
)


CREATE TABLE KhachHang
(
    MaKH CHAR(5) NOT NULL PRIMARY KEY,
    TenKH NVARCHAR(50),
    DiaChi NVARCHAR(50),
    SoDT CHAR(11),
    Email VARCHAR(50)
)


CREATE TABLE ThueXe
(
    SoHD CHAR(5) NOT NULL PRIMARY KEY,
    MaKH CHAR(5),
    MaXe CHAR(5),
    SoNgayThue INT,
    SoLuongThue INT,
    CONSTRAINT fk_ThueXe_Xe FOREIGN KEY(MaXe) REFERENCES Xe(MaXe),
    CONSTRAINT fk_ThueXe_KhachHang FOREIGN KEY(MaKH) REFERENCES KhachHang(MaKH)
)


INSERT INTO Xe
    VALUES  ('Xe01', N'Honda', 10),
            ('Xe02', N'Wave', 20),
            ('Xe03', N'Bán tải', 30)
        

INSERT INTO KhachHang
    VALUES  ('KH01', N'Lê Minh Hưng', N'Thanh Hóa', '123456', 'leminhhung@gmail.com'),
            ('KH02', N'Lê Minh Nguyễn', N'Thanh Hóa', '234567', 'leminhnguyen@gmail.com'),
            ('KH03', N'Lê Thị Hiền', N'Thanh Hóa', '345678', 'lethihien@gmail.com')
            
            
            

INSERT INTO ThueXe
    VALUES  ('HD01', 'KH01', 'Xe01', 10, 15),
            ('HD02', 'KH02', 'Xe02', 15, 10),
            ('HD03', 'KH03', 'Xe03', 5, 10),
            ('HD04', 'KH01', 'Xe02', 10, 10),
            ('HD05', 'KH02', 'Xe01', 10, 5)

SELECT * FROM Xe
SELECT * FROM KhachHang
SELECT * FROM ThueXe
            


--2

CREATE FUNCTION Cau2(@DiaChi NVARCHAR(50))
RETURNS INT
as
BEGIN
    DECLARE @tong INT
    SELECt @tong = SUM(SoLuongThue)
    FROM ThueXe x JOIN KhachHang y ON x.MaKH = y.MaKH
    WHERE DiaChi = @DiaChi
    RETURN @tong
END


--TH1: Có Địa chỉ chính xác
SELECT dbo.Cau2(N'Thanh Hóa') AS 'Tong SL'

--TH2: Không Có Địa chỉ chính xác
SELECT dbo.Cau2(N'Hòa Bình')  AS 'Tong SL'




--3
ALTER PROCEDURE Cau3 @SoDH CHAR(5), @SoNgayThue INT, @SoLuongThue INT, @MaKH CHAR(5), @MaXe CHAR(5), @kq INT OUTPUT
AS
BEGIN
    IF NOT EXISTS(SELECT * FROM KhachHang WHERE MaKH = @MaKH)
        BEGIN
            PRINT N'Mã khách hàng không tồn tại'
            SET @kq = 1
        END
    ELSE IF NOT EXISTS(SELECT * FROM Xe WHERE MaXe = @MaXe)
        BEGIN
            PRINT N'Mã xe hàng không tồn tại'
            SET @kq = 2
        END
    ELSE 
        BEGIN
            INSERT INTO ThueXe VALUES(@SoDH, @MaKH, @MaXe, @SoNgayThue, @SoLuongThue)
            SET @kq = 0
        END
END

ALTER TABLE ThueXe DISABLE TRIGGER Cau4

DELETE FROM ThueXe WHERE SoHD = 'HD07' or SoHD = 'HD08'
--TH1: Mã khách hàng và xe tồn tại
DECLARE @kq INT
EXECUTE Cau3 'HD07', 10, 15, 'KH01', 'Xe01', @kq OUTPUT
PRINT N'KQ: ' + CONVERT(CHAR(5), @kq)

--TH2: Mã khách hàng tồn tại và  mã xe không tồn tại
DECLARE @kq INT
EXECUTE Cau3 'HD08', 10, 15, 'KH01', 'Xe07', @kq OUTPUT
PRINT N'KQ: ' + CONVERT(CHAR(5), @kq)

--TH3: Mã khách hàng không tồn tại và mã xe tồn tại
DECLARE @kq INT
EXECUTE Cau3 'HD09', 10, 15, 'KH07', 'Xe01', @kq OUTPUT
PRINT N'KQ: ' + CONVERT(CHAR(5), @kq)

DISABLE TRIGGER Cau4


--4
ALTER TRIGGER Cau4
ON ThueXe
FOR INSERT
AS
BEGIN
    IF EXISTS (SELECT * FROM inserted x JOIN Xe y ON x.MaXe = y.MaXe WHERE
                            SoLuongThue >= SoLuong)
        BEGIN
            RAISERROR(N'Số lượng thuê không phù hợp', 16, 1)
            ROLLBACK TRANSACTION
        END
    UPDATE Xe
    SET SoLuong = SoLuong - SoLuongThue
    FROM Xe x JOIN inserted y ON x.MaXe = y.MaXe
END


SELECT * FROM ThueXe
SELECT * FROM Xe


--TH1: Số lượng xe thuê < Số lượng có
INSERT INTO ThueXe
    VALUES ('HD07', 'KH01', 'Xe01', 10, 5)

--TH2: Số lượng xe thuê > Số lượng có
INSERT INTO ThueXe
    VALUES ('HD08', 'KH01', 'Xe01', 10, 50)