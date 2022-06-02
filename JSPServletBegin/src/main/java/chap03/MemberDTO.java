package chap03;

public class MemberDTO {

	private String name; //성명
	private String jubun; //주민번호
	
	public MemberDTO() {
		
	}
	
	public MemberDTO(String name, String jubun) { // 파라미터를 통한 생성자
		super();
		this.name = name;
		this.jubun = jubun;
	}

	public String getName() {
		return name;
	}
	
	public void setName(String name) {
		this.name = name;
	}
	
	public String getJubun() {
		return jubun;
	}
	
	public void setJubun(String jubun) {
		this.jubun = jubun;
	}
	
}
