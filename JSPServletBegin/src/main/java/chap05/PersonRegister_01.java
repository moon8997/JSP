package chap05;

import java.io.IOException;
import java.sql.SQLException;

import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

@WebServlet("/personRegister.do")
public class PersonRegister_01 extends HttpServlet {
	private static final long serialVersionUID = 1L;

	private InterPersonDAO_03 dao = new PersonDAO_04();

	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		String method = request.getMethod();
		System.out.println("확인용 method => " + method);
	

	if("GET".equals(method)) {
		// get 방식으로 넘어왔다면
		// http://localhost:9090/JSPServletBegin/personRegister.do 을 하면 "개인성향 데이터를 DB로 전송하기" 페이지(form 태그 페이지)가 나오도록 한다.
		
		RequestDispatcher dispatcher = request.getRequestDispatcher("/WEB-INF/chap05_ok/personRegister.jsp");
		dispatcher.forward(request, response);
	}
	
	else {
		// post 방식으로 넘어왔다면
		// http://localhost:9090/JSPServletBegin/personRegister.do 을 하면 submit 되어져온 데이터를 받아서 DB로 보내야 한다.
	
		String name = request.getParameter("name");
		String school = request.getParameter("school");
		String color = request.getParameter("color");
		String[] foodArr = request.getParameterValues("food");
	
		PersonDTO_02 psdto = new PersonDTO_02();
		psdto.setName(name);
		psdto.setSchool(school);
		psdto.setColor(color);
		psdto.setFood(foodArr);
	
		String pathName = "";
		
		try {
			int n = dao.personRegister(psdto);
			
			if(n==1) {
				pathName = "/WEB-INF/chap05_ok/personRegister_success.jsp";
			}
			
		} catch (SQLException e) {
			e.printStackTrace();
			pathName = "/WEB-INF/chap05_ok/personRegister_fail.jsp";
			}
			
			RequestDispatcher dispatcher = request.getRequestDispatcher(pathName);
			dispatcher.forward(request, response);
		}
	}
	
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {

		doGet(request, response);
	}

}
