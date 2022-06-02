package chap05;

import java.io.IOException;
import java.sql.SQLException;

import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;


@WebServlet("/personUpdateEnd.do")
public class PersonUpdateEnd_09 extends HttpServlet {
	
	private static final long serialVersionUID = 1L;

	private InterPersonDAO_03 dao = new PersonDAO_04();
	
	
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		
		String method = request.getMethod(); // "GET" 또는 "POST" 
		
		String path = "";
		
		if("POST".equalsIgnoreCase(method)) {
		
			String seq = request.getParameter("seq");
			String name = request.getParameter("name");
			String school = request.getParameter("school");
			String color = request.getParameter("color");
			String[] foodArr = request.getParameterValues("food");
			
			PersonDTO_02 psdto = new PersonDTO_02();
			psdto.setSeq(Integer.parseInt(seq));
			psdto.setName(name);
			psdto.setSchool(school);
			psdto.setColor(color);
			psdto.setFood(foodArr);
			
			try {
				int n = dao.updatePerson(psdto);
				
				if(n==1) {
					// 특정 개인에 대한 개인성향결과를 보여주는 페이지로 이동시킨다.
					// 즉, URL경로로 페이지의 이동을 시켜주어야 한다.
					response.sendRedirect("personDetail.do?seq="+seq);
					return;
				}
				else {
					// 즉, URL경로로 페이지의 이동을 시켜주어야 한다.
					response.sendRedirect("personSelectAll.do");
					return;
				}
				
			} catch(SQLException e) {
				e.printStackTrace();
				path = "/WEB-INF/chap05_ok/personRegister_fail.jsp";
			}
		
		}
		else {
			// "GET" 방식으로 넘어온 것이라면 
			path = "/WEB-INF/chap05_ok/personDetail_funStop.jsp";
		}
		
		RequestDispatcher dispatcher = request.getRequestDispatcher(path);
		dispatcher.forward(request, response);
	}

	
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		doGet(request, response);
	}

}
