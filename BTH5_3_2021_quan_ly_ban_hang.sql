--Thủ tục nội tại
--VD1: thủ tục không tham số


-- CREATE PROCEDURE sp_Vd1
-- AS
--     SELECT SUM(soLuongXuat*DonGia)
--     FROM HANG x JOIN DONG_PHIEU_XUAT y ON x.MaHang = y.MaHang
--                 JOIN PHIEU_XUAT z ON y.SoPhieu = z.SoPhieu
--     WHERE MONTH(NgayXuat) = 2 AND YEAR(NgayXuat) = 2021



ALTER PROCEDURE sp_Vd1
AS
    DECLARE @t INT = 0
    SELECT @t = SUM(soLuongXuat*DonGia)
    FROM HANG x JOIN DONG_PHIEU_XUAT y ON x.MaHang = y.MaHang
                JOIN PHIEU_XUAT z ON y.SoPhieu = z.SoPhieu
    WHERE MONTH(NgayXuat) = 2 AND YEAR(NgayXuat) = 2021
    PRINT N'Tong tien hang la: ' + CONVERT(VARCHAR(10), @t)

DROP PROCEDURE sp_Vd1
EXECUTE sp_Vd1



--VD2: Viết thủ tục nội tại tính tổng giá trị một phiếu xuất
CREATE PROCEDURE sp_VD2 @sopx INT
AS
    DECLARE @tong INT
    SELECT @tong = SUM(soLuongXuat*DonGia)
    FROM HANG x JOIN DONG_PHIEU_XUAT y ON x.MaHang = y.MaHang
    WHERE SoPhieu = @sopx
    IF(@tong is null)
        PRINT N'Khong co phieu xuat nao'
    ELSE    
        PRINT N'Tong tien hang cua phieu ' + CONVERT(CHAR(5), @sopx) + ' = ' + CONVERT(VARCHAR(10), @tong)


EXECUTE sp_VD2 3
EXEC sp_VD2 @sopx = 10
select * from DONG_PHIEU_XUAT
select * from HANG


--Tham số OUT PUT
--VD3: Viết lại vd2 -  Viết thủ tục nội tại tính tổng giá trị một phiếu xuất

CREATE PROCEDURE sp_VD3 @sopx INT, @tong INT OUTPUT
AS
    SELECT @tong = SUM(soLuongXuat*DonGia)
    FROM HANG x JOIN DONG_PHIEU_XUAT y ON x.MaHang = y.MaHang
    WHERE SoPhieu = @sopx


DECLARE @kq INT
EXEC sp_VD3 3, @kq OUTPUT
IF(@kq is null)
        PRINT N'Khong co phieu xuat nao'
ELSE    
        PRINT N'Tong tien hang cua phieu = ' + CONVERT(VARCHAR(10), @kq)



--VD4: Thủ tục nhiều tham số
--Viết thủ tục tính ra số tiền hàng của một nhà cung cấp
--Thủ tục có tham số là tên nhà cung cấp và tên hàng


--Lưu ý phải cùng kiểu dữ liệu

CREATE PROCEDURE sp_VD4 @tenncc VARCHAR(50), @tenhang VARCHAR(50)
AS
    DECLARE @tong INT
    SELECT @tong = SUM(SoLuongCo*DonGia)
    FROM HANG x JOIN NHACC y ON x.MaNCC = y.MaNCC
    WHERE TenNCC = @tenncc AND TenHang = @tenhang
    PRINT N'Tổng tiền của nhà cung cấp ' + @tenncc + 
          N' cung cấp mặt hàng ' + @tenhang + ' = ' + 
          CONVERT(VARCHAR(5), @tong)



ALTER PROC sp_VD4 @tenncc nvarchar(50), @tenhang nvarchar(50)
AS
	--Kiểm tra nhà cc có trong bảng NCC hay ko
	if not exists(select * from NHACC where TenNCC = @tenncc)
	begin
        RAISERROR(N'Nhà cung cấp không tồn tại', 16, 1)
		--print N'Nhà cung cấp không tồn tại'
		return --Thoát khỏi CT
	end
	--Kiểm tra mặt hàng có tồn tại ko
	if not exists(select * from HANG where TenHang = @tenhang)
	begin
		print N'Mặt hàng không tồn tại'
		return 
	end
	--Kiểm tra nhà cung cấp có cung cấp cho mặt hàng này ko
	if not exists(select * from NHACC n join HANG h on n.MaNCC = h.MaNCC where TenHang = @tenhang and TenNCC = @tenncc)
	begin
		print N'Nhà cung cấp ' + @tenncc + N' không cung cấp mặt hàng ' + @tenhang
		return 
	end
	declare @tong int
	select @tong = sum(SoLuongCo*DonGia)
	from NHACC n join HANG h on n.MaNCC = h.MaNCC
	where TenNCC = @tenncc and TenHang = @tenhang
	print N'Tổng tiền của nhà cung cấp ' + @tenncc + N' cung cấp mặt hàng ' + @tenhang + ' = ' + convert(varchar(5), @tong)

exec sp_VD4 'Samsung', 'DVD Samsung DVD-E360/XV'
exec sp_VD4 'LG', 'DVD Samsung DVD-E360/XV'
exec sp_VD4 'Hitachi', 'DVD Samsung DVD-E360/XV'
exec sp_VD4 'LG', 'Máy giặt'


SELECT * FROM HANG
SELECT * FROM NHACC




--THỦ TỤC CẬP NHẬT DỮ LIỆU
--VD5: Viết thủ tục thêm dữ liệu vào bảng HANG
--Mã hàng 0 tồn tại
--Nhà cung cấp tồn tại
--Đơn giá phải lớn hơn 0
--Số lượng phải lớn hơn 0

ALTER PROC sp_cau5 @mah char(5), @tenh nvarchar(50), @gia int, @sl int, @mancc char(4)
AS
	if exists(select * from HANG where MaHang = @mah)
		begin
			raiserror (N'Mã hàng đã tồn tại', 16, 1)
			return
		end
	if not exists(select * from NHACC where MaNCC = @mancc)
	begin
		raiserror (N'Nhà cung cấp không tồn tại', 16, 1)
		return
	end
	if @gia < 0 
	begin
			raiserror (N'Đơn giá phải lớn hơn 0', 16, 1)
			return
	end
	if @sl < 0 
	begin
			raiserror (N'Số lượng phải lớn hơn 0', 16, 1)
			return
	end
	INSERT INTO HANG VALUES(@mah, @tenh, @gia, @sl, @mancc)

exec sp_cau5 'P001', 'Máy giặt', 12, 120, 'S002'
exec sp_cau5 'P011', 'Máy giặt', 12, 120, 'S010'
exec sp_cau5 'P011', 'Máy giặt', 12, 120, 'S002'
exec sp_cau5 'P012', 'Máy giặt', -3 , 120, 'S002'
select * from HANG



