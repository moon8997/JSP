<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<%
	String s_firstNum = request.getParameter("firstNum");
	String s_secondNum = request.getParameter("secondNum");
	
	int firstNum = Integer.parseInt(s_firstNum);
	int secondNum = Integer.parseInt(s_secondNum);
	
	int sum = 0;
	for(int i=firstNum; i<=secondNum; i++){
		sum += i;
	}
	
	// 결과물은 sum이다
	System.out.println("sum =>" + sum);
	
	/*
    !!!! 중요 꼭 암기 !!!!
    == request 내장객체는 클라이언트( 02forwardCalc_execute_01.jsp ) 가 
       보내온 데이터를 읽어들이는 역할( request.getParameter("name명"); )도 있고 
       또한 어떤 결과물을 저장시키는 저장소 기능( request.setAttribute("키", 저장할객체); ) 도 있다. 
 */
	
// 	request.setAttribute("firstNum", new Integer(firstNum));
// 	request.setAttribute("secondNum", new Integer(secondNum));
//	원래는 위처럼 객체를 만들어서 저장을 해야 하지만 자바가 알아서 auto boxing(자동적으로 객체를 만들어주는 것)을 해주기 때문에 아래처럼 쓸수 있다.
 	request.setAttribute("firstNum",firstNum);
 	request.setAttribute("secondNum",secondNum);
 	
//	request.setAttribute("sum",new Integer(sum)); 	
 	request.setAttribute("sum",sum);
%>
<jsp:forward page="02forwardCalc_view_03.jsp" />
<%--
   웹브라우저 상에서 URL 주소는 그대로 http://localhost:9090/JSPServletBegin/chap03_StandardAction/02forwardCalc_02.jsp 인데 
   웹브라우저 상에 보여지는 내용물은 http://localhost:9090/JSPServletBegin/chap03_StandardAction/02forwardCalc_view_03.jsp 의 내용이 보여진다.      
 --%>