-----------------------------------------------------------------
DECLARE @name VARCHAR(70), @age INT = 20
SET @name = 'Le Minh Hung'
-- PRINT N'Ten:' + @name
-- PRINT N'Tuoi:' + CONVERT(char(2), @age)
SELECT @name, @age


-----------------------------------------------------------------
DECLARE @totalPrice INT
SELECT @totalPrice = SUM(GIABAN * SOLUONGX)
FROM XUAT x JOIN PXUAT y ON x.SOHDX = y.SOHDX
            JOIN SANPHAM z ON x.MASP = z.MASP
WHERE YEAR(NGAYXUAT) = 2020 AND MONTH(NGAYXUAT) = 6 AND DAY(NGAYXUAT) = 14

PRINT N'Tổng tiền: ' + CONVERT(VARCHAR(10), @totalPrice)

SELECT CONVERT(char(10), GETDATE(), 103)



SELECT * FROM PXUAT
SELECT @@ROWCOUNT



-----------------------------------------------------------------

IF(SELECT COUNT(*) FROM SANPHAM WHERE SOLUONG > 1000) > 0 
    SELECT * FROM SANPHAM WHERE SOLUONG > 1000
ELSE 
    PRINT N'Khong co'


IF EXISTS (SELECT *FROM PHIEU_XUAT WHERE MaCuaHang = 'A004')
BEGIN
    PRINT N'Danh sách các phiếu xuất cho cửa hàng A004'
    SELECT *FROM PHIEU_XUAT WHERE MaCuaHang = 'A004'
END
ELSE 
    PRINT N'Không có phiếu nào'



-----------------------------------------------------------------
DECLARE @kt CHAR(1)
SET @kt = 'A'
WHILE @kt <> 'M'
BEGIN
    PRINT N'Mã ASCII của ' + @kt + CONVERT(CHAR(2), ASCII(@kt))
    SET @kt = CHAR(ASCII(@kt) + 1)
END



-----------------------------------------------------------------
SELECT MaHang, TenHang INTO HANG_VD
FROM HANG

SELECT * FROM HANG_VD

WHILE(SELECT COUNT(*) FROM HANG_VD) > 0
BEGIN
    DECLARE @mahangxoa CHAR(5), @tenHangXoa NVARCHAR(50)
    SELECT TOP 1 @mahangxoa = MaHang, @tenHangXoa = tenHang FROM HANG_VD
    DELETE FROM HANG_VD WHERE MaHang = @mahangxoa
    PRINT N'Đang xóa mặt hàng' + @tenHangXoa
END


INSERT INTO HANG_VD SELECT MaHang, TenHang FROM HANG
SELECT * FROM HANG_VD

-----------------------------------------------------------------

-- VD2: Hiển thị thông tin các mặt hàng được bán với số lượng lớn hơn 7.
-- Nếu không có mặt hàng nào thì in ra chuỗi 'chưa có mặt hàng nào được
-- bán với số lượng >7'


--Cach 1
IF EXISTS(SELECT * FROM (SELECT MaHang
                         FROM DONG_PHIEU_XUAT
                         GROUP BY MaHang
                         HAVING SUM(SoLuongXuat) > 7) AS T1)
BEGIN                          
SELECT *
FROM HANG
WHERE MaHang IN (SELECT MaHang
                 FROM DONG_PHIEU_XUAT
                 GROUP BY MaHang
                 HAVING SUM(SoLuongXuat) > 7)
END
ELSE 
      PRINT N'chưa có mặt hàng nào được bán với số lượng >7'
GO

--Canh 2
IF (SELECT COUNT(*) FROM (SELECT MaHang
                         FROM DONG_PHIEU_XUAT
                         GROUP BY MaHang
                         HAVING SUM(SoLuongXuat) > 7) AS T1) > 0
BEGIN                          
SELECT *
FROM HANG
WHERE MaHang IN (SELECT MaHang
                 FROM DONG_PHIEU_XUAT
                 GROUP BY MaHang
                 HAVING SUM(SoLuongXuat) > 7)
END
ELSE 
      PRINT N'chưa có mặt hàng nào được bán với số lượng >7'
GO


-----------------------------------------------------------------
IF EXISTS(SELECT * FROM (SELECT * 
            FROM PHIEU_XUAT
            WHERE MaCuaHang = 'A006') AS T1)
SELECT * 
FROM PHIEU_XUAT
WHERE MaCuaHang = 'A006'
ELSE 
    PRINT N'Không có phiếu nào xuất cho cửa hàng A006'
    
    
    
--BTVN
--B1
-- DECLARE @dayName VARCHAR(9);
-- SET @dayName = DATENAME(DW, '2021/02/28');
-- IF(@dayName = 'Sunday') 
--     PRINT 'Weekend';
-- ELSE
--     PRINT N'no no no';

IF EXISTS(SELECT * FROM(SELECT * 
                        FROM PHIEU_XUAT 
                        WHERE DATENAME(DW, NgayXuat) = 'Sunday') AS T1)
SELECT *
FROM HANG
WHERE MaHang IN (SELECT MaHang
                 FROM DONG_PHIEU_XUAT x JOIN PHIEU_XUAT y ON x.SoPhieu = y.SoPhieu
                 WHERE DATENAME(DW, NgayXuat) = 'Sunday')
ELSE 
    PRINT N'Không có mặt hàng nào được bán trong ngày chủ nhật'


--B2
SELECT MaHang, TenHang, DonGia INTO HANG_BT2 FROM HANG
UPDATE HANG_BT2
SET DonGia = DonGia * CASE
    WHEN DonGia < 3000 AND MaHang = 'P001' THEN 1.1
    ELSE 1
END


DECLARE @RowCnt INT, @index INT = 1, @k INT
SELECT @RowCnt = COUNT(0) FROM HANG_BT2
WHILE(@index <= @RowCnt)
BEGIN
    UPDATE HANG_BT2
    SET DonGia = DonGia * 1.1
    WHERE MaHang = 'P001' AND DonGia < 3000
    PRINT N'Tăng lần ' + CONVERT(CHAR(1), @index) + N' đơn gía là : '
    SET @index = @index + 1
END

SELECT * FROM HANG_BT2

