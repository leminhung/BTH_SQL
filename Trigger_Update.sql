CREATE TRIGGER VD2_Xoa
ON NHACC
FOR DELETE
AS
BEGIN
    IF EXISTS(SELECT * FROM HANG x JOIN deleted y ON x.MaNCC = y.MaNCC)
        BEGIN
            RAISERROR(N'NCC này đã cung cấp hàng', 16, 1)
            ROLLBACK TRANSACTION
            RETURN
        END
END


ALTER TABLE NHACC
NOCHECK CONSTRAINT ALL 


SELECT * FROM NHACC
SELECT * FROM HANG

DISABLE TRIGGER tg_vd1 ON NHACC

DELETE FROM NHACC WHERE MaNCC = 'S001'



--2.1a
CREATE TRIGGER VD2_a
ON DONG_PHIEU_XUAT
FOR DELETE
AS
BEGIN
    UPDATE HANG
    SET SoLuongCo = SoLuongCo + SoLuongXuat
    FROM HANG x JOIN deleted y ON x.MaHang = y.MaHang
END


ALTER TABLE DONG_PHIEU_XUAT
NOCHECK CONSTRAINT ALL 



DELETE FROM DONG_PHIEU_XUAT WHERE MaHang = 'P001' AND SoPhieu = 1
SELECT * FROM HANG
SELECT * FROM DONG_PHIEU_XUAT


--2.1b

CREATE TRIGGER VD2_bb
ON DONG_PHIEU_XUAT
FOR DELETE
AS
BEGIN
    IF (SELECT COUNT(*) FROM DELETED) = 1
        BEGIN
            UPDATE HANG
            SET SoLuongCo = SoLuongCo + SoLuongXuat
            FROM HANG x JOIN deleted y ON x.MaHang = y.MaHang
        END
END


ALTER TABLE DONG_PHIEU_XUAT
NOCHECK CONSTRAINT ALL 



--VD3
CREATE TRIGGER VD3
ON DONG_PHIEU_XUAT
FOR UPDATE
AS
BEGIN
    DECLARE @cu INT, @moi INT
    SET @cu = (SELECT SoLuongXuat FROM deleted) 
    SET @moi = (SELECT SoLuongXuat FROM inserted)
    UPDATE HANG
    SET SoLuongCo = SoLuongCo - (@moi - @cu)
    FROM deleted x JOIN HANG y ON x.MaHang = y.MaHang
END

UPDATE DONG_PHIEU_XUAT 
SET SoLuongXuat = 50
WHERE SoPhieu = 1 AND MaHang = 'P002'

SELECT * FROM DONG_PHIEU_XUAT
SELECT * FROM HANG






--VD4

CREATE TRIGGER VD4
ON DONG_PHIEU_XUAT
FOR UPDATE
AS
BEGIN
    IF EXISTS(SELECT * FROM inserted x JOIN HANG y ON x.MaHang = y.MaHang
                                                 JOIN deleted z ON y.MaHang = z.MaHang
                WHERE x.SoLuongXuat > SoLuongCo + z.SoLuongXuat)
        BEGIN
            RAISERROR(N'Số lượng xuất không thõa mãn', 16, 1)
            ROLLBACK TRANSACTION
        END
    IF (SELECT COUNT(*) FROM inserted) = 1
    BEGIN
        DECLARE @cu INT, @moi INT
        SET @cu = (SELECT SoLuongXuat FROM deleted) 
        SET @moi = (SELECT SoLuongXuat FROM inserted)
        UPDATE HANG
        SET SoLuongCo = SoLuongCo - (@moi - @cu)
        FROM deleted x JOIN HANG y ON x.MaHang = y.MaHang
    END
END

DISABLE TRIGGER VD3 ON DONG_PHIEU_XUAT

UPDATE DONG_PHIEU_XUAT SET SoLuongXuat = 1000
WHERE SoPhieu = 1 AND MaHang = 'P002'
