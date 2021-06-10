CREATE DATABASE QLXe
USE QLXe

CREATE TABLE Xe
(
	MaXe char(4) NOT NULL PRIMARY KEY,
	TenXe nvarchar(50),
	SoLuong int
)
CREATE TABLE KhachHang
(
	MaKH char(4) NOT NULL PRIMARY KEY,
	TenKH nvarchar(50), 
	DiaChi nvarchar(50),
	SoDT char(20),
	Email char(50)
)
CREATE TABLE ThueXe
(
	SoHD char(4) PRIMARY KEY,
	MaKH char(4),
	MaXe char(4),
	SoNgayThue int,
	SoLuongThue int,
	FOREIGN KEY(MaKH) REFERENCES KhachHang(MaKH),
	FOREIGN KEY(MaXe) REFERENCES Xe(MaXe)
)

INSERT INTO Xe VALUES
	('X001', N'Xe số 1', 15),
	('X002', N'Xe số 2', 10),
	('X003', N'Xe số 3', 20)
INSERT INTO KhachHang VALUES
	('KH01', N'Nguyễn Thị A', N'Hà Nội', '0966614730', 'huyen@gmail.com'),
	('KH02', N'Nguyễn Thị B', N'Thanh Hoá', '0975157421', 'b@gmail.com'),
	('KH03', N'Nguyễn Thị C', N'Hà Nội', '0975154724', 'n@gmail.com')
INSERT INTO ThueXe VALUES
	('HD01', 'KH01', 'X001', 10, 2),
	('HD02', 'KH02', 'X001', 5, 5),
	('HD03', 'KH02', 'X002', 8, 2),
	('HD04', 'KH03', 'X001', 15, 1),
	('HD05', 'KH03', 'X003', 2, 2)

SELECT * FROM Xe
SELECT * FROM KhachHang
SELECT * FROM ThueXe


--Câu 2:
CREATE FUNCTION Fn_Cau2 (@que nvarchar(50))
RETURNS INT
AS
begin
	declare @tong int
	select @tong = SUM(SoLuongThue)
	from KhachHang join ThueXe on KhachHang.MaKH = ThueXe.MaKH
	where DiaChi = @que
	return @tong
end

--TH1: Chạy đúng
select dbo.Fn_Cau2(N'Hà Nội')
--TH2: Quê không tồn tại
select dbo.Fn_Cau2(N'Nghệ An')


--Câu 3:
CREATE PROC tt_Cau3
@SoHD char(4), @songaythue int, @SoLuongThue int, @MaKH char(4), @MaXe char(4),
@kq int output
AS
begin
	if not exists (select * from KhachHang where MaKH = @MaKH)
		begin
			print N'Mã KH ko tồn tại'
			SET @kq = 1
			return
		end
	if not exists (select * from Xe where MaXe = @MaXe)
		begin
			print N'Mã xe ko tồn tại'
			SET @kq = 2
			return
		end
	else
		begin
			insert into ThueXe values (@SoHD, @MaKH, @MaXe, @songaythue, @songaythue)
			set @kq = 0
		end
end

--TH1: Mã KH ko tồn tại
declare @kq int
exec tt_Cau3 'HD06', 10, 2, 'KH08', 'X001', @kq output
print 'KQ = ' + convert(char(5), @kq)
--TH2: Mã xe ko tồn tại
declare @kq int
exec tt_Cau3 'HD06', 10, 2, 'KH01', 'X008', @kq output
print 'KQ = ' + convert(char(5), @kq)
--TH3: Chạy đúng
declare @kq int
exec tt_Cau3 'HD06', 10, 2, 'KH01', 'X003', @kq output
print 'KQ = ' + convert(char(5), @kq)


--Câu 4:
CREATE TRIGGER tg_Cau4 
ON ThueXe
FOR INSERT 
AS 
begin 
	if exists (select * from Xe join inserted on Xe.MaXe = inserted.MaXe
				where SoLuongThue >= SoLuong)
		begin
			print N'Số lượng không đủ'
			rollback tran
		end
	UPDATE Xe SET SoLuong = SoLuong - SoLuongThue
	from Xe join inserted on Xe.MaXe = inserted.MaXe
end

SELECT * FROM Xe
SELECT * FROM ThueXe

--TH1: Số lượng không đủ
INSERT INTO ThueXe VALUES ('HD07', 'KH03', 'X002', 10, 200)
--TH1: Chạy đúng
INSERT INTO ThueXe VALUES ('HD07', 'KH03', 'X002', 10, 2)


