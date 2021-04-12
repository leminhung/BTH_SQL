--3.1a
CREATE TRIGGER tg_PNHAP_Them
ON PNHAP
FOR INSERT
AS
BEGIN
    IF EXISTS(SELECT * FROM inserted x JOIN DONDH y ON x.SoDh = y.SoDh
                WHERE NgayNhap < NgayDh)
        BEGIN
            RAISERROR(N'Ngày nhập không hợp lệ', 16, 1)
            ROLLBACK TRANSACTION
            RETURN
        END
END

INSERT INTO PNHAP VALUES ('N005', '2005-1-14', 'D001')
INSERT INTO PNHAP VALUES ('N005', '2005-1-16', 'D001')


ALTER TABLE PNHAP
NOCHECK CONSTRAINT ALL
SELECT * FROM PNHAP
SELECT * FROM DONDH

--3.1b
DISABLE TRIGGER tg_CTPNHAP_Them ON CTPNHAP
ALTER TRIGGER tg_CTPNHAP_Them
ON CTPNHAP
FOR INSERT
AS
BEGIN
    IF EXISTS(SELECT * FROM inserted x JOIN VATTU y ON x.MaVTu = y.MaVTu
                                       JOIN TONKHO z ON y.MaVTu = z.MaVTu
                                       JOIN CTDONDH t ON y.MaVTu = t.MaVTu
                    WHERE SLNhap > SLDat - TongSLN)
    BEGIN
        RAISERROR(N'Số lượng nhập không hợp lệ', 16, 1)
        ROLLBACK TRANSACTION
        RETURN
    END
END


INSERT INTO CTPNHAP VALUES ('D002', 'DD01', 1, 15)
INSERT INTO CTPNHAP VALUES ('D001', 'DD02', 1, 15)
SELECT * FROM CTPNHAP
SELECT * FROM CTDONDH
SELECT * FROM TONKHO

ALTER TABLE CTPNHAP
NOCHECK CONSTRAINT ALL


--3.2a
SELECT * FROM PXUAT
SELECT * FROM CTPXUAT
ALTER TRIGGER tg_PXUAT_Xoa
ON PXUAT
FOR DELETE
AS 
BEGIN
    DELETE FROM CTPXUAT
    WHERE SoPx IN (SELECT x.SoPx FROM CTPXUAT x JOIN deleted y ON x.SoPx = y.SoPx)
END

DELETE FROM PXUAT 
WHERE SoPx = 'X002'



ALTER TABLE PXUAT
NOCHECK CONSTRAINT ALL

ALTER TABLE CTPXUAT
NOCHECK CONSTRAINT ALL



--3.2b 
ALTER TRIGGER tg_PNHAP_Xoa
ON PNHAP
FOR DELETE
AS 
BEGIN
    DELETE FROM CTPNHAP
    WHERE SoPn IN (SELECT y.SoPn FROM CTPNHAP x JOIN deleted y ON x.SoPn = y.SoPn)  
END

DELETE FROM PNHAP
WHERE SoPn = 'N001' 


ALTER TABLE PNHAP
NOCHECK CONSTRAINT ALL

ALTER TABLE CTPNHAP
NOCHECK CONSTRAINT ALL

SELECT * FROM CTPNHAP
SELECT * FROM PNHAP



--3.3a
CREATE TRIGGER tg_PNHAP_Sua
ON PNHAP
FOR UPDATE
AS
BEGIN
    IF UPDATE(SoDh) OR UPDATE(SoPn)
        BEGIN
            RAISERROR(N'Không được sử dữ liệu cột Số Đơn Hàng hoặc Số Phiếu Nhập', 16, 1)
            ROLLBACK TRANSACTION
            RETURN
        END
    IF EXISTS(SELECT * FROM inserted x JOIN DONDH y ON x.SoDh = y.SoDh
                WHERE NgayNhap < NgayDh)
        BEGIN
            RAISERROR(N'Ngày nhập không hợp lệ', 16, 1)
            ROLLBACK TRANSACTION
            RETURN
        END
END

SELECT * FROM PNHAP
SELECT * FROM DONDH

UPDATE PNHAP 
SET NgayNhap = '2005-01-17'
WHERE SoDh = 'D001' AND SoPn = 'N001'

UPDATE PNHAP 
SET NgayNhap = '2005-01-14'
WHERE SoDh = 'D001' AND SoPn = 'N001'


UPDATE PNHAP 
SET NgayNhap = '2005-01-17', SoDh = 'ff00'
WHERE SoPn = 'N001'

UPDATE PNHAP 
SET NgayNhap = '2005-01-17', SoPn = 'N008'
WHERE SoPn = 'N001'

--3.3b
ALTER TRIGGER tg_PXUAT_Sua
ON PXUAT
FOR UPDATE
AS
BEGIN
    IF UPDATE(SoPx)
        BEGIN
            RAISERROR(N'Không được sửa dữ liệu cột số phiếu xuất', 16, 1)
            ROLLBACK TRANSACTION
            RETURN
        END
    IF NOT EXISTS(SELECT * FROM inserted x JOIN deleted y ON x.SoPx = y.SoPx
                    WHERE YEAR(x.NgayXuat) = YEAR(y.NgayXuat) AND MONTH(x.NgayXuat) = MONTH(x.NgayXuat))
        BEGIN
            RAISERROR(N'Năm tháng không hợp lệ', 16, 1)
            ROLLBACK TRANSACTION
            RETURN
        END           
END


SELECT * FROM PXUAT

UPDATE PXUAT
SET NgayXuat = '2005-01-24'
WHERE SoPx = 'X002'


UPDATE PXUAT
SET SoPx = '123'
WHERE SoPx = 'X002'

UPDATE PXUAT
SET NgayXuat = '2006-01-02'
WHERE SoPx = 'X002'



--3.4a
ALTER TABLE PNHAP
ADD TONGTG FLOAT
ALTER TRIGGER tg_CTPNHAP_Them
ON PNHAP
FOR INSERT
AS
BEGIN
    IF EXISTS(SELECT * FROM inserted x JOIN DONDH y ON x.SoDh = y.SoDh
                WHERE NgayNhap < NgayDh)
        BEGIN
            RAISERROR(N'Ngày nhập không hợp lệ', 16, 1)
            ROLLBACK TRANSACTION
            RETURN
        END
    DECLARE @Sopn CHAR(4), @MaTu CHAR(4), @sl int, @dg money, @tong FLOAT
    SELECT @Sopn = SoPn, @MaTu = MaVTu, @sl = SLNhap, @dg = DgNhap
    FROM inserted

    SELECT @tong = SUM(SlNhap*DgNhap)
    FROM CTPNHAP
    WHERE SoPn = @Sopn
-----
    UPDATE PNHAP
    SET TONGTG = @tong
    WHERE SoPn = @Sopn

-----
    DECLARE @namthang CHAR(6)
    SELECT @namthang = CONVERT(char(6), NgayNhap, 112)
    FROM PNHAP WHERE SoPn = @Sopn

----
    UPDATE TONKHO
    SET TongSLN = TongSLN + @sl
    WHERE MaVTu = @MaTu AND NamThang = @namthang
    
END

INSERT INTO PNHAP VALUES ('N005', '2005-1-14', 'D001')
INSERT INTO PNHAP VALUES ('N005', '2005-1-16', 'D001')

SELECT * FROM PNHAP
SELECT * FROM CTPNHAP

