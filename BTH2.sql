-- 1. Hiển thị thông tin các bảng dữ liệu trên.
SELECT *
FROM Hangsx
SELECT *
FROM NHANVIEN
SELECT *
FROM NHAP
SELECT *
FROM XUAT
SELECT *
FROM Sanpham
-- 2. Đưa ra thông tin masp, tensp, tenhang,soluong, mausac, giaban, donvitinh, mota của
--các sản phẩm sắp xếp theo chiều giảm dần giá bán.
SELECT MASP, TENSP, TENHANG, SOLUONG, MAUSAC, GIABAN, DONVITINH, MOTA
FROM Sanpham x INNER JOIN Hangsx y ON x.MAHANGSX = y.MAHANGSX
ORDER BY GIABAN DESC
-- 3. Đưa ra thông tin các sản phẩm có trong cữa hàng do công ty có tên hãng là samsung
-- sản xuất.
SELECT MASP, TENSP, SOLUONG, MAUSAC, GIABAN, DONVITINH, MOTA
FROM Sanpham x INNER JOIN Hangsx y ON x.MAHANGSX = y.MAHANGSX
WHERE TENHANG = 'Samsung'

-- 4. Đưa ra thông tin các nhân viên Nữ ở phòng ‘Kế toán’.
SELECT *
FROM NHANVIEN
WHERE GIOITINH = N'Nữ' AND PHONG = N'Kế toán'

-- 5. Đưa ra thông tin phiếu nhập gồm: sohdn, masp, tensp, soluongN, dongiaN,
-- tiennhap=soluongN*dongiaN, mausac, donvitinh, ngaynhap, tennv, phong. Sắp xếp
-- theo chiều tăng dần của hóa đơn nhập.
SELECT sohdn, x.masp, tensp, soluongN, dongiaN,
    soluongN*dongiaN AS N'Tiền nhập', mausac, donvitinh, ngaynhap, tennv, phong
FROM NHAP x INNER JOIN Sanpham y ON x.MASP = y.MASP
            INNER JOIN NHANVIEN z ON x.MANV = z.MANV
ORDER BY SOHDN ASC

-- 6. Đưa ra thông tin phiếu xuất gồm: sohdx, masp, tensp, soluongX, giaban,
-- tienxuat=soluongX*giaban, mausac, donvitinh, ngayxuat, tennv, phong trong tháng 10
-- năm 2018, sắp xếp theo chiều tăng dần của sohdx.
SELECT sohdx, x.masp, tensp, soluongX, giaban,
       soluongX*giaban AS N'Tiền Xuất', mausac, donvitinh, ngayxuat, tennv
FROM XUAT x INNER JOIN Sanpham y ON x.MASP = y.MASP
            INNER JOIN NHANVIEN z ON x.MANV = z.MANV
WHERE MONTH(NGAYXUAT) = 10 AND YEAR(NGAYXUAT) = 2018
ORDER BY SOHDX ASC


-- 7. Đưa ra các thông tin về các hóa đơn mà hãng samsung đã nhập trong năm 2017,
-- gồm: sohdn, masp, tensp, soluongN, dongiaN, ngaynhap, tennv, phong.
SELECT sohdn, y.masp, tensp, soluongN, dongiaN, ngaynhap, tennv, phong
FROM NHAP x INNER JOIN Sanpham y ON x.MASP = y.MASP
            INNER JOIN NHANVIEN z ON x.MANV = z.MANV
            INNER JOIN Hangsx t ON y.MAHANGSX = t.MAHANGSX
WHERE TENHANG = 'Samsung' AND YEAR(NGAYNHAP) = 2017


-- 8. Đưa ra Top 10 hóa đơn xuất có số lượng xuất nhiều nhất trong năm 2018, sắp xếp
-- theo chiều giảm dần của soluongX.
SELECT TOP 10 *
FROM XUAT
WHERE YEAR(NGAYXUAT) = 2018
ORDER BY SOLUONGX DESC


-- 9. Đưa ra thông tin 10 sản phẩm có giá bán cao nhất trong cữa hàng, theo chiều giảm
-- dần gía bán.
--Không biết phải lấy bao nhiêu thuộc tính
SELECT TOP 10 MASP, TENSP, GIABAN
FROM Sanpham
ORDER BY GIABAN DESC
-- 10. Đưa ra các thông tin sản phẩm có gía bán từ 100.000 đến 500.000 của hãng
-- samsung.
SELECT masp, tensp, soluong, mausac, giaban, donvitinh, mota
FROM Sanpham x JOIN Hangsx y ON x.MAHANGSX = y.MAHANGSX
WHERE TENHANG = 'Samsung' AND GIABAN BETWEEN 100000.0 AND 50000000.0

SELECT *
FROM Sanpham
-- 11. Tính tổng tiền đã nhập trong năm 2020 của hãng samsung.
SELECT SUM(SOLUONGN*DONGIAN) AS 'Tổng tiền đã nhập'
FROM Sanpham x JOIN NHAP y ON x.MASP = y.MASP
               JOIN Hangsx z ON x.MAHANGSX = z.MAHANGSX
WHERE YEAR(NGAYNHAP) = 2020 AND TENHANG = 'Samsung'



-- 12. Thống kê tổng tiền đã xuất trong ngày 2/9/2018.
SELECT SUM(SOLUONGX*GIABAN) AS 'Tổng tiền đã xuất'
FROM XUAT x JOIN Sanpham y ON x.MASP = y.MASP
WHERE NGAYXUAT = '2/9/2018'


-- 13. Đưa ra sohdn, ngaynhap có tiền nhập phải trả cao nhất trong năm 2020.
SELECT SOHDN , NGAYNHAP
FROM NHAP 
WHERE YEAR(NGAYNHAP) = 2020
            AND SOLUONGN*DONGIAN = (
                                    SELECT MAX(SOLUONGN*DONGIAN)
                                    FROM NHAP
                                    WHERE YEAR(NGAYNHAP) = 2020
                                   )



-- 14. Đưa ra 10 mặt hàng có soluongN nhiều nhất trong năm 2019.

--Chưa rõ phải lấy những bảng nào
SELECT TOP 10 TENHANG, MAUSAC, SOLUONG
FROM Sanpham x JOIN Hangsx y ON x.MAHANGSX = y.MAHANGSX
               JOIN NHAP z ON x.MASP = z.MASP
WHERE YEAR(NGAYNHAP) = 2019 
ORDER BY SOLUONGN


-- 15. Đưa ra masp,tensp của các sản phẩm do công ty ‘Samsung’ sản xuất do nhân viên
-- có mã ‘NV01’ nhập.
SELECT x.MASP, TENSP 
FROM Sanpham x JOIN Hangsx y ON x.MAHANGSX = y.MAHANGSX
               JOIN XUAT z ON x.MASP = z.MASP
WHERE TENHANG = 'Samsung' AND MANV = 'NV01'


-- 16. Đưa ra sohdn,masp,soluongN,ngayNhap của mặt hàng có masp là ‘SP02’, được nhân
-- viên ‘NV02’ xuất.
SELECT sohdn, masp, soluongN, ngayNhap
FROM NHAP x JOIN NHANVIEN y ON x.MANV = y.MANV
WHERE MASP = 'SP02' AND x.MANV = 'NV02'



-- 17. Đưa ra manv,tennv đã xuất mặt hàng có mã ‘SP02’ ngày ’03-02-2020’.
SELECT x.manv, tennv
FROM NHANVIEN x JOIN XUAT y ON x.MANV = y.MANV
WHERE MASP = 'SP02' AND NGAYXUAT = '03-02-2020'

SELECT *
FROM XUAT

-- Sanpham(masp, mahangsx, tensp, soluong, mausac, giaban, donvitinh, mota)
-- Hangsx(mahangsx, tenhang, diachi, sodt, email)
-- Nhanvien(manv, tennv, gioitinh, diachi, sodt, email, phong)
-- Nhap(sohdn, masp, manv, ngaynhap, soluongN, dongiaN)
-- Xuat(sohdx, masp, manv, ngayxuat, soluongX)
