package common.controller;

import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import myshop.model.ImageVO;
import myshop.model.InterProductDAO;
import myshop.model.ProductDAO;

public class IndexController extends AbstractController {  //강제로 여기서 재정의한다.  //부모클래스를 하나만들면 앞으로 생성되어질 모든 클래스 메소드를 돌려야한다.(강제화=>인퍼페이스만들기 오버라이딩 재정의)
        //부모클래스를 하나만들면 앞으로 생성되어질 모든 클래스 한꺼번에 제어가 가능하다 //조상클래스 오브젝트 클래스


	@Override
	public String toString() {   //toString(): 오브잭트꺼를 재정의 해준다
		return "== 확인용 IndexController 클래스의 인스턴스 메소드인 toString() 호출함 === ";
	}
	
	
	@Override
	public void execute(HttpServletRequest request, HttpServletResponse response) throws Exception {
		
		InterProductDAO pdao = new ProductDAO();
		List<ImageVO> imgList = pdao.imageSelectAll();
		
		request.setAttribute("imgList", imgList);
		
		/*
			super.setRedirect(false);
			this.setRedirect(false);
			setRedirect(false);
		*/
	//	super.setRedirect(false);
		super.setViewPage("/WEB-INF/index.jsp");
		
	}

}
