package common.controller;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

public class MainController extends AbstractController { //강제로 여기서 재정의한다. //조상클래스 오브젝트 클래스

	@Override
	public String toString() {   //toString(): 오브잭트꺼를 재정의 해준다
		return ">>> 확인용 MainController 클래스의 인스턴스 메소드인 toString() 호출함 <<< ";
	}
	
	@Override
	public void execute(HttpServletRequest request, HttpServletResponse response) throws Exception {
	
		/*
			super.setRedirect(true); 또는
			this.setRedirect(true); 또는
			setRedirect(true);
			
		*/
		super.setRedirect(true); 
		super.setViewPage("index.up"); // /MyMVC/index.up 페이지로 이동한다. //상대경로
	} 

}
