-- 1. Hãy thống kê xem mỗi hãng sản xuất có bao nhiêu loại sản phẩm
SELECT x.MAHANGSX, TENHANG, COUNT(*) AS N'Tổng sản phẩm'
FROM Sanpham x JOIN Hangsx y ON x.MAHANGSX = y.MAHANGSX
GROUP BY x.MAHANGSX, TENHANG

SELECT * 
FROM Sanpham
-- 2. Hãy thống kê xem tổng tiền nhập của mỗi sản phẩm trong năm 2020.
SELECT x.MASP, TENSP, SUM(SOLUONGN*DONGIAN) AS N'Tổng tiền nhập'
FROM NHAP x JOIN Sanpham y ON x.MASP = y.MASP
WHERE YEAR(NGAYNHAP) = 2020
GROUP BY x.MASP, TENSP

SELECT *
FROM NHANVIEN

-- 3. Hãy thống kê các sản phẩm có tổng số lượng xuất năm 2020 là lớn hơn 1 sản
-- phẩm của hãng samsung.
SELECT x.MASP, TENSP, TENHANG, SUM(SOLUONGX) AS N'Tổng số lượng xuất'
FROM Sanpham x JOIN XUAT y ON x.MASP = y.MASP
               JOIN Hangsx z ON x.MAHANGSX = z.MAHANGSX
WHERE YEAR(NGAYXUAT) = 2020 AND TENHANG = 'Samsung'
GROUP BY x.MASP, TENSP, TENHANG
HAVING SUM(SOLUONGX) >= 1

-- 4. Thống kê số lượng nhân viên Nam của mỗi phòng ban.
SELECT MANV, TENNV, PHONG, COUNT(*) AS N'Số NV Nam'
FROM NHANVIEN
WHERE GIOITINH = 'Nam'
GROUP BY PHONG, MANV, TENNV


-- 5. Thống kê tổng số lượng nhập của mỗi hãng sản xuất trong năm 2020.
SELECT TENHANG, x.MAHANGSX, SUM(SOLUONGN) AS N'Tổng số lượng nhập'
FROM Sanpham x JOIN NHAP y ON x.MASP = y.MASP
               JOIN Hangsx z ON x.MAHANGSX = z.MAHANGSX
WHERE YEAR(NGAYNHAP) = 2020
GROUP BY TENHANG, x.MAHANGSX

-- 6. Hãy thống kê xem tổng lượng tiền xuất của mỗi nhân viên trong năm 2020 là bao
-- nhiêu.
SELECT x.MANV, TENNV, SUM(SOLUONGX*GIABAN) AS N'Tổng tiền xuất'
FROM XUAT x JOIN NHANVIEN y ON x.MANV = y.MANV
            JOIN Sanpham z ON x.MASP = z.MASP
WHERE YEAR(NGAYXUAT) = 2020
GROUP BY x.MANV, TENNV



-- 7. Hãy đưa ra tổng tiền nhập của mỗi nhân viên trong tháng 7 – năm 2020 có tổng giá
-- trị lớn hơn 100.000
SELECT x.MANV, TENNV, SUM(SOLUONGN*DONGIAN) AS N'Tổng tiền nhập'
FROM NHAP x JOIN NHANVIEN y ON x.MANV = y.MANV
WHERE MONTH(NGAYNHAP) = 7 AND YEAR(NGAYNHAP) = 2020
GROUP BY x.MANV, TENNV
HAVING SUM(SOLUONGN*DONGIAN) > 100.000

-- 8. Hãy đưa ra danh sách các sản phẩm đã nhập nhưng chưa xuất bao giờ.
SELECT x.MASP, TENSP 
FROM Sanpham x JOIN NHAP y ON x.MASP = y.MASP
WHERE x.MASP NOT IN (SELECT MASP
                     FROM XUAT)


-- 9. Hãy đưa ra danh sách các sản phẩm đã nhập năm 2020 và đã xuất năm 2020.
SELECT TENSP, SOLUONG, MAUSAC, MAHANGSX, GIABAN, DONVITINH, MOTA
FROM Sanpham x JOIN NHAP y ON x.MASP = y.MASP
               JOIN XUAT z ON x.MASP = z.MASP
WHERE YEAR(NGAYNHAP) = 2020 AND YEAR(NGAYXUAT) = 2020


-- 10. Hãy đưa ra danh sách các nhân viên vừa nhập vừa xuất..
SELECT TENNV, SODT, PHONG, GIOITINH, DIACHI, EMAIL
FROM NHANVIEN
WHERE MANV IN (SELECT MANV FROM NHAP) 
  AND MANV IN (SELECT MANV FROM XUAT)


-- 11. Hãy đưa ra danh sách các nhân viên không tham gia việc nhập và xuất.
SELECT TENNV, SODT, PHONG, GIOITINH, DIACHI, EMAIL
FROM NHANVIEN
WHERE MANV NOT IN (SELECT MANV FROM NHAP) 
  AND MANV NOT IN (SELECT MANV FROM XUAT)