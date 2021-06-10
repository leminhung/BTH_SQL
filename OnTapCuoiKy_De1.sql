CREATE DATABASE OT_QLSinhVien
use OT_QLSinhVien

CREATE TABLE KHOA
(
    MaKhoa CHAR(5) not null PRIMARY KEY,
    TenKhoa NVARCHAR(50),
    SoDienThoai CHAR(10),
)

CREATE TABLE LOP
(
    MaLop CHAR(5) not null PRIMARY KEY,
    TenLop NVARCHAR(50),
    SiSo INT,
    MaKhoa CHAR(5),
    CONSTRAINT fk_LOP_KHOA FOREIGN KEY(MaKhoa) REFERENCES KHOA(MaKhoa)
)

CREATE TABLE SINHVIEN
(
    MaSV CHAR(10) not null PRIMARY KEY,
    HoTen NVARCHAR(50),
    GioiTinh NVARCHAR(5),
    NgaySinh DATETIME,
    MaLop CHAR(5),
    CONSTRAINT fk_SINHVIEN FOREIGN KEY(MaLop) REFERENCES LOP(MaLop)
)

INSERT INTO KHOA
    VALUES ('KH01', 'CNTT', '123456'),
            ('KH02', 'KTPM', '234565'),
            ('KH03', N'Kế toán', '987654')

INSERT INTO LOP
    VALUES ('LP01', 'CNTT1', 60, 'KH01'),
            ('LP02', 'CNTT2', 70, 'KH02'),
            ('LP03', 'CNTT3', 75, 'KH03')

INSERT INTO SINHVIEN
    VALUES ('SV01', N'Lê Minh Hưng', N'Nam', '02/01/2001', 'LP02'),
            ('SV02', N'Hoàng Đăng Dương', N'Nam', '03/02/2001', 'LP01'),
            ('SV03', N'Lê Thị Hiền', N'Nữ', '05/06/2001', 'LP03'),
            ('SV04', N'Nguyễn Khắc Nguyên', N'Nam', '04/07/2001', 'LP01'),
            ('SV05', N'Nguyễn Phương Nam', N'Nam', '06/05/2001', 'LP02')
            
SELECT * FROM KHOA
SELECT * FROM LOP
SELECT * FROM SINHVIEN



--2
CREATE FUNCTION Cau2(@TenKhoa NVARCHAR(50))
RETURNS @bang2 TABLE (MaLop CHAR(5), TenLop NVARCHAR(50), SiSo INT)
AS
BEGIN
    INSERT INTO @bang2
    SELECT MaLop, TenLop, SiSo
    FROM LOP x JOIN KHOA y ON x.MaKhoa = y.MaKhoa
    WHERE TenKhoa = @TenKhoa
    RETURN
END

SELECT * FROM dbo.Cau2('CNTT')
SELECT * FROM dbo.Cau2(N'Kế toán')


--3
ALTER PROCEDURE Cau3 @MaSV CHAR(10), @HoTen NVARCHAR(50), @GioiTinh NVARCHAR(5), @NgaySinh DATETIME, @TenLop NVARCHAR(50)
AS
BEGIN
    IF NOT EXISTS(SELECT * FROM LOP WHERE TenLop = @TenLop)
        BEGIN
            RAISERROR('Ten lop khong ton tai', 16, 1)
            RETURN 
        END
    DECLARE @MaLop CHAR(5)
    SELECT @MaLop = MaLop FROM LOP WHERE TenLop = @TenLop
    INSERT INTO SINHVIEN VALUES (@MaSV, @HoTen, @GioiTinh, @NgaySinh, @MaLop)
END

SELECT * FROM LOP
SELECT * FROM SINHVIEN

EXEC Cau3 'SV06', N'Lê Minh Hưngg', N'Nam', '02/01/2001', 'CNTT1'
EXEC Cau3 'SV07', N'Lê Minh Hưngg', N'Nam', '02/01/2001', 'CNTT4'

--4
CREATE TRIGGER Cau4
ON SINHVIEN
FOR UPDATE
AS
BEGIN
    IF EXISTS(SELECT * FROM LOP x JOIN inserted y ON x.MaLop = y.MaLop WHERE SiSo >= 70)
        BEGIN
            RAISERROR(N'Lớp đã đủ người', 16, 1)
            ROLLBACK TRANSACTION
        END
    UPDATE LOP
    SET SiSo = SiSo + 1
    FROM inserted x JOIN LOP y ON x.MaLop = y.MaLop
    UPDATE LOP
    SET SiSo = SiSo - 1
    FROM deleted x JOIN LOP y ON x.MaLop = y.MaLop
END


ALTER TABLE SINHVIEN
NOCHECK CONSTRAINT ALL 

ALTER TABLE LOP
NOCHECK CONSTRAINT ALL 

SELECT * FROM SINHVIEN
SELECT * FROM LOP

UPDATE SINHVIEN 
SET MaLop = 'LP02'
WHERE MaSV = 'SV02'

UPDATE SINHVIEN 
SET MaLop = 'LP02'
WHERE MaSV = 'SV01'

UPDATE SINHVIEN 
SET MaLop = 'LP03'
WHERE MaSV = 'SV01'

















