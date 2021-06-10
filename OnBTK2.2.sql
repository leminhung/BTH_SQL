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
    GioiTinh NVARCHAR(4),
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


--2.
CREATE FUNCTION fn_Cau2(@TenGV NVARCHAR(50), @TenLop NVARCHAR(50))
RETURNS @bang2 TABLE(MaSV CHAR(4), HoTen NVARCHAR(50), Tuoi INT, TenLop NVARCHAR(50), TenGV NVARCHAR(50))
AS
BEGIN
    INSERT INTO @bang2
    SELECT MaSV, HoTen, YEAR(GETDATE()) - YEAR(NgaySinh) AS 'Tuoi', TenLop, TenGV
    FROM LOP x JOIN SINHVIEN y ON x.MaLop = y.MaLop
               JOIN GIAOVIEN z ON x.MaGV = z.MaGV
    WHERE TenLop = @TenLop AND TenGV = @TenGV
    RETURN
END            

SELECT * FROM dbo.fn_Cau2(N'Phạm Thị Kim Phượng', N'KHMT')
SELECT * FROM dbo.fn_Cau2(N'Lê Minh Hưng', N'KHMT')
SELECT * FROM dbo.fn_Cau2(N'Phạm Thị Kim Phượng', N'CNTT')

SELECT * FROM GIAOVIEN
SELECT * FROM LOP


--3.
CREATE PROCEDURE pr_Cau3(@TuTuoi INT, @DenTuoi INT)
AS
BEGIN
    SELECT MaSV, HoTen, YEAR(GETDATE()) - YEAR(NgaySinh) AS 'Tuoi', DiaChi, TenLop, TenGV
    FROM LOP x JOIN SINHVIEN y ON x.MaLop = y.MaLop
               JOIN GIAOVIEN z ON x.MaGV = z.MaGV
    WHERE YEAR(GETDATE()) - YEAR(NgaySinh) BETWEEN @TuTuoi AND @DenTuoi
END


EXECUTE pr_Cau3 1, 22
EXECUTE pr_Cau3 1, 30
EXECUTE pr_Cau3 1, 10

--4.
ALTER TRIGGER tg_Cau4
ON SINHVIEN
FOR INSERT
AS
BEGIN
    IF NOT EXISTS(SELECT * FROM inserted x JOIN LOP y ON x.MaLop = y.MaLop)
        BEGIN
            RAISERROR(N'Không có mã lớp tồn tại trong bảng Lớp', 16, 1)
            ROLLBACK TRANSACTION
            RETURN
        END
    IF EXISTS(SELECT * FROM inserted x JOIN LOP y ON x.MaLop = y.MaLop WHERE SiSo >= 80)
        BEGIN
            RAISERROR(N'Sĩ số lớp không hợp lệ', 16, 1)
            ROLLBACK TRANSACTION
            RETURN
        END

    UPDATE LOP
    SET SiSo = SiSo + (SELECT COUNT(*) FROM inserted)
    FROM inserted x JOIN LOP y ON x.MaLop = y.MaLop
    
END

SELECT * FROM SINHVIEN
SELECT * FROM LOP


ALTER TABLE SINHVIEN
NOCHECK CONSTRAINT ALL

INSERT INTO SINHVIEN
    VALUES('SV06' ,N'Lê Minh Hưng', '2001-01-02', N'Nam', N'Thanh Hóa', 'L001')

INSERT INTO SINHVIEN
    VALUES('SV08' ,N'Lê Minh Hưng', '2001-01-02', N'Nam', N'Thanh Hóa', 'L011')


SELECT * FROM SINHVIEN