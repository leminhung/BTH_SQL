CREATE DATABASE QLSVV

CREATE TABLE GIAOVIEN
(
    MaGV CHAR(4) NOT NULL PRIMARY KEY,
    TenGV NVARCHAR(50)
)

CREATE TABLE LOP
(
    MaLop CHAR(4) NOT NULL PRIMARY KEY,
    TenLop NVARCHAR(50),
    SiSo INT,
    MaGV CHAR(4),
    CONSTRAINT fk_LOP_GIAOVIEN FOREIGN KEY(MaGV) REFERENCES GIAOVIEN(MaGV)
)




CREATE TABLE SINHVIEN
(
    MaSV CHAR(4) NOT NULL PRIMARY KEY,
    HoTen NVARCHAR(50),
    NgaySinh DATETIME,
    GioiTinh CHAR(4),
    DiaChi NVARCHAR(100),
    MaLop CHAR(4),
    CONSTRAINT fk_SINHVIEN_LOP FOREIGN KEY(MaLop) REFERENCES LOP(MaLop)
)

INSERT INTO GIAOVIEN
    VALUES ('GV01' ,N'Lê Thị Thanh Thảo'),
            ('GV02' ,N'Phạm Thị Kim Phượng'),
            ('GV03' ,N'Lê Minh Kiên')

INSERT INTO LOP
    VALUES ('L001' ,N'CNTT', 70, 'GV01'),
            ('L002' ,N'KHMT', 75, 'GV02'),
            ('L003' ,N'Kế Toán', 60, 'GV03')

INSERT INTO SINHVIEN
    VALUES ('SV01' ,N'Lê Minh Hưng', '2001-01-02', N'Nam', N'Thanh Hóa', 'L001'),
            ('SV02' ,N'Hoàng Đăng Dương', '2001-03-03', N'Nam', N'Bắc Giang', 'L001'),
            ('SV03' ,N'Lê Thị Hiền', '2001-04-04', N'Nữ', N'Thanh Hóa', 'L002'),
            ('SV04' ,N'Nguyễn Khắc Nguyên', '2001-05-05', N'Nam', N'Hà Nội', 'L002'),
            ('SV05' ,N'Vũ Thiên Lý', '2001-06-06', N'Nữ', N'Hà Nam', 'L003')


SELECT * FROM SINHVIEN
SELECT * FROM LOP
SELECT * FROM GIAOVIEN
            

