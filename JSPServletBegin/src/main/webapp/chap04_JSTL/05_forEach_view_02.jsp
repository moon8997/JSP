<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
    
<%-- ==== JSTL(Java Standard Tag Library) 사용하기 ==== --%>
<%@ taglib prefix="c"  uri="http://java.sun.com/jsp/jstl/core" %>    
    
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>친구명단 출력하기</title>
</head>
<body>

	<c:if test="${empty requestScope.arrFriendName}">
	   <div>
	       <span style="color: red;">친구명단이 없습니다.</span>
	   </div>
	</c:if>
	
	<c:if test="${not empty requestScope.arrFriendName}">
	   <div>
	        <ol>
	            <c:forEach var="friendName" items="${requestScope.arrFriendName}">
	                                   <%-- items="${}" 에 들어오는 것은 배열명 또는 List명 이다. --%>
	                <li style="color: blue;">${friendName}</li>
	            </c:forEach>
	        </ol>
	   </div>
	</c:if>
	
	<hr style="border: solid 1px red;">
	
	<c:if test="${empty requestScope.personList}">
	   <div>
	       <span style="color: red;">회원명단이 없습니다.</span>
	   </div>
	</c:if>
	
	<c:if test="${not empty requestScope.personList}">
	   <div>
           <c:forEach var="psdto" items="${requestScope.personList}">
                                   <%-- items="${}" 에 들어오는 것은 배열명 또는 List명 이다. --%>
              <ol>                     
	                <li>성명: ${psdto.name}</li>
	                <li>학력: ${psdto.school}</li>
	                <li>색상: ${psdto.color}</li>
	                <li>음식: ${psdto.strFood}</li>
              </ol>  
           </c:forEach>
	   </div>
	</c:if>
	
	
	

</body>
</html>