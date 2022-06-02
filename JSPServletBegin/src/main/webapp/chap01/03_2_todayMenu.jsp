<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>오늘의 메뉴</title>

<link rel="stylesheet" type="text/css" href="css/style.css">

</head>
<body>

	<h3>오늘의 메뉴</h3>
	<ol>
		<li>햄버거 5,000원</li>
		<li>짜장면 5,000원</li>
		<li>짬뽕 6,000원</li>
		<li>팔보채 8,000원</li>
	</ol>
	
	<div id="today">
		현재시각 : <%@ include file="03_1_todayTime.jsp" %>
	</div>

</body>
</html>