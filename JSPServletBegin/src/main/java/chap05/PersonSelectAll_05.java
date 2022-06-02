package chap05;

import java.io.IOException;
import java.sql.SQLException;
import java.util.List;

import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

@WebServlet("/personSelectAll.do")
public class PersonSelectAll_05 extends HttpServlet {

	private static final long serialVersionUID = 1L;
	
	private InterPersonDAO_03 dao = new PersonDAO_04();
	

	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {

		// tbl_person_interest 테이블에 저장되어진 행(데이터)을 읽어다가(select) 웹페이지에 보여주어야 한다.
		
		String pathName = "";
		
		try {
		     List<PersonDTO_02> personList = dao.selectAll();
		     request.setAttribute("personList", personList);
		     
		     pathName = "/WEB-INF/chap05_ok/personSelectAll.jsp";
		     
		} catch(SQLException e) {
			e.printStackTrace();
			pathName = "/WEB-INF/chap05_ok/personRegister_fail.jsp";
		}
		
		RequestDispatcher dispatcher = request.getRequestDispatcher(pathName);
		dispatcher.forward(request, response);
	}

	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		doGet(request, response);
	}

}
