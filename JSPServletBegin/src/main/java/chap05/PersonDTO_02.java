package chap05;

public class PersonDTO_02 {

	private int seq;
	private String name;
	private String school;
	private String color;
	private String[] food;
	private String registerday;
	
	public int getSeq() {
		return seq;
	}
	
	public void setSeq(int seq) {
		this.seq = seq;
	}
	
	public String getName() {
		return name;
	}
	
	public void setName(String name) {
		this.name = name;
	}
	
	public String getSchool() {
		return school;
	}
	
	public void setSchool(String school) {
		this.school = school;
	}
	
	public String getColor() {
		return color;
	}
	
	public void setColor(String color) {
		this.color = color;
	}
	
	public String[] getFood() {
		return food;
	}
	
	public void setFood(String[] food) {
		this.food = food;
	}
	
	public String getRegisterday() {
		return registerday;
	}
	
	public void setRegisterday(String registerday) {
		this.registerday = registerday;
	}
	
	/////////////////////////////////////////////////
	public String getStrFood() {
		if(food != null) {
			return String.join(",", food);
		}
		else {
			return "없음";
		}
	}
	
	public String getStrFoodImgFileName() {
		
		String result = null;
		
		if(food != null) {
			
			StringBuilder sb = new StringBuilder();
			
			for(int i=0; i<food.length; i++) {
				
					switch (food[i]) {
					case "짜장면":
						sb.append("jjm.png");
						break;
	
					case "짬뽕":
						sb.append("jjbong.png");
						break;
					
					case "탕수육":
						sb.append("tangsy.png");
						break;
						
					case "양장피":
						sb.append("yang.png");
						break;
					
					case "팔보채":
						sb.append("palbc.png");
						break;	
					} // end of switch ---------------
					
					if(i < food.length-1) {
						sb.append(",");
					}
				
			} // end of for ---[------
			
			result = sb.toString();
			
		}
		
		return result;
		
	} // end of public String getStrFoodImgFileName() --------------------
	
	
}
