<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
    
<%-- ==== JSTL(Java Standard Tag Library) 사용하기 ==== --%>
<%@ taglib prefix="c"  uri="http://java.sun.com/jsp/jstl/core" %> 
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>   
    
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>forTokens 를 이용하여 친구이름 출력하기</title>
</head>
<body>
	
	<h2>forTokens 를 이용하여 친구이름 출력하기</h2>
	
	<c:if test="${ empty requestScope.friendNames1 }">
	   <div>
	      <span style="color: red;">친구가 없으시군요~~ ^___^</span>  
	   </div>
	</c:if>
	
	<c:if test="${ not empty requestScope.friendNames1 }">
	   <div>
	       <ol>
	           <c:forTokens var="name" items="${requestScope.friendNames1}" delims=",">
	                 <%-- forTokens 에서 items="${}" 에 들어오는 것은 배열이나 List가 아닌 하나의 문자열이 들어온다. --%>      
				     <%-- 문자열을 , 로 잘라서 배열로 만들어준다. --%>
				     <li>${name}</li>
	           </c:forTokens>
	       </ol>
	   </div> 
	</c:if>
	
	<hr style="border: solid 1px red;">
	
	<c:if test="${ empty requestScope.friendNames2 }">
	   <div>
	      <span style="color: red;">친구가 없으시군요~~ ^___^</span>  
	   </div>
	</c:if>
	
	<c:if test="${ not empty requestScope.friendNames2 }">
	   <div>
	       <ol>
	           <c:forTokens var="name" items="${requestScope.friendNames2}" delims=",./">
	                 <%-- forTokens 에서 items="${}" 에 들어오는 것은 배열이나 List가 아닌 하나의 문자열이 들어온다. --%>      
				     <%-- 문자열을 , 로 잘라서 배열로 만들어준다. --%>
				     <li>${name}</li>
	           </c:forTokens>
	       </ol>
	   </div> 
	</c:if>
	
	
	<h2>split 함수를 사용하여 배열로 만든 다음 forEach를 사용하여 친구이름 출력하기</h2>
	
	<c:if test="${ empty requestScope.friendNames1 }">
	   <div>
	      <span style="color: red;">친구가 없으시군요~~ ^___^</span>  
	   </div>
	</c:if>
	
	<c:if test="${ not empty requestScope.friendNames1 }">
	   <c:set var="arr_friendName1" value="${ fn:split(requestScope.friendNames1, ',') }" />
	   
	   <div>
	       <ol>
	           <c:forEach var="name" items="${arr_friendName1}">
	              <li>${name}</li>
	           </c:forEach>
	       </ol>
	   </div> 
	</c:if>
	
	<hr style="border: solid 1px blue;">
	
	<c:if test="${ empty requestScope.friendNames2 }">
	   <div>
	      <span style="color: red;">친구가 없으시군요~~ ^___^</span>  
	   </div>
	</c:if>
	
	<c:if test="${ not empty requestScope.friendNames2 }">
	   <c:set var="arr_friendName2" value="${ fn:split(requestScope.friendNames2, ',./') }" />
	   
	   <div>
	       <ol>
	           <c:forEach var="name" items="${arr_friendName2}">
	              <li>${name}</li>
	           </c:forEach>
	       </ol>
	   </div>   
	</c:if>
	
</body>
</html>