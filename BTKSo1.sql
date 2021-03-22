CREATE DATABASE QuanLySinhVien

CREATE TABLE SinhVien
 (
        MaSV CHAR(4) NOT NULL PRIMARY KEY,
        HoTen NVARCHAR(50) NOT NULL,
        DienThoai CHAR(7),
        DiaChi NVARCHAR(50)
 )

CREATE TABLE MonHoc
 (
        MaMon CHAR(4) NOT NULL PRIMARY KEY,
        TenMon NVARCHAR(50) NOT NULL,
        HocKi INT
 )

CREATE TABLE Diem
 (
        MaSV CHAR(4) NOT NULL,
        MaMon CHAR(4) NOT NULL,
        DiemThi REAL,
        CONSTRAINT pk_Diem PRIMARY KEY(MaSV, MaMon),
        CONSTRAINT fk_Diem_SinhVien FOREIGN KEY(MaSV) REFERENCES SinhVien(MaSV),
        CONSTRAINT fk_Diem_MonHoc FOREIGN KEY(MaMon) REFERENCES MonHoc(MaMon)
 )

 DROP TABLE Diem



INSERT INTO SinhVien 
    VALUES ('S001', N'Trần Thanh Tùng', '1234567', N'Đông Anh-Hà Nội'),
           ('S002', N'Nguyễn Thu Hà', '2345678', N'TX Hòa Bình - Hòa Bình'),
           ('S003', N'Lê Ngọc Huyền', '3456789', N'TX Sơn Tây - Hà Nội'),
           ('S004', N'Lê Ngọc Huyền', '3456789', N'TX Sơn Tây - Hà Nội')
           


INSERT INTO MonHoc 
    VALUES ('M001', N'Tin đại cương', 1),
           ('M002', N'Lập trình Windows', 2),
           ('M003', N'Cơ sở dữ liệu', 2),
           ('M004', N'Công nghệ XML', 3)

INSERT INTO Diem 
    VALUES ('S001', 'M001', 6),
           ('S003', 'M002', 7),
           ('S003', 'M003', 4),
           ('S002', 'M001', 8)





--1.4
UPDATE Diem
SET DiemThi = NULL
WHERE MaSV = (SELECT x.MaSV FROM SinhVien x JOIN Diem y ON x.MaSV = y.MaSV
                                          JOIN MonHoc z ON y.MaMon = z.MaMon
              WHERE TenMon = N'Cơ sở dữ liệu' AND HoTen = N'Lê Ngọc Huyền')
      AND 

      MaMon = (SELECT z.MaMon FROM SinhVien x JOIN Diem y ON x.MaSV = y.MaSV
                                             JOIN MonHoc z ON y.MaMon = z.MaMon
              WHERE TenMon = N'Cơ sở dữ liệu' AND HoTen = N'Lê Ngọc Huyền')

SELECT * FROM SinhVien
SELECT * FROM Diem x JOIN SinhVien y ON x.MaSV = y.MaSV



--2.1

SELECT SinhVien.MaSV, HoTen, Diem
FROM Diem JOIN SinhVien ON Diem.MaSV = SinhVien.MaSV
		JOIN MonHoc ON Diem.MaMon = MonHoc.MaMon
WHERE TenMon = N'Lập trình Windows'


--2.2
SELECT MaMon, TenMon, HocKi
FROM MonHoc
WHERE HocKi = (SELECT HocKi 
               FROM MonHoc
               WHERE TenMon = N'Cơ sở dữ liệu') AND TenMon != N'Cơ sở dữ liệu'

--2.3 Thac mac mot chut
SELECT MaMon, TenMon, HocKi
FROM MonHoc
WHERE MaMon NOT IN (SELECT MaMon FROM Diem)


--2.4 
SELECT TenMon, HocKi, MAX(DiemThi) AS DiemMax
FROM Diem x RIGHT JOIN MonHoc y ON x.MaMon = y.MaMon
GROUP BY TenMon, HocKi