CREATE DATABASE OT_QuanLyBanHang
USE OT_QuanLyBanHang

CREATE TABLE VATTU
(
    MaVT CHAR(5) NOT NULL PRIMARY KEY,
    TenVT NVARCHAR(50),
    DVTinh NVARCHAR(10),
    SLCon INT
)

CREATE TABLE HOADON
(
    MaHD CHAR(5) NOT NULL PRIMARY KEY,
    NgayLap Datetime,
    HoTenKhach NVARCHAR(50)
)

CREATE TABLE CTHOADON
(
    MaHD CHAR(5) NOT NULL,
    MaVT CHAR(5) NOT NULL,
    DonGiaBan FLOAT,
    SLBan INT
    CONSTRAINT pk_CTHOADON PRIMARY KEY(MaHD, MaVT),
    CONSTRAINT fk_CTHOADON_HOADON FOREIGN KEY(MaHD) REFERENCES HOADON(MaHD),
    CONSTRAINT fk_CTHOADON_VATTU FOREIGN KEY(MaVT) REFERENCES VATTU(MaVT)
)

INSERT INTO VATTU
    VALUES  ('VT01', N'Gỗ', 'VND', 100),
            ('VT02', N'Cây ăn quả', 'VND', 50),
            ('VT03', N'Bánh kẹo', 'VND', 150)

INSERT INTO HOADON
    VALUES  ('HD04', '02/05/2001', N'Lê Minh Hưng'),
            ('HD01', '02/01/2001', N'Lê Minh Hưng'),
            ('HD02', '03/02/1975', N'Trần Khánh Vy'),
            ('HD03', '07/05/2021', N'Nguyễn Hồng Thủy')

INSERT INTO CTHOADON
    VALUES  ('HD04', 'VT01', 15000, 100),
            ('HD01', 'VT01', 15000, 100),
            ('HD02', 'VT02', 10000, 10),
            ('HD03', 'VT03', 20000, 90),
            ('HD01', 'VT02', 25000, 80),
            ('HD02', 'VT01', 30000, 40)

SELECT * FROM VATTU
SELECT * FROM HOADON
SELECT * FROM CTHOADON


--2
CREATE FUNCTION Cau2 (@TenVT NVARCHAR(50), @NgayBan DATETIME)
RETURNS FLOAT
AS
BEGIN
    DECLARE @Tien FLOAT AS N'Tiền bán'
    SELECT @Tien = (DonGiaBan * SLBan)
    FROM CTHOADON x JOIN VATTU y ON x.MaVT = y.MaVT
                    JOIN HOADON z ON x.MaHD = z.MaHD
    WHERE NgayLap = @NgayBan AND TenVT = @TenVT
    RETURN @Tien
END

SELECT dbo.Cau2(N'Bánh kẹo', '07/05/2021') AS Tien
SELECT dbo.Cau2(N'Bánh', '07/05/2021') AS Tien
SELECT dbo.Cau2(N'Bánh kẹo', '07/05/2022') AS Tien

--3

CREATE PROCEDURE Cau3 (@Thang INT, @Nam INT)
AS
BEGIN
    DECLARE @Tong INT
    SELECT @Tong = SUM(SLBan)
    FROM CTHOADON x JOIN VATTU y ON x.MaVT = y.MaVT
                    JOIN HOADON z ON x.MaHD = z.MaHD
    WHERE MONTH(NgayLap) = @Thang AND YEAR(NgayLap) = @Nam
    PRINT N'Tổng số lượng vật tư bán trong tháng ' + CONVERT(VARCHAR(10), @Thang) + '-' + CONVERT(VARCHAR(10), @Nam) + ' là: ' + CONVERT(VARCHAR(10), @Tong)
END

SELECT * FROM HOADON

EXECUTE Cau3 2, 2001
EXECUTE Cau3 4, 2001


--4
CREATE TRIGGER Cau4
ON CTHOADON
FOR DELETE
AS
BEGIN
    IF(SELECT COUNT(*) FROM CTHOADON) = 1
        BEGIN
            RAISERROR(N'Không được xóa', 16, 1)
            ROLLBACK TRANSACTION
        END
    UPDATE VATTU
    SET SLCon = SLCon + SLBan
    FROM VATTU x JOIN deleted y ON x.MaVT = y.MaVT
END

SELECT * FROM CTHOADON
SELECT * FROM VATTU


DELETE FROM CTHOADON
WHERE MaHD = 'HD01' AND MaVT = 'VT01'
DELETE FROM CTHOADON
WHERE MaHD = 'HD08' AND MaVT = 'VT01'

