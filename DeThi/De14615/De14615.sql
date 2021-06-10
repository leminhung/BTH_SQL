CREATE DATABASE QLBenhVien
USE QLBenhVien


CREATE TABLE BenhNhan
(
    MaBN CHAR(5) NOT NULL PRIMARY KEY,
    TenBN NVARCHAR(50),
    GioiTinh NVARCHAR(10),
    SoDt CHAR(10),
    Email CHAR(50)
)


CREATE TABLE Khoa
(
    MaKhoa CHAR(5) NOT NULL PRIMARY KEY,
    TenKhoa NVARCHAR(50),
    DiaChi NVARCHAR(10),
    TienNgay MONEY,
    TongBenhNhan INT
)



CREATE TABLE HoaDon
(
    SoHD CHAR(5) NOT NULL PRIMARY KEY,
    MaBN CHAR(5),
    MaKhoa CHAR(5),
    SoNgay INT,
    CONSTRAINT fk_HoaDon_BenhNhan FOREIGN KEY(MaBN) REFERENCES BenhNhan(MaBN),
    CONSTRAINT fk_HoaDon_Khoa FOREIGN KEY(MaKhoa) REFERENCES Khoa(MaKhoa)
)


INSERT INTO BenhNhan
    VALUES  ('BN01', N'Lê Minh Hưng', N'Nam', '1234567', 'leminhhung@gmail.com'),
            ('BN02', N'Nguyễn Thị Huyền', N'Nữ', '345678', 'leminhhuyen@gmail.com'),
            ('BN03', N'Bùi Đình Phong', N'Nam', '3456789', 'leminhphong@gmail.com')
            
        


            
INSERT INTO Khoa
    VALUES  ('KH01', N'Hô Hấp', N'Thanh Hóa', 500000, 10),
            ('KH02', N'Hồi sức', N'Hà Nội', 400000, 30),
            ('KH03', N'Khoa Ngoại', N'Nam Định', 300000, 20)
            
                
            

INSERT INTO HoaDon
    VALUES  ('HD01', 'BN01', 'KH01', 10),
            ('HD02', 'BN02', 'KH02', 20),
            ('HD03', 'BN03', 'KH03', 30),
            ('HD04', 'BN01', 'KH02', 40),
            ('HD05', 'BN02', 'KH01', 50)
            

SELECT * FROM BenhNhan
SELECT * FROM Khoa
SELECT * FROM HoaDon


-- 2
CREATE FUNCTION Cau2(@MaBN CHAR(5))
RETURNS MONEY
AS
BEGIN
    DECLARE @tong INT
    SELECT @tong = SUM(SoNgay * TienNgay)
    FROM HoaDon x JOIN BenhNhan y ON x.MaBN = y.MaBN
                    JOIN Khoa z ON x.MaKhoa = z.MaKhoa
    WHERE x.MaBN = @MaBN
    RETURN @tong
END

-- TH1: Mã bệnh nhân hợp lệ
SELECT dbo.Cau2('BN01') AS 'Tong tien'
-- TH2: Mã bệnh nhân không hợp lệ
SELECT dbo.Cau2('BN09') AS 'Tong tien'


-- 3
CREATE PROC Cau3 (@SoHD CHAR(5), @MaBN CHAR(5), @TenKhoa NVARCHAR(50), @SoNgay INT)
AS
BEGIN
    IF NOT EXISTS(SELECT * FROM Khoa WHERE TenKhoa = @TenKhoa)
        BEGIN
            RAISERROR(N'Tên khoa nhập không hợp lệ', 16, 1)
            RETURN
        END
    DECLARE @MaKhoa CHAR(5)
    SELECT @MaKhoa = MaKhoa FROM Khoa
    WHERE TenKhoa = @TenKhoa
    INSERT INTO HoaDon VALUES (@SoHD, @MaBN, @MaKhoa, @SoNgay)
END


-- TH1: Nhập tên khoa hợp lệ
EXEC Cau3 'HD06', 'BN01', N'Hô Hấp', 10


-- TH2: Nhập tên khoa không hợp lệ
EXEC Cau3 'HD07', 'BN01', N'Hô Hấppp', 10

-- 4
CREATE TRIGGER Cau4
ON HOADON
FOR INSERT
AS
BEGIN
    UPDATE Khoa
    SET TongBenhNhan = TongBenhNhan + 1
    FROM inserted x JOIN Khoa y ON x.MaKhoa = y.MaKhoa
END

SELECT * FROM HoaDon
SELECT * FROM Khoa


INSERT INTO HoaDon VALUES('HD07', 'BN01', 'KH01', 10)