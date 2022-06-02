package test.controller;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import common.controller.AbstractController;

public class Test1Controller extends AbstractController {

	@Override
	public void execute(HttpServletRequest request, HttpServletResponse response) throws Exception {
		
		request.setAttribute("name", "이순신");
		
	//	super.setRedirect(false);
		super.setViewPage("/WEB-INF/test/test1.jsp");  //이순신이라는 값을 여기에 넘겨중
	}

}
// ㅂ클래스 만들때 수퍼클래스에 부모클래스(AbstractController)를 입력한다