USE master
GO
-- Tạo CSDL QuanLyBanHang
CREATE DATABASE QuanLyBanHang 
GO
-- Kết nối với CSDL muốn làm việc
USE QuanLyBanHang
GO
-- Tạo bảng Nhà cung cấp

CREATE TABLE NHACC
(
	MaNCC	char(4) PRIMARY KEY ,
	TenNCC	nvarchar(50) NOT NULL,
	DiaChi	nvarchar(100)  NULL,
	DienThoai	char(12) NOT NULL,
	CONSTRAINT chk_MaNCC CHECK (MaNCC LIKE '[S][0-9][0-9][0-9]') 
)
GO
-- Thêm dữ liệu vào bảng NhaCC
INSERT INTO NhaCC(MaNCC, TenNCC, DiaChi, DienThoai)
VALUES('S001','Samsung',N'Hà nội','123456'),
('S002','LG',N'Huế','234567'),
('S003','Sharp',N'Đà nẵng','345678'),
('S004','Sony',N'HCM','456789')

GO
 -- Tạo bảng Hàng
 CREATE TABLE HANG
 (
	MaHang char(5) PRIMARY KEY,
	TenHang nvarchar(50) NOT NULL,
	DonGia int NOT NULL,
	SoLuongCo int NOT NULL DEFAULT(0),
	MaNCC char(4) NOT NULL,
	CONSTRAINT fk_Hang_NhaCC FOREIGN KEY(MaNCC) REFERENCES NhaCC(MaNCC)
 )
 GO
 INSERT INTO HANG(MaHang,TenHang,DonGia,SoLuongCo,MaNCC)
 VALUES('P001',N'Ti vi LG 49UH600T',10,100,'S002'),
 ('P002',N'Tivi Sony 49X7000D',20,200,'S004'),
 ('P003',N'DVD Samsung DVD-E360/XV',30,300,'S001'),
 ('P004',N'DVD Sony Midi 888HD',40,400,'S004'),
 ('P005',N'Dàn âm thanh LG ARX5500',50,500,'S002'),
 ('P006',N'Đầu thu kỹ thuật số T202-HD',60,600,'S002')

 GO
 -- Tạo bảng Phiếu xuất
CREATE TABLE PHIEU_XUAT
(
	SoPhieu int IDENTITY(1,1) PRIMARY KEY,
	NgayXuat Date DEFAULT(GETDATE()),
	MaCuaHang char(4) NOT NULL 
)
GO
INSERT INTO PHIEU_XUAT(MaCuaHang)
VALUES('A001'),('A002'),('A003'),('A004')
GO
 -- Tạo bảng Dòng phiếu xuất
 CREATE TABLE DONG_PHIEU_XUAT
 (
	SoPhieu int NOT NULL,
	MaHang char(5) NOT NULL,
	SoLuongXuat int NOT NULL,
	CONSTRAINT fk_PhieuXuat FOREIGN KEY(SoPhieu) REFERENCES PHIEU_XUAT(SoPhieu),
	CONSTRAINT fk_Hang FOREIGN KEY(MaHang) REFERENCES HANG(MaHang),
	CONSTRAINT pk_Dong_Phieu_Xuat PRIMARY KEY(SoPhieu,MaHang)
)
GO

--
INSERT INTO DONG_PHIEU_XUAT(SoPhieu,MaHang,SoLuongXuat)
VALUES(1,'P001',1)
INSERT INTO DONG_PHIEU_XUAT(SoPhieu,MaHang,SoLuongXuat)
VALUES(1,'P002',2)
INSERT INTO DONG_PHIEU_XUAT(SoPhieu,MaHang,SoLuongXuat)
VALUES(2,'P001',1)
INSERT INTO DONG_PHIEU_XUAT(SoPhieu,MaHang,SoLuongXuat)
VALUES(2,'P004',3)
INSERT INTO DONG_PHIEU_XUAT(SoPhieu,MaHang,SoLuongXuat)
VALUES(2,'P002',3)
INSERT INTO DONG_PHIEU_XUAT(SoPhieu,MaHang,SoLuongXuat)
VALUES(2,'P005',3)
INSERT INTO DONG_PHIEU_XUAT(SoPhieu,MaHang,SoLuongXuat)
VALUES(3,'P001',1)
INSERT INTO DONG_PHIEU_XUAT(SoPhieu,MaHang,SoLuongXuat)
VALUES(4,'P003',5)
INSERT INTO DONG_PHIEU_XUAT(SoPhieu,MaHang,SoLuongXuat)
VALUES(4,'P004',5)
INSERT INTO DONG_PHIEU_XUAT(SoPhieu,MaHang,SoLuongXuat)
VALUES(4,'P005',6)

--1 Đưa ra mã, tên nhà cung cấp, cung cấp sản phẩm có giá > 10  và tên bắt đầu bởi chữ 'S'
SELECT x.MaNCC, TenNCC
FROM NHACC x JOIN HANG y ON x.MaNCC = y.MaNCC
WHERE DonGia > 10 AND TenNCC LIKE 'S%'


-- 2. Đưa ra các mặt hàng có giá nhỏ hơn giá của tất cả mặt hàng do hãng SamSung cung cấp	
--C1
SELECT MaHang, TenHang, DonGia
FROM HANG x JOIN NHACC y ON x.MaNCC = y.MaNCC
WHERE DonGia <= ALL(SELECT DonGia 
				   FROM HANG x JOIN NHACC y ON x.MaNCC = y.MaNCC
				   WHERE TenHang = 'Samsung')
--C2
SELECT MaHang, TenHang, DonGia
FROM HANG
WHERE DonGia <= ALL(SELECT DonGia 
				   FROM HANG x JOIN NHACC y ON x.MaNCC = y.MaNCC
				   WHERE TenHang = 'Samsung')


-- 3. Đưa ra các phiếu xuất bán từ 2 mặt hàng trở lên
SELECT MaCuaHang, NgayXuat, x.SoPhieu
FROM PHIEU_XUAT x JOIN DONG_PHIEU_XUAT y ON x.SoPhieu = y.SoPhieu
GROUP BY MaCuaHang, NgayXuat, x.SoPhieu
HAVING COUNT(MaHang) >= 2

--4. Đưa ra các mặt hàng có số lượng bán nhiều nhất
SELECT x.MaHang, TenHang, DonGia
FROM HANG x JOIN DONG_PHIEU_XUAT y ON x.MaHang = y.MaHang
WHERE SoLuongXuat = (SELECT MAX(SoLuongXuat)
					 FROM HANG x JOIN DONG_PHIEU_XUAT y ON x.MaHang = y.MaHang
					 )

-- 5. Đưa ra tên nhà cung cấp, cung cấp sản phẩm có đơn giá đắt nhất
SELECT TenNCC
FROM NHACC x JOIN HANG y ON x.MaNCC = y.MaNCC
WHERE DonGia = (SELECT MAX(DonGia) 
				FROM NHACC x JOIN HANG y ON x.MaNCC = y.MaNCC
				)


-- 6. Đưa ra danh sách sản phẩm bán chạy nhất trong tháng hiện tại
SELECT y.MaHang, TenHang, SUM(SoLuongXuat) AS N'Tổng sản phẩm'
FROM DONG_PHIEU_XUAT x JOIN HANG y ON x.MaHang = y.MaHang
					   JOIN PHIEU_XUAT z ON x.SoPhieu = z.SoPhieu
WHERE MONTH(NgayXuat) = MONTH(GETDATE())
GROUP BY y.MaHang, TenHang
HAVING SUM(SoLuongXuat) >= ALL (SELECT SUM(SoLuongXuat)
								FROM DONG_PHIEU_XUAT x JOIN PHIEU_XUAT z ON x.SoPhieu = z.SoPhieu
								WHERE MONTH(NgayXuat) = MONTH(GETDATE())
								GROUP BY x.MaHang)
								
-- 7. Đưa ra ds sản phẩm chưa từng bán
SELECT *
FROM HANG
WHERE MaHang NOT IN (SELECT MaHang
				     FROM DONG_PHIEU_XUAT)

--9. Cập nhật số lượng mua của phiếu 1, mặt hàng 'P001' thành 5 sản phẩm
UPDATE DONG_PHIEU_XUAT
SET SoLuongXuat = 5
WHERE MaHang = 'P001' AND SoPhieu = 1

SELECT *
FROM DONG_PHIEU_XUAT

--8.Cập nhật lại giá các sản phẩm của nhà cung cấp LG giảm 10%, hãng Samsung tăng lên 5%
UPDATE HANG
SET DonGia = DonGia * CASE
WHEN TenNCC LIKE 'LG' THEN 0.9
WHEN TenNCC LIKE 'Samsung' THEN 1.05
ELSE 1 END
FROM HANG x JOIN NHACC y ON x.MaNCC = y.MaNCC

SELECT *
FROM DONG_PHIEU_XUAT


-- 9. Xóa mặt hàng 'P002' trong phiếu 2
DELETE FROM DONG_PHIEU_XUAT
WHERE MaHang = 'P002' AND SoPhieu = 2


--11: Tạo view đưa ra tên hàng và số lượng xuất của mỗi mặt hàng
CREATE VIEW v_c11
AS 
SELECT TENHANG, SOLUONGXUAT
FROM HANG x JOIN DONG_PHIEU_XUAT y ON x.MaHang = y.MaHang

SELECT * 
FROM v_c11

-- 12. Tạo view đưa ra các phiếu xuất xuất hàngtrong năm nay thông tn bao gồm, SoPhieu, NgayXuat, MaHang, TenHang, ThanhTien
CREATE VIEW v_c12
AS
SELECT x.SoPhieu, NgayXuat, x.MaHang, TenHang, DonGia*SoLuongXuat AS N'Thanh tien'
FROM DONG_PHIEU_XUAT x JOIN HANG y ON x.MaHang = y.MaHang
					   JOIN PHIEU_XUAT z ON x.SoPhieu = z.SoPhieu

SELECT *
FROM v_c12

--13. Tao View thống kê số lượng hàng bán của từng mặt hàng gồm thông tin: Mã hàng, tên hàng, số lượng bán
CREATE VIEW v_c13
AS
SELECT  x.MaHang, TenHang, SUM(SoLuongXuat) AS 'Số lượng bán'
FROM HANG x JOIN DONG_PHIEU_XUAT y ON x.MaHang = y.MaHang
GROUP BY x.MaHang, TenHang


-- 14. Hãy tạo View đưa ra thống kê tiền hàng bán theo từng phiếu xuất gồm: SoPhieu,NgayBan,Tổng tiền (tiền=SoLuong*DonGia)
CREATE VIEW v_c14
AS
SELECT x.SoPhieu, NgayXuat, SUM(SoLuongXuat*DonGia) AS N'Tổng tiền'
FROM DONG_PHIEU_XUAT x JOIN HANG y ON x.MaHang = y.MaHang
					   JOIN PHIEU_XUAT z ON x.SoPhieu = z.SoPhieu
GROUP BY x.SoPhieu, NgayXuat

SELECT *
FROM v_c14

--15 Tạo view thống kê số lượng hàng bán theo năm, tháng bao gồm thông tin: năm, tháng, mã hàng, tổng số lượng bán
CREATE VIEW v_c15
AS 
SELECT YEAR(NgayXuat) AS 'Năm', MONTH(NgayXuat) AS 'Tháng', MaHang, SUM(SoLuongXuat) AS 'Tổng sl bán'
FROM DONG_PHIEU_XUAT x JOIN PHIEU_XUAT y ON x.SoPhieu = y.SoPhieu
GROUP BY MaHang, YEAR(NgayXuat), MONTH(NgayXuat)

SELECT *
FROM v_c15




