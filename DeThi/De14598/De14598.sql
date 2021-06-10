CREATE DATABASE QLSach
USE QLSach

CREATE TABLE TACGIA
(
    MaTG CHAR(5) NOT NULL PRIMARY KEY,
    TenTG NVARCHAR(50),
    SoLuongCo INT
)


CREATE TABLE NHAXB
(
    MaNXB CHAR(5) NOT NULL PRIMARY KEY,
    TenNXB NVARCHAR(50),
    SoLuongCo INT
)


CREATE TABLE SACH
(
    MaSach CHAR(5) NOT NULL PRIMARY KEY,
    TenSach NVARCHAR(50),
    MaNXB CHAR(5),
    MaTG CHAR(5),
    NamXB INT,
    SoLuong INT,
    DonGia MONEY,
    CONSTRAINT fk_SACH_NHAXB FOREIGN KEY(MaNXB) REFERENCES NHAXB(MaNXB),
    CONSTRAINT fk_SACH_TACGIA FOREIGN KEY(MaTG) REFERENCES TACGIA(MaTG)
)


INSERT INTO TACGIA
    VALUES  ('TG01', N'Lê Minh Hưng', 10),
            ('TG02', N'Nguyễn Thị Huyền', 20),
            ('TG03', N'Nguyễn Văn Đạt', 30),
            ('TG04', N'Nguyễn Mạnh Cường', 40)
            

INSERT INTO NHAXB
    VALUES  ('NXB01', N'Kim Đồng', 50),
            ('NXB02', N'Bích Hợp', 40),
            ('NXB03', N'Thăng Long', 60),
            ('NXB04', N'Hà Thành', 70)
            
            
            
            

INSERT INTO SACH
    VALUES  ('SA01', N'Truyện thiếu nhi', 'NXB01', 'TG01', 2001, 100, 15000),
            ('SA02', N'Truyện cười', 'NXB02', 'TG02', 2002, 400, 10000),
            ('SA03', N'Truyện ngụ ngôn', 'NXB03', 'TG03', 2003, 300, 15000),
            ('SA04', N'Truyện kinh dị', 'NXB04', 'TG04', 2004, 200, 15000),
            ('SA05', N'Truyện ma', 'NXB01', 'TG04', 2005, 1000, 100000)
            

SELECT * FROM SACH
SELECT * FROM TACGIA
SELECT * FROM NHAXB


--2
CREATE PROC Cau2(@MaSach CHAR(5), @TenSach NVARCHAR(50), @TenNXB NVARCHAR(50), @MaTG CHAR(5), @NamXB INT, @SoLuong INT, @DonGia MONEY)
AS
BEGIN
    IF NOT EXISTS(SELECT * FROM NHAXB WHERE TenNXB = @TenNXB)
        BEGIN
            RAISERROR(N'Nhà xuất bản không tồn tại', 16, 1)
            RETURN
        END

    DECLARE @MaNXB CHAR(5)
    SELECT @MaNXB = MaNXB
    FROM NHAXB
    WHERE TenNXB = @TenNXB
    
    INSERT INTO SACH VALUES(@MaSach, @TenSach, @MaNXB, @MaTG, @NamXB, @SoLuong, @DonGia)
END

EXEC Cau2 'SA06', N'Truyện thiếu nhii', N'Kim Đồng', 'TG01', 2001, 100, 15000
EXEC Cau2 'SA07', N'Truyện thiếu nhiii', N'Kim Đồngg', 'TG01', 2001, 100, 15000

SELECT * FROM SACH


--3

CREATE FUNCTION Cau3(@TenTG NVARCHAR(50))
RETURNS MONEY
AS
BEGIN
    DECLARE @tong MONEY
    SELECt @tong = SUM(SoLuong * DonGia)
    FROM TACGIA x JOIN SACH y ON x.MaTG = y.MaTG
    WHERE TenTG = @TenTG
    RETURN @tong
END

SELECT dbo.Cau3(N'Nguyễn Mạnh Cường') AS 'Tong'
SELECT dbo.Cau3(N'Nguyễn Mạnh Cườngg') AS 'Tong'
SELECT dbo.Cau3(N'Lê Minh Hưng') AS 'Tong'



--4
CREATE TRIGGER Cau4
ON SACH
FOR INSERT
AS
BEGIN
    IF NOT EXISTS(SELECT * FROM inserted x JOIN NHAXB y ON x.MaNXB = y.MaNXB)
        BEGIN
            RAISERROR(N'Mã nxb chưa có trong bảng nhaxb', 16, 1)
            ROLLBACK TRANSACTION
        END
    UPDATE NHAXB
    SET SoLuongCo = SoLuongCo + 1
    FROM inserted x JOIN NHAXB y ON x.MaNXB = y.MaNXB
END

INSERT INTO SACH VALUES('SA07', N'Truyệnn thiếu nhi', 'NXB01', 'TG01', 2001, 100, 15000)
INSERT INTO SACH VALUES('SA08', N'Truyệnn thiếu nhi', 'NXB09', 'TG01', 2001, 100, 15000)

SELECT * FROM SACH
SELECT * FROM NHAXB

ALTER TABLE SACH
NOCHECK CONSTRAINT ALL 
