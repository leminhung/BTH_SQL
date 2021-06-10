CREATE DATABASE OT_QuanLySanPham
use OT_QuanLySanPham

CREATE TABLE CONGTY
(
    MaCongTy CHAR(5) NOT NULL PRIMARY KEY,
    TenCongTy NVARCHAR(50),
    DiaChi NVARCHAR(50)
)

CREATE TABLE SANPHAM
(
    MaSanPham CHAR(5) NOT NULL PRIMARY KEY,
    TenSanPham NVARCHAR(50),
    SoLuongCo INT,
    GiaBan MONEY
)

CREATE TABLE CUNGUNG
(
    MaCongTy CHAR(5) NOT NULL,
    MaSanPham CHAR(5) NOT NULL,
    SoLuongCungUng INT,
    NgayCungUng DATETIME
    CONSTRAINT pk_CUNGUNG PRIMARY KEY(MaCongTy, MaSanPham),
    CONSTRAINT fk_CUNGUNG_CONGTY FOREIGN KEY(MaCongTy) REFERENCES CONGTY(MaCongTy),
    CONSTRAINT fk_CUNGUNG_SANPHAM FOREIGN KEY(MaSanPham) REFERENCES SANPHAM(MaSanPham)
)

INSERT INTO CONGTY
    VALUES  ('CT01', N'Công ty Sữa', N'Thanh Hóa'),
            ('CT02', N'Công ty Bánh', N'Hà Nội'),
            ('CT03', N'Công ty Cam', N'Thái Bình')

INSERT INTO SANPHAM
    VALUES  ('SP01', N'Sữa', 100, 15000),
            ('SP02', N'Bánh Ngọt',  150, 10000),
            ('SP03', N'Cam Sành',  200, 20000)


INSERT INTO CUNGUNG
    VALUES  ('CT01', 'SP01', 100, '01/05/2001'),
            ('CT02', 'SP02', 200, '02/04/2001'),
            ('CT03', 'SP03', 300, '03/03/2001'),
            ('CT01', 'SP02', 400, '04/02/2001'),
            ('CT02', 'SP01', 500, '05/01/2001')

SELECT * FROM CONGTY
SELECT * FROM SANPHAM
SELECT * FROM CUNGUNG

--2
CREATE FUNCTION Cau2(@TenCongTy NVARCHAR(50), @NgayCungUng DATETIME)
RETURNS @bang2 TABLE (TenSanPham NVARCHAR(50), MaSanPham CHAR(5), SoLuongCo INT, GiaBan MONEY)
AS
BEGIN
    INSERT INTO @bang2
    SELECT TenSanPham, x.MaSanPham, SoLuongCo, GiaBan
    FROM CUNGUNG x JOIN SANPHAM y ON x.MaSanPham = y.MaSanPham
                    JOIN CONGTY z ON x.MaCongTy = z.MaCongTy
    WHERE TenCongTy = @TenCongTy AND NgayCungUng = @NgayCungUng
    RETURN
END

SELECT * FROM dbo.Cau2(N'Công ty Sữa', '01/05/2001')
SELECT * FROM dbo.Cau2(N'Công ty Sữa', '01/05/2002')
SELECT * FROM dbo.Cau2(N'Công ty Cam', '01/05/2001')

--3
CREATE PROCEDURE Cau3(@MaCongTy CHAR(5), @TenCongTy NVARCHAR(50), @DiaChi NVARCHAR(50))
AS
BEGIN
    IF EXISTS(SELECT * FROM CONGTY WHERE TenCongTy = @TenCongTy)
        BEGIN
            PRINT N'Tên công ty đã tồn tại rồi'
            RETURN 1
        END
    INSERT INTO CONGTY VALUES(@MaCongTy, @TenCongTy, @DiaChi)
    RETURN 0
END

EXECUTE Cau3 'CT04', N'Công ty Vải', N'Thái Bình'
EXECUTE Cau3 'CT05', N'Công ty Cam', N'Thái Bình'

--4
CREATE TRIGGER Cau4
ON CUNGUNG
FOR UPDATE
AS
BEGIN
    IF EXISTS(SELECT * FROM SANPHAM x JOIN inserted y ON x.MaSanPham = y.MaSanPham
                                      JOIN deleted z ON x.MaSanPham = z.MaSanPham
                WHERE y.SoLuongCungUng - z.SoLuongCungUng > SoLuongCo)
        BEGIN
            RAISERROR(N'Số lượng cung ứng mới không hợp lệ', 16, 1)
            ROLLBACK TRAN
        END
    DECLARE @moi INT, @cu INT
    SET @moi = (SELECT SoLuongCungUng FROM inserted)
    SET @cu = (SELECT SoLuongCungUng FROM deleted)
    UPDATE SANPHAM
    SET SoLuongCo = SoLuongCo - (@moi - @cu)
    FROM SANPHAM x JOIN inserted y ON x.MaSanPham = y.MaSanPham
END


SELECT * FROM CUNGUNG
SELECT * FROM SANPHAM

UPDATE CUNGUNG
SET SoLuongCungUng = 1000
WHERE MaCongTy = 'CT01' AND MaSanPham = 'SP01'

UPDATE CUNGUNG
SET SoLuongCungUng = 50
WHERE MaCongTy = 'CT01' AND MaSanPham = 'SP01'


UPDATE CUNGUNG
SET SoLuongCungUng = 100
WHERE MaCongTy = 'CT01' AND MaSanPham = 'SP01'

            
            


            
