--TẠO TRIGGER
--Khi thêm 1 ncc thì hiển thị thông báo 'NCC da them thanh cong'
CREATE TRIGGER tg_vd1
ON NHACC
FOR INSERT
AS
BEGIN
    IF EXISTS(SELECT * FROM inserted)
        BEGIN
            PRINT N'NCC da them thanh cong'
        END
    else
		print 'Khong them duoc du lieu'
END

INSERT INTO NHACC VALUES ('S051', N'Công ty Vi?t Nam', 'HN', '09666147')



--------------------------------------------------------------------------------------

CREATE TRIGGER tg_vd2
ON NHACC
FOR INSERT
AS
BEGIN
    IF EXISTS(SELECT * FROM inserted)
        BEGIN
            DECLARE @ten NVARCHAR(50)
            SELECT @ten = TenNcc FROM Inserted
            PRINT N'Mặt hàng có nhà cung cấp ' + @ten + 'cung cấp đã thêm thành công'
        END
    else
		print 'Khong them duoc du lieu'
END

INSERT INTO NHACC VALUES ('S056', N'Công ty Vi?t Nam', 'HN', '09666147')




--BT2: Chèn dữ liệu vào dòng phiếu xuất và kiểm tra các rằng buộc dữ liệu
--1. Số phiếu xuất phải tồn tại trong bảng phiếu xuất
--2. Số lượng xuất phải nhỏ hơn hoặc bằng số lượng có
--3. Số lượng có của mặt hàng phải giảm đi số lượng xuất
ALTER TRIGGER tg_bt2
ON DONG_PHIEU_XUAT
FOR INSERT
AS
BEGIN
    IF NOT EXISTS(SELECT * FROM PHIEU_XUAT x JOIN inserted y ON x.SoPhieu = y.SoPhieu WHERE x.SoPhieu = y.SoPhieu)
        BEGIN
            PRINT N'Số phiếu không tồn tại'
            ROLLBACK TRANSACTION
            RETURN
        END
    
    IF NOT EXISTS(SELECT * FROM HANG WHERE MaHang IN (SELECT MaHang FROM inserted))
        BEGIN
            PRINT N'Mã hàng không tồn tại'
            ROLLBACK TRANSACTION
            RETURN
        END

--Cách 1
    IF NOT EXISTS(SELECT * FROM inserted WHERE SoLuongXuat <= ALL(SELECT SoLuongCo FROM HANG x JOIN inserted y ON x.MaHang = y.MaHang))
        BEGIN
            PRINT N'Số lượng xuất không hợp lê'
            ROLLBACK TRANSACTION
            RETURN
        END
--Cách 2
    IF EXISTS(SELECT *FROM inserted x JOIN HANG y ON x.MaHang = y.MaHang WHERE SoLuongXuat > SoLuongCo)
        BEGIN
            PRINT N'Số lượng xuất không hợp lê'
            ROLLBACK TRANSACTION
            RETURN
        END
    UPDATE HANG
    SET SoLuongCo = SoLuongCo - SoLuongXuat
    FROM HANG x JOIN inserted y ON x.MaHang = y.MaHang
END

SELECT * FROM HANG
SELECT * FROM DONG_PHIEU_XUAT
insert into DONG_PHIEU_XUAT values ('7', 'P002', 500)
insert into DONG_PHIEU_XUAT values ('4', 'H001', 16)
insert into DONG_PHIEU_XUAT values ('1', 'P003', 16)
insert into DONG_PHIEU_XUAT values ('1', 'P004', 7)
insert into DONG_PHIEU_XUAT values ('3', 'P005', 392)
insert into DONG_PHIEU_XUAT values ('4', 'P006', 100)

ALTER TABLE DONG_PHIEU_XUAT
NOCHECK CONSTRAINT ALL

SELECT * FROM DONG_PHIEU_XUAT
SELECT * FROM HANG


--BT3: Tạo Trigger kiểm soát việc nhập dữ liệu cho bảng HANG
--      Hãy kiểm tra các rằng buộc toàn vẹn
--      MaHang có trong HANG chưa ?
--      MaNCC có trong NHACC chưa ?
--      Kiểm tra các rằng buộc dữ liệu SoLuongCo và DonGia > 0

ALTER TRIGGER tg_bt3
ON HANG
FOR INSERT
AS
BEGIN
    IF EXISTS(SELECT * FROM HANG WHERE MaHang IN (SELECT MaHang FROM inserted))
        BEGIN
            PRINT N'Mã hàng đã tồn tại'
            ROLLBACK TRANSACTION
            RETURN
        END
    IF NOT EXISTS(SELECT * FROM inserted WHERE MaNCC IN (SELECT MaNCC FROM HANG))
        BEGIN
            PRINT N'Mã NCC không tồn tại'
            ROLLBACK TRANSACTION
            RETURN
        END
    IF EXISTS(SELECT * FROM inserted WHERE SoLuongCo < 0)
        BEGIN
            PRINT N'Số lượng có không hợp lệ'
            ROLLBACK TRANSACTION
            RETURN
        END
    IF EXISTS(SELECT * FROM inserted WHERE DonGia < 0)
        BEGIN
            PRINT N'Đơn giá có không hợp lệ'
            ROLLBACK TRANSACTION
            RETURN
        END
END 

ALTER TABLE HANG
NOCHECK CONSTRAINT ALL

INSERT INTO HANG VALUES('P007', N'Máy giặt', 17, 17, 'S003')
INSERT INTO HANG VALUES('P009', N'Máy giặt', 17, 17, 'S555')
insert into HANG values('H001', N'Máy giặt', 10, 80, 'S050')
insert into HANG values('D001', N'Máy giặt', -5, 80, 'S050')
SELECT * FROM HANG
SELECT * FROM NHACC

