<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<%
	String friendNames1 = "태연,아이유,송혜교,김태희,유재석";
    String friendNames2 = "이제훈,고수.강동원,김흥국/이순신";

    request.setAttribute("friendNames1", friendNames1);
    request.setAttribute("friendNames2", friendNames2);
    
    RequestDispatcher dispatcher = request.getRequestDispatcher("06_forTokens_view_02.jsp");
    dispatcher.forward(request, response);
%>    