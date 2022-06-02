package chap05;

import java.io.IOException;
import java.sql.SQLException;

import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;



@WebServlet("/personDelete.do")
public class PersonDelete_07 extends HttpServlet {
	private InterPersonDAO_03 dao = new PersonDAO_04();
	
	private static final long serialVersionUID = 1L;

	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		
		String method = request.getMethod(); // "GET" 또는 "POST"
		
		String path = "";
		
		if("POST".equalsIgnoreCase(method)) {
			// 정상적인 POST 방식으로 들어오면
			
			String seq = request.getParameter("seq");
			String name = request.getParameter("name");
			
	//		System.out.println("제거할 seq => " + seq);
	//		System.out.println("제거할 name => " + name);
			
			try {
				int n = dao.deletePerson(seq);
				
				if(n==1) {
					String delInfo = "회원번호 "+seq+"번 "+name+" 님을 삭제했습니다.";
					request.setAttribute("delInfo", delInfo);
					path = "/WEB-INF/chap05_ok/personDelete_success.jsp";
				}
				
			} catch (SQLException e) {
				e.printStackTrace();
				path = "/WEB-INF/chap05_ok/personRegister_fail.jsp";
			}
			
		}
		else {
			// 비정상적인 GET 방식으로 들어오면
			path = "/WEB-INF/chap05_ok/personDetail_funStop.jsp";
		}
		
		RequestDispatcher dispatcher = request.getRequestDispatcher(path);
		dispatcher.forward(request, response);
		
	}

	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {

		doGet(request, response);
	}

}
