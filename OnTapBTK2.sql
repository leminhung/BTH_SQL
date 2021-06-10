CREATE DATABASE QLBanHangg


CREATE TABLE CONGTY
(
    MaCT CHAR(4) NOT NULL PRIMARY KEY,
    TenCT NVARCHAR(100),
    TrangThai NVARCHAR(50),
    DiaChi NVARCHAR(50)
)

CREATE TABLE SANPHAM
(
    MaSP CHAR(4) NOT NULL PRIMARY KEY,
    TenSP NVARCHAR(100),
    MauSac NVARCHAR(20),
    SoLuong INT,
    DonGia MONEY
)


CREATE TABLE CUNGUNG
(   
    MaCT CHAR(4) NOT NULL,
    MaSP CHAR(4) NOT NULL,
    SLCungung INT,
    NgayCungUng DATETIME,
    CONSTRAINT pk_CUNGUNG PRIMARY KEY (MaCT, MaSP),
    CONSTRAINT fk_CUNGUNG_SANPHAM FOREIGN KEY(MaSP) REFERENCES SANPHAM(MaSP),
    CONSTRAINT fk_CUNGUNG_CONGTY FOREIGN KEY(MaCT) REFERENCES CONGTY(MaCT)
    
)



INSERT INTO CONGTY
    VALUES ('CT01', N'Công Ty Sữa', N'Hoạt động bình thường', N'Thanh Hóa'),
            ('CT02', N'Công Ty Đường', N'Hoạt động bình thường', N'Hà Nội'),
            ('CT03', N'Công Ty Bia', N'Đang khủng hoảng', N'Ninh Bình')
            

INSERT INTO SANPHAM
    VALUES ('SP01', N'Mía', N'Đỏ, Đen', 3, 10000),
            ('SP02', N'Đường', N'Vàng, Trắng', 10, 16000),
            ('SP03', N'Bia', N'Cam, Trắng', 20,  12000)



INSERT INTO CUNGUNG
    VALUES ('CT01', 'SP01', 15, '2001-01-02'),
            ('CT01', 'SP02', 20, '2001-03-02'),
            ('CT02', 'SP02', 35, '2021-03-03'),
            ('CT02', 'SP03', 15, '2021-04-04'),
            ('CT03', 'SP03', 15, '2021-01-02')



SELECT * FROM CUNGUNG
SELECT * FROM CONGTY
SELECT * FROM SANPHAM


--2

CREATE FUNCTION fn_TongTien(@TenCT NVARCHAR(100), @Nam INT)
RETURNS @bang TABLE(TenSP NVARCHAR(100), MauSac NVARCHAR(20), SoLuong INT, DonGia MONEY, TongTien FLOAT)
AS
BEGIN
    INSERT INTO @bang
    SELECT TenSP, MauSac, SoLuong, DonGia, SoLuong*DonGia AS 'Tong Tien'
    FROM CUNGUNG x JOIN SANPHAM y ON x.MaSP = y.MaSP
                   JOIN CONGTY z ON x.MaCT = z.MaCT
    WHERE TenCT = @TenCT AND YEAR(NgayCungUng) = @Nam
    RETURN
END


SELECT * FROM dbo.fn_TongTien( N'Công Ty Sữa', 2001)
SELECT * FROM dbo.fn_TongTien( N'Công Ty Cam', 2001)
SELECT * FROM dbo.fn_TongTien( N'Công Ty Sữa', 2003)

SELECT * FROM SANPHAM
SELECT * FROM CUNGUNG
SELECT * FROM CONGTY



--3.

CREATE PROCEDURE XoaSP (@TenSP NVARCHAR(100))
AS
BEGIN
    IF EXISTS(SELECT * FROM CUNGUNG WHERE MaSP = (SELECT MaSP FROM SANPHAM WHERE TenSP = @TenSP))
        BEGIN
            RAISERROR(N'Sản phẩm không xóa được', 16, 1)
            RETURN
        END
    DELETE FROM SANPHAM 
    WHERE TenSP = @TenSP
END


EXECUTE XoaSP N'Mía'
EXECUTE XoaSP N'Cam'

SELECT * FROm CUNGUNG
SELECT * FROm SANPHAM

--4
ALTER TRIGGER cau4
ON CUNGUNG
FOR UPDATE
AS
BEGIN
    IF (SELECT COUNT(*) FROM inserted) != 1
    BEGIN
        RAISERROR(N'UPDATE Không thành công', 16, 1)
        ROLLBACK TRANSACTION
        RETURN
    END
       
    DECLARE @SLCungung_moi INT, @SLCungung_cu INT
    SET @SLCungung_cu = (SELECT SLCungung FROM deleted)
    SET @SLCungung_moi = (SELECT SLCungung FROM Inserted)
    IF EXISTS(SELECT * FROM inserted x JOIN SANPHAM y ON x.MaSP = y.MaSP
                WHERE @SLCungung_moi - @SLCungung_cu > SoLuong)
    BEGIN
        RAISERROR(N'Số lượng không hợp lệ', 16, 1)
        ROLLBACK TRANSACTION
        RETURN
    END

    UPDATE SANPHAM
    SET SoLuong = SoLuong - (@SLCungung_moi - @SLCungung_cu)
    FROM inserted x JOIN SANPHAM y ON x.MaSP = y.MaSP
END


ALTER TABLE CUNGUNG
NOCHECK CONSTRAINT ALL

UPDATE CUNGUNG
SET SLCungung = 30
WHERE MaCT = 'CT01' AND MaSP = 'SP01'

UPDATE CUNGUNG
SET SLCungung = 3
WHERE MaCT = 'CT01' AND MaSP = 'SP01'

UPDATE CUNGUNG
SET SLCungung = 3
WHERE MaCT = 'CT02'


SELECT * FROM CUNGUNG
SELECT * FROM SANPHAM




            
CREATE TRIGGER tg_PXUAT_Xoa
ON PXUAT
FOR DELETE
AS 
BEGIN
    DELETE FROM CTPXUAT
    WHERE SoPx = (SELECT x.SoPx FROM CTPXUAT x JOIN deleted y ON x.SoPx = y.SoPx)
END

DELETE FROM PXUAT 
WHERE SoPx = 'X001'



