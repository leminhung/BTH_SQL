INSERT INTO NHACC VALUES
('C01', 'Le Minh TRi', '54 Hau Giang', '434534'),
('C02', 'Tran Minh Thach', '145  Hung Vuong', '434332'),
('C03', 'Hong Phuong', '85 Le Lai Quan 1', '874387'),
('C04', 'Nhat Thang', '40 Huong Lo', '328723'),
('C05', 'Luu Nguyet Que', '178 Nguyen Van Luong', '473974'),
('C06', 'Cao Minh Trung', '125 Le Quang Sung', 'Chua co');


INSERT INTO DONDH VALUES
('D001', '01/15/2005', 'C03'),
('D002', '01/30/2005', 'C01'),
('D003', '02/10/2005', 'C02'),
('D004', '02/17/2005', 'C05'),
('D005', '03/01/2005', 'C02');


INSERT INTO PNHAP VALUES
('N001', '01/17/2005', 'D001'),
('N002', '01/20/2005', 'D001'),
('N003', '01/31/2005', 'D002'),
('N004', '02/15/2005', 'D003'),
('N005', '02/19/2005', 'D003'),
('N006', '03/29/2005', 'D004');


INSERT INTO VATTU VALUES
('DD01', 'dep 01', 'chiec', 23),
('DD02', 'dep 02', 'chiec', 43),
('VD02', 'vi du 02', 'cai', 32),
('VD01', 'vi du 01', 'hop', 31),
('TV14', 'ti vi 14', 'cai', 23),
('TV29', 'ti vi 29', 'cai', 56),
('DD07', N'Đầu DVD Hatachi 1 đĩa', 'chiec', 23);


INSERT INTO CTDONDH VALUES
('D001', 'DD01', 10),
('D001', 'DD02', 15),
('D002', 'VD02', 30),
('D003', 'TV14', 10),
('D003', 'TV29', 20),
('D004', 'TV14', 10),
('D002', 'TV14', 10),
('D001', 'VD01', 20);


INSERT INTO CTPNHAP VALUES
('N001', 'DD01', 8, 2500000),
('N001', 'DD02', 3, 3500000),
('N002', 'DD01', 12, 2500000),
('N002', 'DD02', 32, 4500000),
('N003', 'VD02', 43, 5000000),
('N004', 'TV14', 54, 2500000),
('N004', 'TV29', 76, 3000000);


INSERT INTO PXUAT VALUES
('X001','01/17/2005', 'Nguyen Ngoc Phuong Nhi'),
('X002', '01/25/2005', 'Nguen Hoang Phuong'),
('X003', '01/31/2005', 'Nguyen Tuan Tu');

INSERT INTO CTPXUAT VALUES
('X001', 'DD01', 2, 3500000),
('X002', 'DD01', 1, 2500000),
('X002', 'DD02', 5, 1500000),
('X003', 'DD01', 6, 3500000),
('X003', 'VD01', 3, 2500000),
('X003', 'VD02', 8, 2500000);

SELECT * FROM CTPXUAT

INSERT INTO TONKHO VALUES
('200501', 'DD01', 0, 10, 6, 4),
('200501', 'DD02', 0, 13, 4, 3),
('200502', 'VD02', 4, 2, 3, 9),
('200502', 'TV14', 6, 4, 5, 54),
('200502', 'TV29', 3, 5, 0, 3),
('200502', 'DD01', 34, 0, 0, 0);



--1
SELECT * FROM CTPXUAT
IF(SELECT AVG(DgXuat) 
   FROM CTPXUAT x JOIN VATTU y 
   ON x.MaVTu = y.MaVTu
   WHERE TenVTu = N'Đầu DVD Hatachi 1 đĩa') > 3800000
   PRINT N'Không nên thay đổi gía bán'
ELSE PRINT N'Nên thay đổi giá bán'

--2
IF EXISTS(SELECT * FROM(SELECT * 
          FROM DONDH 
          WHERE DATENAME(DW, NgayDh) = 'Sunday') AS T1)
SELECT *
FROM DONDH
WHERE DATENAME(DW, NgayDh) = 'Sunday'           
ELSE 
    PRINT N'Ngày lập các đơn đặt hàng đều là hợp lệ'


--3
DECLARE @cnt INT
SELECT @cnt = COUNT(SoPn)
FROM PNHAP
WHERE SoDh = 'D001'
IF(@cnt > 0)
print N'Có ' + convert(char(2),@cnt) + N' số phiếu nhập hàng cho đơn dặt hàng D001' 
else print N'Chưa có nhập hàng cho D001' 


--2.1
SELECT MaVTu, TenVTu INTO VATTU_template FROM VATTU
WHILE(SELECT COUNT(*) FROM VATTU_template) > 0
BEGIN
    DECLARE @maVTXoa CHAR(5), @tenVTXoa NVARCHAR(50)
    SELECT TOP 1 @maVTXoa = MaVTu, @tenVTXoa = TenVTu FROM VATTU_template
    DELETE FROM VATTU_template WHERE MaVTu = @maVTXoa
    PRINT N'Đang xóa vật tư ' + @tenVTXoa
END

INSERT INTO VATTU_template SELECT MaVTu, TenVTu FROM VATTU
SELECT * FROM VATTU_template





--2.2: Tự làm nhưng đang bug
-- ALTER TABLE VATTU_template
-- ADD SOPX CHAR(4), DGXUAT FLOAT;

-- IF(SELECT AVG(DgXuat) 
--    FROM CTPXUAT 
--    WHERE MaVTu = 'DD01') < 3500000

-- DECLARE @RowCnt INT, @index INT = 1, @k INT
-- SELECT @RowCnt = COUNT(0) FROM CTPXUAT
-- WHILE(@index <= @RowCnt)
-- BEGIN
    
--     INSERT INTO VATTU_template (MaVTu, TenVTu, SOPX, DGXUAT)
--     WHERE CTPXUAT x JOIN 
--     SET @index = @index + 1
    
-- END


-- SELECT * FROM VATTU_template



--Key 2.2
Alter table VATTU_template 
Add SoPX char(4), DGXuat float 
declare @dem int = 0 
While (Select avg(DGXuat) from CTPXUAT where MaVTu = 'DD01') <3500000 
begin 
    Update CTPXUAT 
    set DgXuat = DgXuat * 1.05 
    Where MaVTu = 'DD01' and DgXuat <=3500000 
    set @dem = @dem + 1 
    insert into VATTU_template 
    select VATTu.MaVtu, TenVTu, SoPX, DGXUat 
    From VATTU join CTPXUAT on VATTu.MaVtu = CTPXUAT.MaVTU 
    where VaTTu.MaVTu = 'DD01' and DgXuat <=3500000 
end print N'Số vòng lặp thực hiện là ' + convert(char(2), @dem) 
