--QuanLyBanHang


--HÀM NGƯỜI DÙNG TỰ ĐỊNH NGHĨA
--HÀM VÔ HƯỚNG
--Viết hàm tính đơn giá trung bình mặt hàng
-- CREATE FUNCTION fn_VD1()
-- RETURNS REAL
-- AS
-- BEGIN
--     DECLARE @a REAL
--     SELECT @a = AVG(DonGia) FROM HANG
--     RETURN @a
-- END

-- SELECT dbo.fn_VD1()


CREATE FUNCTION code_VD1()
RETURNS REAL
AS
BEGIN
    DECLARE @a REAL
    SELECT @a = AVG(DonGia)
    FROM HANG
    RETURN @a
END

SELECT dbo.code_VD1()
---------------------------------------------------------------------------------------------------

--VD2: Hãy xây dựng hàm đưa ra tên nhà cung cấp khi nhập vào MaNcc từ bàn phím
CREATE FUNCTION fn_VD2(@MaNcc CHAR(4))
RETURNS NVARCHAR(50)
AS
BEGIN
    DECLARE @TenNcc NVARCHAR(50)
    SELECT @TenNcc = TenNCC FROM NHACC 
    WHERE MaNCC = @MaNcc
    RETURN  @TenNcc
END


SELECT * FROM NHACC

SELECT dbo.fn_VD2('S001') AS TenNCC




--VD3: Hãy xây dựng hàm đưa ra tổng giá trị xuất từ năm nhập x đến năm nhập y
--      với x, y được nhập từ bàn phím
CREATE FUNCTION fn_VD3(@YearX INT, @YearY INT)
RETURNS INT
AS
BEGIN
    DECLARE @sum INT
    SELECT @sum = SUM(SoLuongXuat * DonGia)
    FROM DONG_PHIEU_XUAT x JOIN PHIEU_XUAT y ON x.SoPhieu = y.SoPhieu
                           JOIN HANG z ON x.MaHang = z.MaHang
    WHERE YEAR(NgayXuat) BETWEEN @YearX AND @YearY
    RETURN @sum
END

SELECT dbo.fn_VD3(2021, 2022)
SELECT * FROM PHIEU_XUAT
SELECT * FROM DONG_PHIEU_XUAT
SELECT * FROM HANG



--VD4: Hãy viết hàm thống kê xem sản phẩm tên x đã xuất được số lượng 
--      bao nhiêu trong ngày y, với x và y nhập từ bàn phím
CREATE FUNCTION fn_VD4(@TenHang NVARCHAR(50), @NgayXuat DATE)
RETURNS INT
AS
BEGIN
    DECLARE @sum INT
    SELECT @sum = SUM(SoLuongXuat)
    FROM DONG_PHIEU_XUAT x JOIN HANG y ON x.MaHang = y.MaHang
                           JOIN PHIEU_XUAT z ON x.SoPhieu = z.SoPhieu
                           WHERE TenHang = @TenHang AND NgayXuat = @NgayXuat
    RETURN @sum
END

SELECT dbo.fn_VD4('Samsung', '2021-02-05')



-------------------------------------------
--Hàm Inline table
--VD1: Viết hàm trả lại mã hàng, tên hàng, và số lượng đã bán của từng mặt hàng
--      của một nhà cung cập có tên do người dùng nhập
-- CREATE FUNCTION fn_h1(@TenNcc NVARCHAR(50))
-- RETURNS TABLE
-- AS
-- RETURN
--     SELECT y.MaHang, TenHang, SUM(SoLuongXuat) AS 'TongSLXuat'
--     FROM NHACC x JOIN HANG y ON x.MaNCC = y.MaNCC
--                  JOIN DONG_PHIEU_XUAT z ON y.MaHang = z.MaHang
--     WHERE TenNCC = @TenNcc
--     GROUP BY y.MaHang, TenHang

-- SELECT * FROM dbo.fn_h1('Samsung')

CREATE FUNCTION code_VDIL1(@TenNcc NVARCHAR(50))
RETURNS TABLE
AS
RETURN
    SELECT x.MaHang, TenHang, SUM(SoLuongXuat) AS 'Tong'
    FROM HANG x JOIN DONG_PHIEU_XUAT y ON x.MaHang = y.MaHang
                JOIN NHACC z ON x.MaNCC = z.MaNCC
    WHERE TenNcc = @TenNcc
    GROUP BY x.MaHang, TenHang


SELECT * FROM dbo.code_VDIL1('Samsung')








-------------------------------
--HÀM MULTI_STATEMENT TABLE
--VD3: Viết hàm trả lại bảng mới gồm các cột mã hàng, tên hàng,
--     đơn giá khuyến mại của các mặt hàng có số lượng có >= 500
--     đơn giá khuyến mại = đơn giá * 0.8(Giảm 20%)
-- CREATE FUNCTION fnn_VD3()
-- RETURNS @bang TABLE(MaHang CHAR(5), TenHang NVARCHAR(50), DGKM REAL)
-- AS
-- BEGIN
--     INSERT INTO @bang
--     SELECT MaHang, TenHang, DonGia * 0.8
--     FROM HANG
--     WHERE SoLuongCo >= 500
--     RETURN
-- END

-- SELECT * FROM dbo.fnn_VD3()

CREATE FUNCTION code_VDMS1()
RETURNS @bang TABLE(MaHang CHAR(5), TenHang NVARCHAR(50), DGKM REAL)
AS
BEGIN
    INSERT INTO @bang
    SELECT MaHang, TenHang, DonGia * 0.8
    FROM HANG
    WHERE SoLuongCo >= 500
    RETURN
END



--VD4: Viết hàm trả lại mã hàng, tên hàng, và số lượng đã bán của từng mặt hàng
--      của một nhà cung cập có tên do người dùng nhập

CREATE FUNCTION fnn_VD4(@TenNcc NVARCHAR(50))
RETURNS @bangmoi TABLE (MaHang CHAR(5), TenHang NVARCHAR(50), SlBan INT)
AS
BEGIN
    INSERT INTO @bangmoi
    SELECT y.MaHang, TenHang, SUM(SoLuongXuat)
    FROM NHACC x JOIN HANG y ON x.MaNCC = y.MaNCC
                 JOIN DONG_PHIEU_XUAT z ON y.MaHang = z.MaHang
    WHERE TenNCC = @TenNcc
    GROUP BY y.MaHang, TenHang
    RETURN
END


SELECT * FROM dbo.fnn_VD4('LG')


--VD5: Hãy xây dựng hàm đưa ra danh sách các mặt hàng theo nhà cung cấp và một lựa chọn,
--      nếu lựa chọn = 0 thì đưa ra danh sách các sản phẩm có số lượng <= 200
--      nếu lựa chọn = 1 thì đưa ra danh sách các sản phẩm có số lượng > 200
CREATE FUNCTION fnn_VD5(@TenNCC NVARCHAR(50), @LuaChon INT)
RETURNS @bang_VD5 TABLE (MaHang CHAR(5), TenHang NVARCHAR(50), DonGia INT, TenNcc NVARCHAR(50))
AS
BEGIN
    IF(@LuaChon = 0)
        BEGIN
            INSERT INTO @bang_VD5
            SELECT MaHang, TenHang, DonGia, TenNcc
            FROM HANG x JOIN NHACC y ON x.MaNcc = y.MaNcc
            WHERE SoLuongCo <= 200 AND TenNCC = @TenNCC
        END
    ELSE
        BEGIN
            INSERT INTO @bang_VD5
            SELECT MaHang, TenHang, DonGia, TenNcc
            FROM HANG x JOIN NHACC y ON x.MaNcc = y.MaNcc
            WHERE SoLuongCo > 200 AND TenNCC = @TenNCC
        END
    RETURN
END

SELECT * FROM dbo.fnn_VD5('LG', 1)
