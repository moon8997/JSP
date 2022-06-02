<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
    
<%@ page import="java.util.*, chap05.PersonDTO_02" %>    
    
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>개인성향 모든 정보 출력 페이지</title>

<style type="text/css">

	div#tbl{
		width: 80%;
		margin: 20px auto;
	}
	
	div#tbl>table {
		width: 100%;
		border-collapse: collapse;
	}
	
	div#tbl>table th, div#tbl>table td {
		border: solid 1px gray;
	}
	
	div#tbl>table>tbody>tr:hover {
		background-color: blue;
		color: white;
		cursor: pointer;
	}
	
	tbody > tr > td:nth-child(1) > span  { 
	   color: blue; 
	   display: none; 	
	}
	
	div.container > table > tbody > tr:hover {
		cursor: pointer;
	}

</style>

</head>
<body>
	
	<div id="tbl">
	     <h3>개인성향 모든 정보 출력 페이지(스크립틀릿을 사용하여 작성한 것)</h3>
<%
    List<PersonDTO_02> personList = (List<PersonDTO_02>) request.getAttribute("personList"); 
    
    if( personList.size() > 0 ) { %>
    	<table>
    	     <thead>
    	         <tr>
    	            <th>성명</th>
    	            <th>학력</th>
    	            <th>색상</th>
    	            <th>음식</th>
    	            <th>등록일자</th>
    	         </tr>
    	     </thead>
    	     
    	     <tbody>
    	 <%  for(PersonDTO_02 psdto : personList) { %>
    	        <tr>
    	           <td><%= psdto.getName() %></td>
    	           <td><%= psdto.getSchool() %></td>
    	           <td><%= psdto.getColor() %></td>
    	           <td><%= psdto.getStrFood() %></td>
    	           <td><%= psdto.getRegisterday() %></td>
    	        </tr>
    	 <%  } %>
    	     </tbody>
    	</table>
<%  }
    else { %>
    	<span style="color: red;">데이터가 존재하지 않습니다.</span>
<%  }
%>     
	</div>


</body>
</html>