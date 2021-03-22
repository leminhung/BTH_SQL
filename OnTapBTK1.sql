CREATE DATABASE QUANLYSINHVIENN


CREATE TABLE SinhVien
(
    MaSV CHAR(4) NOT NULL PRIMARY KEY,
    HoTen NVARCHAR(30),
    DienThoai CHAR(7),
    DiaChi NVARCHAR(50)
)


CREATE TABLE MonHoc
(
    MaMon CHAR(4) NOT NULL PRIMARY KEY,
    TenMon NVARCHAR(30),
    HocKi INT
)

DROP TABLE Diem
CREATE TABLE Diem
(
    MaSV CHAR(4) NOT NULL,
    MaMon CHAR(4) NOT NULL,
    DiemThi INT
    CONSTRAINT pk_Diem PRIMARY KEY(MaSV, MaMon),
    CONSTRAINT fk_Diem_SinhVien FOREIGN KEY(MaSV) REFERENCES SinhVien(MaSV),
    CONSTRAINT fk_Diem_MonHoc FOREIGN KEY(MaMon) REFERENCES MonHoc(MaMon)
)

INSERT INTO SinhVien 
    VALUES ('S001', N'Trần Thanh Tùng', '1234567', N'Đông Anh - Hà Nội'),
           ('S002', N'Nguyễn Thu Hà', '2435678', N'TX Hòa Bình - Hòa Bình'),
           ('S003', N'Lê Ngọc Huyền', '3456789', N'TX Sơn Tây - Hà Nội')


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


            
SELECT * FROM Diem


DELETE FROM Diem
WHERE MaSV = (SELECT MaSV FROM SinhVien WHERE HoTen = N'Lê Ngọc Huyền')
        AND
      MaMon = (SELECT MaMon FROM MonHoc WHERE TenMon = N'Cơ sở dữ liệu')

SELECT * FROM Diem



--2.1
SELECT x.MaSV, HoTen, DiemThi
FROM Diem x JOIN SinhVien y ON x.MaSV = y.MaSV
            JOIN MonHoc z ON x.MaMon = z.MaMon
WHERE TenMon = N'Lập trình Windows'


--2.2
SELECT * 
FROM MonHoc
WHERE TenMon != N'Cơ sở dữ liệu' AND HocKi = (SELECT HocKi FROM MonHoc WHERE TenMon = N'Cơ sở dữ liệu')


--2.3
SELECT *
FROM MonHoc 
WHERE MaMon NOT IN (SELECT MaMon FROM Diem)


--2.4
SELECT y.MaMon, TenMon, MAX(DiemThi) AS 'MAX'
FROM Diem x RIGHT JOIN MonHoc y ON x.MaMon = y.MaMon
GROUP BY y.MaMon, TenMon

