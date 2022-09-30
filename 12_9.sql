use Bank
go
--1. Mùa Thu năm 2012 khách hàng Trần Văn Thiện Thanh thực hiện bao nhiêu giao dịch
SELECT  COUNT(t_id) AS 'Tổng giao dịch mùa thu'
FROM customer, account, transactions
WHERE customer.Cust_id= account.cust_id AND account.Ac_no=transactions.ac_no 
										AND Cust_name= N'Trần Văn Thiện Thanh' 
										AND YEAR(T_DATE) =2012 AND MONTH(t_date) BETWEEN 7 AND 9


--2. Tổng số tiền đã gửi vào Vietcombank chi nhánh Đà Nẵng năm 2013 là bao nhiêu
SELECT  SUM(t_amount) AS TONGTIENGUI
FROM Branch JOIN customer ON customer.Br_id = Branch.BR_id
			JOIN  account ON customer.Cust_id=account.cust_id
			JOIN transactions ON  account.Ac_no=transactions.ac_no 
WHERE BR_name = N'Vietcombank Đà Nẵng' AND t_type=1 AND YEAR(T_DATE) =2013


--3. Số tiền gửi trung bình đã gửi vào chi nhánh Huế từ trước đến nay là bao nhiêu?
SELECT AVG(t_amount) AS 'Tổng tiền gửi'
FROM Branch JOIN customer ON customer.Br_id = Branch.BR_id
			JOIN  account ON customer.Cust_id=account.cust_id
			JOIN transactions ON  account.Ac_no=transactions.ac_no 
WHERE BR_name LIKE N'%Huế' AND t_type=1 

/* SUB QUERY : TRUY VẤN CON
 = TÊN CỘT SO SÁNH VỚI CHỈ 1 Giá trị
 Truy vấn lồng thường có thêm cả con nữa nên có 2 giá trị.BP : điều kiện / count-1
 */
--4. Có bao nhiêu khách hàng cùng chi nhánh với Trần Văn Thiện Thanh
SELECT (COUNT(CUST_ID)-1) SLKH
FROM customer
WHERE Br_id = (SELECT BR_ID
				FROM customer
				WHERE  Cust_name= N'Trần Văn Thiện Thanh'  )

--6. Chi nhánh Sài Gòn có những khách hàng nào không thực hiện bất kỳ giao dịch nào trong vòng 3 năm trở lại đây
-- Nếu có thể, hãy hiển thị tên và sđt của các khách hàng đó để phòng marketing xử lý
-- BẢNG: CUSTOMER, BRANCH , TRANSACTIONS
-- CỘT: CUST_NAME , CUST_PHONE
-- ĐIỀU KIỆN: 1) CHI NHÁNH SÀI GÒN
--			  2) TRONG BẢNG TRANSACTIONS KHÔNG CÓ SỐ TÀI KHOẢN CỦA HỌ
--            3) THỜI GIAN  GIAO DỊCH >= GETDATE() -3 NĂM

SELECT Cust_name
FROM customer
WHERE Branch JOIN customer ON customer.Br_id = Branch.BR_id
			 JOIN  account ON customer.Cust_id=account.cust_id
WHERE BR_name LIKE N'%Sài Gòn' AND BR_NAME			NOT IN (SELECT customer.Cust_id
							FROM Branch JOIN customer ON customer.Br_id = Branch.BR_id
			JOIN  account ON customer.Cust_id=account.cust_id
			JOIN transactions ON  account.Ac_no=transactions.ac_no 
WHERE BR_name LIKE N'%Sài Gòn'  AND YEAR(t_DATE) BETWEEN (YEAR(GETDATE())-3) AND YEAR(GETDATE()) )


--8. Tìm số tiền giao dịch nhiều nhất trong năm 2016 của chi nhánh Huế
-- Nếu có thể, hãy đưa ra tên của khách hàng thực hiện giao dịch đó




--17. Ông Phạm Duy Khánh thuộc chi nhánh? Từ 01/2017 đến nay Ông Khánh đã thực hiện được bao nhiêu giao dịch
--gửi tiền vào ngân hàng với tổng số tiền là bao nhiêu

-- CỘT: TÊN CHI NHÁNH, SỐ LƯỢNG GIAO DỊCH GỬI TIỀN, TỔNG TIỀN GIAO DỊCH

--33. Thời gian vừa qua, hệ thống CSDL của ngân hàng bị hacker tấn công(giả sử)
--tổng tiền trong tài khoản bị thay đổi bất thường. Hãy liệt kê những tài khoản bất thường đó.
--Gợi ý: tài khoản bất thường là tài khoản có tổng tiền gửi - tổng tiền rút <> số tiền trong tài khoản 
-- DIỀU KIỆN: TỔNG TIỀN GỬI (SUB) - TỔNG TIỀN RÚT CỦA KHÁCH HÀNG TA ĐANG XÉT VỚI (SUB) <> SỐ DƯ TRONG TÀI KHOẢN 