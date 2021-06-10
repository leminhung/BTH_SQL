CREATE DATABASE QuanLySinhVien_De1
USE QuanLySinhVien_De1


CREATE TABLE Khoa
(
    MaKhoa CHAR(10) NOT NULL PRIMARY KEY,
    TenKhoa NVARCHAR(50),
    DienThoai CHAR(20)
)


CREATE TABLE Lop
(
    MaLop CHAR(10) NOT NULL PRIMARY KEY,
    TenLop NVARCHAR(50),
    SiSo INT,
    MaKhoa CHAR(10),
    CONSTRAINT fk_Lop_Khoa FOREIGN KEY(MaKhoa) REFERENCES Khoa(MaKhoa)
)



CREATE TABLE SinhVien
(
    MaSV CHAR(10) NOT NULL PRIMARY KEY,
    HoTen NVARCHAR(50),
    NgaySinh DATETIME,
    DiaChi NVARCHAR(50),
    MaLop CHAR(10),
    CONSTRAINT fk_SinhVien_Lop FOREIGN KEY(MaLop) REFERENCES Lop(MaLop)
)


INSERT INTO Khoa
    VALUES  ('KH01', N'Công nghệ thông tin', '1234567'),
            ('KH02', N'Khoa học máy tính', '2345678'),
            ('KH03', N'Kĩ thuật phần mềm', '3456789')
            
        

INSERT INTO Lop
    VALUES  ('LH01', N'CNTT2', 70, 'KH01'),
            ('LH02', N'KHMT2', 60, 'KH02'),
            ('LH03', N'KTPM2', 50, 'KH03')
            
            

INSERT INTO SinhVien
    VALUES  ('SV01', N'Lê Minh Hưng', '01/02/2001', N'Thanh Hóa', 'LH01'),
            ('SV02', N'Vũ Thiên Lý', '02/03/2001', N'Hà Nam', 'LH02'),
            ('SV03', N'Hoàng Đăng Dương', '03/04/2001', N'Bắc Giang', 'LH03'),
            ('SV04', N'Nguyễn Phương Nam', '04/05/2001', N'Phú Yên', 'LH01'),
            ('SV05', N'Nguyễn Khắc Nguyên', '05/06/2001', N'Hà Nội', 'LH02')



SELECT * FROM Khoa
SELECT * FROM Lop
SELECT * FROM SinhVien



--2
CREATE FUNCTION Cau2(@TenKhoa NVARCHAR(50), @TenLop NVARCHAR(50))
RETURNS @bang2 TABLE(MaSV CHAR(10), HoTen NVARCHAR(50), Tuoi INT)
AS
BEGIN
    INSERT INTO @bang2
    SELECT MaSV, HoTen, YEAR(NgaySinh)
    FROM Lop x JOIN Khoa y ON x.MaKhoa = y.MaKhoa
                JOIN SinhVien z ON x.MaLop = z.MaLop
    WHERE TenKhoa = @TenKhoa AND TenLop = @TenLop
    RETURN
END

-- TH1: Nhập hợp lệ
SELECT * FROM dbo.Cau2(N'Công nghệ thông tin', N'CNTT2')

-- TH2: Nhập sai tên khoa
SELECT * FROM dbo.Cau2(N'Công nghệ thôngggg tin', N'CNTT2')

-- TH3: Nhập sai tên lớp
SELECT * FROM dbo.Cau2(N'Công nghệ thông tin', N'CNTT9')



-- 3

ALTER PROC sp_TimKiem(@TuTuoi INT, @DenTuoi INT)
AS
BEGIN
    DECLARE @tuoi INT
    SET @tuoi = YEAR(GETDATE())
    IF EXISTS(SELECT * FROM SinhVien WHERE @tuoi - YEAR(NgaySinh) > @DenTuoi OR @tuoi - YEAR(NgaySinh) < @TuTuoi)
        BEGIN
            RAISERROR(N'Không tìm thấy sinh viên nào', 16, 1)
            RETURN
        END
    
    SELECT MaSV, HoTen, YEAR(NgaySinh) AS 'Tuoi', DiaChi, TenLop
    FROM SinhVien x JOIN Lop y ON x.MaLop = y.MaLop
    WHERE @tuoi - YEAR(NgaySinh) BETWEEN @TuTuoi AND @DenTuoi
END



-- TH1: Tuổi hợp lệ
EXEC sp_TimKiem 15, 21


-- TH2: Tuổi không hợp lệ
EXEC sp_TimKiem 30, 50





-- 4
ALTER TRIGGER Cau4
ON SinhVien
FOR INSERT
AS
BEGIN
    IF EXISTS(SELECT * FROM SinhVien x JOIN Inserted y ON x.MaSV = y.MaSV)
        BEGIN
            RAISERROR(N'Mã sinh viên không hợp lệ', 16, 1)
            ROLLBACK TRANSACTION
        END
    IF NOT EXISTS(SELECT * FROM inserted x JOIN Lop y ON x.MaLop = y.MaLop)
        BEGIN
            RAISERROR(N'Mã lớp không hợp lệ', 16, 1)
            ROLLBACK TRANSACTION
        END
    IF EXISTS(SELECT * FROM inserted x JOIN Lop y ON x.MaLop = y.MaLop WHERE SiSo >= 80)
        BEGIN
            RAISERROR(N'Sĩ số không hợp lệ', 16, 1)
            ROLLBACK TRANSACTION
        END
    UPDATE Lop
    SET SiSo = SiSo + 1
    FROM inserted x JOIN Lop y ON x.MaLop = y.MaLop
END


SELECT * FROM SinhVien
SELECT * FROM Lop


INSERT INTO SinhVien
    VALUES('SV06', N'Lê Minh Hưnggg', '01/02/2001', N'Thanh Hóa', 'LH01')

ALTER TABLE SinhVien
NOCHECK CONSTRAINT ALL