CREATE DATABASE QLTruongHoc
USE QLTruongHoc

CREATE TABLE GiaoVien
(
    MaGV CHAR(5) NOT NULL PRIMARY KEY,
    TenGV NVARCHAR(50),
)

CREATE TABLE Lop
(
    MaLop CHAR(5) NOT NULL PRIMARY KEY,
    Tenlop NVARCHAR(50),
    Phong VARCHAR(5),
    SiSo INT,
    MaGV CHAR(5),
    CONSTRAINT fk_Lop_GiaoVien FOREIGN KEY(MaGV) REFERENCES GiaoVien(MaGV) 
)

CREATE TABLE SinhVien
(
    MaSV CHAR(5) NOT NULL PRIMARY KEY,
    TenSV NVARCHAR(50),
    GioiTinh NVARCHAR(5),
    QueQuan NVARCHAR(50),
    MaLop CHAR(5),
    CONSTRAINT fk_SinhVien_Lop FOREIGN KEY(MaLop) REFERENCES Lop(MaLop)
)


INSERT INTO GiaoVien
    VALUES  ('GV01', N'Nguyễn Thị Bích'),
            ('GV02', N'Nguyễn Thị Lan'),
            ('GV03', N'Nguyễn Văn Nam')

INSERT INTO Lop
    VALUES  ('LH01', N'Công nghệ thông tin 02', '15B', 70, 'GV01'),
            ('LH02', N'Kĩ thuật phần mềm 03', '15C', 60, 'GV02'),
            ('LH03', N'Du lịch 04', '15D', 65, 'GV03')
            

INSERT INTO SinhVien
    VALUES  ('SV01', N'Lê Minh Hưng', N'Nam', N'Thanh Hóa', 'LH01'),
            ('SV02', N'Lê Kim Anh', N'Nữ', N'Hà Nội', 'LH02'),
            ('SV03', N'Lê Thị Hoài', N'Nữ', N'Phú Thọ', 'LH03'),
            ('SV04', N'Lê Văn Chương', N'Nam', N'Thanh Hóa', 'LH02'),
            ('SV05', N'Lê Thị Hiền', N'Nữ', N'Nam Đinh', 'LH01')
            
            
SELECT * FROM SinhVien
SELECT * FROM Lop
SELECT * FROM GiaoVien


--2
CREATE FUNCTION Cau2(@TenLop NVARCHAR(50), @TenGV NVARCHAR(50))
RETURNS @bang2 TABLE(MaSV CHAR(5), TenSV NVARCHAR(50), GioiTinh NVARCHAR(5), QueQuan NVARCHAR(50), MaLop CHAR(5))
AS
BEGIN
    INSERT INTO @bang2
    SELECT MaSV, TenSV, GioiTinh, QueQuan, x.MaLop
    FROM Lop x JOIN SinhVien y ON x.MaLop = y.MaLop
               JOIN GiaoVien z ON x.MaGV = z.MaGV
    WHERE TenLop = @TenLop AND TenGV = @TenGV
    RETURN
END

SELECT * FROM dbo.Cau2(N'Công nghệ thông tin 02', N'Nguyễn Thị Bích')
SELECT * FROM dbo.Cau2(N'Công nghệ thông tin 03', N'Nguyễn Thị Bích')
SELECT * FROM dbo.Cau2(N'Công nghệ thông tin 02', N'Nguyễn Lan')



--3
ALTER PROCEDURE Cau3(@MaSV CHAR(5), @TenSV NVARCHAR(50), @GioiTinh NVARCHAR(5), @QueQuan NVARCHAR(50), @TenLop NVARCHAR(50))
AS
BEGIN
    IF NOT EXISTS(SELECT * FROM Lop WHERE Tenlop = @TenLop)
        BEGIN
            RAISERROR(N'Lớp không tồn tại', 16, 1)
            RETURN
        END
    DECLARE @MaLop CHAR(5) 
    SELECT @MaLop = MaLop
    FROM Lop
    WHERE Tenlop = @TenLop
    INSERT INTO SinhVien VALUES (@MaSV, @TenSV, @GioiTinh, @QueQuan, @MaLop)
END


DELETE FROM SinhVien WHERE MaSV = 'SV06' OR MaSV = 'SV07'

EXEC Cau3 'SV06', N'Lê Minh Hưnggg', N'Nam', N'Thanh Hóa', N'Công nghệ thông tin 02'
EXEC Cau3 'SV07', N'Lê Minh Hưnggg', N'Nam', N'Thanh Hóa', N'Công nghệ thông tin 06'

SELECT * FROM SinhVien



--4
CREATE TRIGGER Cau4
ON SinhVien
FOR UPDATE
AS
BEGIN
    UPDATE Lop SET SiSo = SiSo + 1 
    FROM inserted x JOIN Lop y ON x.MaLop = y.MaLop
    UPDATE Lop SET SiSo = SiSo - 1 
    FROM deleted x JOIN Lop y ON x.MaLop = y.MaLop
END


SELECT * FROM SinhVien
SELECT * FROM Lop


UPDATE SinhVien
SET MaLop = 'LH02'
WHERE MaSV = 'SV05'

UPDATE SinhVien
SET MaLop = 'LH02'
WHERE MaSV = 'SV09'
