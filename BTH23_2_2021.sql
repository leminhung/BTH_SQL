CREATE DATABASE QLBH


DROP TABLE SANPHAM
CREATE TABLE HANGSX
(
    MAHANGSX NCHAR(10) NOT NULL PRIMARY KEY,
    TENHANG NVARCHAR(20) NOT NULL,
    DIACHI NVARCHAR(30) NOT NULL,
    SODT NVARCHAR(20) NOT NULL,
    EMAIL NVARCHAR(30) NOT NULL
)

CREATE TABLE SANPHAM
(
    MASP NCHAR(10) NOT NULL PRIMARY KEY,
    MAHANGSX NCHAR(10) NOT NULL,
    TENSP NVARCHAR(20) NOT NULL, 
    SOLUONG INT NOT NULL, 
    MAUSAC NVARCHAR(20) NOT NULL, 
    GIABAN MONEY NOT NULL, 
    DONVITINH NCHAR(10) NOT NULL, 
    MOTA NVARCHAR(MAX) NOT NULL,
    CONSTRAINT fk_SANPHAM_HANGSX FOREIGN KEY(MAHANGSX) REFERENCES HANGSX(MAHANGSX)
)


CREATE TABLE NHANVIEN
(
    MANV NCHAR(10) NOT NULL PRIMARY KEY,
    TENNV NVARCHAR(20) NOT NULL,
    GIOITINH NCHAR(10) NOT NULL,
    DiACHI NVARCHAR(30) NOT NULL,
    SODT NVARCHAR(20) NOT NULL,
    EMAIL NVARCHAR(30) NOT NULL,
    TENPHONG NVARCHAR(30) NOT NULL
)

CREATE TABLE PNHAP
(
    SOHDN NCHAR(10) NOT NULL PRIMARY KEY,
    NGAYNHAP DATE NOT NULL,
    MANV NCHAR(10) NOT NULL,
    CONSTRAINT fk_PNHAP_NHANVIEN FOREIGN KEY(MANV) REFERENCES NHANVIEN(MANV)

)
-- ALTER TABLE NHAP
-- DROP fk_NHAP_SANPHAM
-- DROP TABLE NHAP
CREATE TABLE NHAP
(
    SOHDN NCHAR(10) NOT NULL,
    MASP NCHAR(10) NOT NULL,
    SOLUONGN INT NOT NULL, 
    DONGIAN MONEY,
    CONSTRAINT fk_NHAP_PNHAP FOREIGN KEY(SOHDN) REFERENCES PNHAP(SOHDN),
    CONSTRAINT fk_NHAP_SANPHAM FOREIGN KEY(MASP) REFERENCES SANPHAM(MASP),
    CONSTRAINT PK_NHAP PRIMARY KEY(SOHDN, MASP)
)

CREATE TABLE PXUAT
(
    SOHDX NCHAR(10) NOT NULL PRIMARY KEY,
    NGAYXUAT DATE NOT NULL,
    MANV NCHAR(10) NOT NULL,
    CONSTRAINT fk_PXUAT_NHANVIEN FOREIGN KEY(MANV) REFERENCES NHANVIEN(MANV)
)
ALTER TABLE XUAT
DROP fk_XUAT_SANPHAM
DROP TABLE XUAT
CREATE TABLE XUAT
(
    SOHDX NCHAR(10) NOT NULL,
    MASP NCHAR(10) NOT NULL,
    SOLUONGX INT NOT NULL,
    CONSTRAINT fk_XUAT_PXUAT FOREIGN KEY(SOHDX) REFERENCES PXUAT(SOHDX),
    CONSTRAINT fk_XUAT_SANPHAM FOREIGN KEY(MASP) REFERENCES SANPHAM(MASP),
    CONSTRAINT PK_XUAT PRIMARY KEY(SOHDX, MASP)
)
-- SanPham('MaSP', MaHangSX, TenSP, SoLuong, MauSac, GiaBan, DonViTinh, MoTa)
-- HangSX('MaHangSX', TenHang, DiaChi, SoDT, Email)
-- NhanVien('MaNV', TenNV, GioiTinh, DiaChi, SoDT, Email, TenPhong)
-- Nhap('SoHDN, MaSP', SoLuongN, DonGiaN)
-- PNhap('SoHDN',NgayNhap,MaNV)
-- Xuat('SoHDX, MaSP', SoLuongX)
-- PXuat('SoHDX',NgayXuat,MaNV)


--Nhập giá trị cho các bảng
INSERT INTO HANGSX
    VALUES  ('H01', 'Samsung', 'Korea', '011-08271717', 'ss@gmail.com.kr'),
            ('H02', 'OPPO', 'China', '081-08626262', 'oppo@gmail.com.cn'),
            ('H03', 'Vinfonr', N'Việt Nam', '084-098262626', 'vf@gmail.com.vn')

INSERT INTO NHANVIEN
    VALUES  ('NV01', N'Nguyễn Thị Thu', N'Nữ', N'Hà Nội', '0982626521', 'thu@gmail.com', N'Kế toán'),
            ('NV02', N'Lê Văn Nam', N'Nam', N'Bắc Ninh', '0972525252', 'nam@gmail.com', N'Vật tư'),
            ('NV03', N'Trần Hòa Bình', N'Nữ', N'Hà Nội', '0982626521', 'hb@gmail.com', N'Kế toán')


INSERT INTO SANPHAM
    VALUES  ('SP01', 'H02', 'F1 Plus', 100, N'Xám', 7000000, N'Chiếc', N'Hàng cận cao cấp'),
            ('SP02', 'H01', 'Galaxy Note11', 50, N'Đỏ', 19000000, N'Chiếc', N'Hàng cao cấp'),
            ('SP03', 'H02', 'F3 lite', 200, N'Nâu', 3000000, N'Chiếc', N'Hàng phổ thông'),
            ('SP04', 'H03', 'Vjoy3', 200, N'Xám', 1500000, N'Chiếc', N'Hàng phổ thông'),
            ('SP05', 'H01', 'Galaxy V21', 500, N'Nâu', 8000000, N'Chiếc', N'Hàng cận cao cấp')


INSERT INTO PNHAP
    VALUES ('N01', '02-05-2019', 'NV01'),
           ('N02', '04-07-2020', 'NV02'),
           ('N03', '05-17-2020', 'NV02'),
           ('N04', '03-22-2020', 'NV03'),
           ('N05', '07-07-2020', 'NV01')


INSERT INTO NHAP
    VALUES  ('N01', 'SP02', 10, 17000000),
            ('N02', 'SP01', 30, 6000000),
            ('N03', 'SP04', 20, 1200000),
            ('N04', 'SP01', 10, 6200000),
            ('N05', 'SP05', 20, 7000000)
            
INSERT INTO PXUAT
    VALUES  ('X01', '06-14-2020', 'NV02'),
            ('X02', '03-05-2019', 'NV03'),
            ('X03', '12-12-2020', 'NV01'),
            ('X04', '06-02-2020', 'NV02'),
            ('X05', '05-18-2020', 'NV01')

INSERT INTO XUAT
    VALUES  ('X01', 'SP03', 5),
            ('X02', 'SP01', 3),
            ('X03', 'SP02', 1),
            ('X04', 'SP03', 2),
            ('X05', 'SP05', 1)



--Bài tập
-- 1. Đưa ra các thông tin về các hóa đơn mà hãng Samsung đã nhập trong năm 2020, gồm: SoHDN,
-- MaSP, TenSP, SoLuongN, DonGiaN, NgayNhap, TenNV, TenPhong.
SELECT x.SOHDN, z.MaSP, TenSP, SoLuongN, DonGiaN, NgayNhap, TenNV, TenPhong
FROM PNHAP x JOIN NHANVIEN y ON x.MANV = y.MANV
             JOIN NHAP z ON x.SOHDN = z.SOHDN
             JOIN SANPHAM t ON z.MASP = t.MASP 
             JOIN HANGSX k ON t.MAHANGSX = k.MAHANGSX
WHERE TENHANG = 'Samsung' AND YEAR(NGAYNHAP) = 2020

-- 2. Đưa ra Top 10 hóa đơn xuất có số lượng xuất nhiều nhất trong năm 2020, sắp xếp theo chiều
-- giảm dần của SoLuongX.
SELECT TOP 10 MASP, SOHDX, SOLUONGX
FROM XUAT
ORDER BY SOLUONGX DESC

-- 3. Đưa ra thông tin 10 sản phẩm có giá bán cao nhất trong cửa hàng, theo chiều giảm dần giá bán
SELECT TOP 10 MAHANGSX, MASP, MAUSAC, SOLUONG, TENSP, DONVITINH, MOTA
FROM SANPHAM
ORDER BY GIABAN DESC

-- 4. Đưa ra các thông tin sản phẩm có giá bán từ 100.000 đến 500.000 của hãng Samsung.
SELECT *
FROM SANPHAM x JOIN HANGSX y ON x.MAHANGSX = y.MAHANGSX
WHERE TENHANG = 'Samsung' AND GIABAN BETWEEN 100000 AND 500000


-- 5. Tính tổng tiền đã nhập trong năm 2020 của hãng Samsung.
SELECT SUM(z.SOLUONGN * z.DONGIAN) AS N'Tổng tiền'
FROM SANPHAM x JOIN HANGSX y ON x.MAHANGSX = y.MAHANGSX
               JOIN NHAP z ON x.MASP = z.MASP
               JOIN PNHAP t ON z.SOHDN = t.SOHDN
WHERE TENHANG = 'Samsung' AND YEAR(NGAYNHAP) = 2020


-- 6. Thống kê tổng tiền đã xuất trong ngày 14/06/2020.
SELECT SUM(GIABAN * SOLUONGX) AS N'Tổng tiền xuât'
FROM XUAT x JOIN PXUAT y ON x.SOHDX = y.SOHDX
            JOIN SANPHAM z ON x.MASP = z.MASP
WHERE YEAR(NGAYXUAT) = 2020 AND MONTH(NGAYXUAT) = 6 AND DAY(NGAYXUAT) = 14

SELECT * 
FROM PXUAT
-- 7. Đưa ra SoHDN, NgayNhap có tiền nhập phải trả cao nhất trong năm 2020
select PNhap.SoHDN,PNhap.NgayNhap
	from PNhap join Nhap on PNhap.SoHDN = Nhap.SoHDN
	where YEAR(PNhap.NgayNhap) = 2020
	and Nhap.DonGiaN*Nhap.SoLuongN >= all (select Nhap.SoLuongN*Nhap.DonGiaN
													from Nhap)
													

-- 8. Đưa ra 10 mặt hàng có SoLuongN nhiều nhất trong năm 2019
select top 10 *
from SanPham join Nhap 
	on SanPham.MaSP = Nhap.MaSP
	join PNhap on Nhap.SoHDN = PNhap.SoHDN
where YEAR(PNhap.NgayNhap) = 2019


-- 9. Đưa ra MaSP,TenSP của các sản phẩm do công ty ‘Samsung’ sản xuất do nhân viên có mã
-- ‘NV01’ nhập.
SELECT x.MaSP,TenSP
FROM NHAP x JOIN PNHAP y ON x.SOHDN = y.SOHDN
            JOIN SANPHAM z ON x.MASP = z.MASP
            JOIN HANGSX t ON z.MAHANGSX = t.MAHANGSX
WHERE TENHANG = 'Samsung' AND MANV = 'NV01'
-- 10. Đưa ra Tên Hãng sản xuất có sản phẩm được nhập nhiều nhất
SELECT TENHANG
FROM SANPHAM x JOIN NHAP y ON x.MASP = y.MASP
               JOIN HANGSX z ON x.MAHANGSX = z.MAHANGSX
WHERE SOLUONGN >= ALL(SELECT SOLUONGN
                      FROM NHAP)
-- 11. Đưa tên nhân viên bán được nhiều sản phẩm nhất
SELECT TENNV
FROM PXUAT x JOIN NHANVIEN y ON x.MANV = y.MANV
             JOIN XUAT z ON x.SOHDX = z.SOHDX
WHERE SOLUONGX >= ALL(SELECT SOLUONGX FROM XUAT)
-- 12. Tao View thống kê số lượng sản phẩm bán của từng mặt sản phẩm gồm thông tin: Mã sản phẩm,
-- tên sản phẩm, số lượng bán
CREATE VIEW C12_TKSLSP
AS
SELECT x.MASP, TENSP, SOLUONGX
FROM SANPHAM x JOIN XUAT y ON x.MASP = y.MASP

-- 13. Tạo view thống kê số tiền bán trong từng phiếu xuất thông tin bao gồm: số phiếu xuất, Ngày
-- xuất, số tiền bán
DROP VIEW C13_TKTB
CREATE VIEW C13_TKTB
AS 
SELECT x.SOHDX, NGAYXUAT, GIABAN AS N'Số tiền bán' 
FROM XUAT x JOIN SANPHAM y ON x.MASP = y.MASP
            JOIN PXUAT z ON x.SOHDX = z.SOHDX


-- 14. Tạo view thống kê số lượng sản phẩm nhập theo năm, tháng bao gồm thông tin: năm, tháng, mã
-- sản phẩm, tổng số lượng nhập
CREATE VIEW C14_TK
AS 
SELECT YEAR(NGAYNHAP) AS 'Nam', MONTH(NGAYNHAP) AS 'Thang', MASP, SUM(SOLUONGN) AS 'Tong SLN' 
FROM NHAP x JOIN PNHAP y ON x.SOHDN = y.SOHDN
GROUP BY YEAR(NGAYNHAP), MONTH(NGAYNHAP), MASP
-- 15. Tạo view thống kê số tiền bán hàng theo ngày bao gồm các thông tin: Ngày bán, tổng số tiền bán
CREATE VIEW C15_TK
AS
SELECT  DAY(NGAYXUAT) AS 'Ngày', SUM(SOLUONGX*GIABAN) AS 'Tổng số tiền bán'
FROM XUAT x JOIN PXUAT y ON x.SOHDX = y.SOHDX
            JOIN SANPHAM z ON x.MASP = z.MASP
GROUP BY DAY(NGAYXUAT) 



