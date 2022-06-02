<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<%@ page import="java.util.*, chap03.PersonDTO" %>

<%
	String[] arrFriendName = {"태연","아이유","송혜교","김태희","유재석"};

    request.setAttribute("arrFriendName", arrFriendName);
    
    //////////////////////////////////////////////////////////////////////////////////////////
    
    List<PersonDTO> personList = new ArrayList<>();
    
    PersonDTO person1 = new PersonDTO();
    person1.setName("김태희");
    person1.setSchool("대졸");
    person1.setColor("red");
    person1.setFood("쵸콜릿,마이쥬,월드콘".split("\\,"));
    
    PersonDTO person2 = new PersonDTO();
    person2.setName("아이유");
    person2.setSchool("초대졸");
    person2.setColor("blue");
    person2.setFood("육회비빔밥,광어회,조개구이,참이슬".split("\\,"));
    
    PersonDTO person3 = new PersonDTO();
    person3.setName("박보영");
    person3.setSchool("대학원졸");
    person3.setColor("green");
    person3.setFood("라면,떡볶이,순대,피자".split("\\,"));
    
    personList.add(person1);
    personList.add(person2);
    personList.add(person3);
    
    request.setAttribute("personList", personList);
    
    RequestDispatcher dispatcher = request.getRequestDispatcher("05_forEach_view_02.jsp");
    dispatcher.forward(request, response);
    
%>    