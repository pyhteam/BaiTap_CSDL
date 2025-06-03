-- Phần 1.1: Mô hình thực thể - liên kết và chuyển đổi
-- a. Xây dựng mô hình thực thể - liên kết (ERD)
--    Các thực thể chính: DOCGIA, SACH, NHAXUATBAN, PHIEUMUON.
--    Thuộc tính của các thực thể (dựa trên mô tả 1.1):
--    - SACH: MaSach (PK), TenSach, TenTacGia, NamXuatBan, LanTaiBan
--    - NHAXUATBAN: MaNXB (PK), TenNXB, DiaChi, Email, SoDienThoai
--    - DOCGIA: MaDocGia (PK), HoTen, NamSinh, DiaChi
--    - PHIEUMUON: MaPhieuMuon (PK), NgayMuon, NgayTra, TinhTrang
--
--    Mối quan hệ (dựa trên mô tả 1.1):
--    - NHAXUATBAN (1) -- produces -- (N) SACH (Một NXB sản xuất nhiều sách, một sách thuộc một NXB)
--    - DOCGIA (N) -- borrows -- (M) SACH. "Một lần mượn chỉ được mượn một cuốn sách" ngụ ý rằng PHIEUMUON là một thực thể ghi lại mỗi lần mượn.
--      Do đó, mối quan hệ có thể được mô hình hóa như sau:
--      DOCGIA (1) -- initiates -- (N) PHIEUMUON (1) -- concerns -- (1) SACH
--      (Một độc giả có thể có nhiều phiếu mượn, mỗi phiếu mượn liên quan đến một độc giả và một sách cụ thể cho lần mượn đó)

-- b. Chuyển mô hình ERD sang mô hình quan hệ (dựa trên mô tả 1.1)
--    DOCGIA (MaDocGia (PK), HoTen, NamSinh, DiaChi)
--    NHAXUATBAN (MaNXB (PK), TenNXB, DiaChi, Email, SoDienThoai)
--    SACH (MaSach (PK), TenSach, TenTacGia, NamXuatBan, LanTaiBan, MaNXB (FK references NHAXUATBAN(MaNXB)))
--    PHIEUMUON (MaPhieuMuon (PK), NgayMuon, NgayTra, TinhTrang, MaDocGia (FK references DOCGIA(MaDocGia)), MaSach (FK references SACH(MaSach)))
--
-- Lưu ý: Lược đồ quan hệ này dựa trên mô tả ở 1.1. 
-- Phần 1.2 của bài tập sử dụng một lược đồ quan hệ đã cho sẵn, và các câu lệnh SQL dưới đây sẽ tuân theo lược đồ của 1.2.

-- Phần 1.2: Sử dụng SQL với lược đồ cho trước trong đề bài

-- a. Hãy tạo cấu trúc bảng, các ràng buộc khóa chính, khóa ngoại đối với 4 bảng đã mô tả ở trên; lựa chọn các kiểu dữ liệu phù hợp cho các cột trong mỗi bảng;

CREATE TABLE NHAXB (
    MANXB VARCHAR(10) PRIMARY KEY,
    TENNXB NVARCHAR(255) NOT NULL,
    DIACHI NVARCHAR(255),
    SDT VARCHAR(15)
);

CREATE TABLE DOCGIA (
    MADG VARCHAR(10) PRIMARY KEY,
    HOTEN NVARCHAR(100) NOT NULL,
    GIOITINH NVARCHAR(10), -- Ví dụ: 'Nam', 'Nữ'
    NGAYSINH DATE
);

CREATE TABLE SACH (
    MASACH VARCHAR(10) PRIMARY KEY,
    TENSACH NVARCHAR(255) NOT NULL,
    NAMXB INT, -- Năm xuất bản
    TENTG NVARCHAR(100), -- Tên tác giả
    MANXB VARCHAR(10),
    FOREIGN KEY (MANXB) REFERENCES NHAXB(MANXB)
);

CREATE TABLE PHIEUMUON (
    MAPHIEU VARCHAR(10) PRIMARY KEY,
    MADG VARCHAR(10),
    MASACH VARCHAR(10),
    NGAYMUON DATE NOT NULL,
    NGAYHENTRA DATE,
    FOREIGN KEY (MADG) REFERENCES DOCGIA(MADG),
    FOREIGN KEY (MASACH) REFERENCES SACH(MASACH)
);

-- b. Hãy chèn dữ liệu phù hợp vào 4 bảng (mỗi bảng ít nhất 3 dòng (bản ghi));

-- Chèn dữ liệu cho bảng NHAXB
INSERT INTO NHAXB (MANXB, TENNXB, DIACHI, SDT) VALUES
('NXB01', N'Nhà Xuất Bản Trẻ', N'161B Lý Chính Thắng, P.7, Q.3, TP.HCM', '02839316289'),
('NXB02', N'Nhà Xuất Bản Kim Đồng', N'55 Quang Trung, Hai Bà Trưng, Hà Nội', '02439434730'),
('NXB03', N'Nhà Xuất Bản Giáo Dục Việt Nam', N'81 Trần Hưng Đạo, Hoàn Kiếm, Hà Nội', '02438220801');

-- Chèn dữ liệu cho bảng DOCGIA
INSERT INTO DOCGIA (MADG, HOTEN, GIOITINH, NGAYSINH) VALUES
('DG001', N'Nguyễn Văn An', N'Nam', '1998-05-15'),
('DG002', N'Trần Thị Bích', N'Nữ', '2000-11-22'),
('DG003', N'Lê Hoàng Cường', N'Nam', '1995-02-10'),
('DG004', N'Phạm Thị Dung', N'Nữ', '2001-07-30');

-- Chèn dữ liệu cho bảng SACH
INSERT INTO SACH (MASACH, TENSACH, NAMXB, TENTG, MANXB) VALUES
('S0001', N'Dế Mèn Phiêu Lưu Ký', 2019, N'Tô Hoài', 'NXB02'),
('S0002', N'Lập Trình Hướng Đối Tượng Với C++', 2020, N'Nguyễn Tấn Trần Minh Khang', 'NXB01'),
('S0003', N'Sách Giáo Khoa Toán 12 - Tập 1', 2019, N'Nhiều tác giả', 'NXB03'),
('S0004', N'Harry Potter và Hòn Đá Phù Thủy', 2018, N'J.K. Rowling', 'NXB01'),
('S0005', N'Những Người Khốn Khổ', 2019, N'Victor Hugo', 'NXB02');

-- Chèn dữ liệu cho bảng PHIEUMUON
INSERT INTO PHIEUMUON (MAPHIEU, MADG, MASACH, NGAYMUON, NGAYHENTRA) VALUES
('PM001', 'DG001', 'S0001', '2020-06-05', '2020-06-20'),
('PM002', 'DG002', 'S0002', '2020-06-10', '2020-06-25'),
('PM003', 'DG001', 'S0003', '2020-07-01', '2020-07-15'),
('PM004', 'DG003', 'S0004', '2019-12-15', '2020-01-05'),
('PM005', 'DG002', 'S0001', '2020-06-22', '2020-07-07'),
('PM006', 'DG004', 'S0005', '2020-06-18', '2020-07-02');

-- c. Hãy hiển thị thông tin về những cuốn sách được xuất bản trong năm 2019;
SELECT MASACH, TENSACH, NAMXB, TENTG, MANXB
FROM SACH
WHERE NAMXB = 2019;

-- d. Hãy hiển thị các thông tin bao gồm: MADG, HOTEN, GIOITINH, NGAYSINH của tất cả
-- các độc giả đã mượn từng mượn sách trong tháng 6/2020.
SELECT DISTINCT D.MADG, D.HOTEN, D.GIOITINH, D.NGAYSINH
FROM DOCGIA D
INNER JOIN PHIEUMUON P ON D.MADG = P.MADG
WHERE P.NGAYMUON >= '2020-06-01' AND P.NGAYMUON <= '2020-06-30';

-- Lưu ý: Cách viết điều kiện ngày tháng có thể thay đổi tùy hệ quản trị CSDL.
-- Ví dụ cho SQL Server: WHERE MONTH(P.NGAYMUON) = 6 AND YEAR(P.NGAYMUON) = 2020;
-- Ví dụ cho MySQL/PostgreSQL: WHERE EXTRACT(MONTH FROM P.NGAYMUON) = 6 AND EXTRACT(YEAR FROM P.NGAYMUON) = 2020;

-- e. Hãy hiển thị tổng số lần đã mượn sách của từng từng độc giả: MADG, HOTEN, [TỔNG SỐ LẦN MƯỢN SÁCH]
SELECT D.MADG, D.HOTEN, COUNT(P.MAPHIEU) AS TONG_SO_LAN_MUON_SACH
FROM DOCGIA D
INNER JOIN PHIEUMUON P ON D.MADG = P.MADG
GROUP BY D.MADG, D.HOTEN
ORDER BY D.MADG;