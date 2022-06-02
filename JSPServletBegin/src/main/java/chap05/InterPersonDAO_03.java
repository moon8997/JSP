package chap05;

import java.sql.SQLException;
import java.util.List;

public interface InterPersonDAO_03 {

	// 개인성향을 입력(insert) 해주는 추상메소드(미완성메소드)
	int personRegister(PersonDTO_02 psdto) throws SQLException;
	
	// tbl_person_interest 테이블에 저장되어진 행들을 select 해주는 추상메소드(미완성메소드)
	List<PersonDTO_02> selectAll() throws SQLException;

	// tbl_person_interest 테이블에 저장되어진 특정 1개 행만 select 해주는 추상메소드(미완성메소드)
	PersonDTO_02 selectOne(String seq) throws SQLException;

	// tbl_person_interest 테이블에 저장되어진 특정 1개 행만 delete 해주는 추상메소드(미완성메소드)
	int deletePerson(String seq) throws SQLException;

	// tbl_person_interest 테이블에 저장되어진 특정 1개 행만 update 해주는 추상메소드(미완성메소드)
	int updatePerson(PersonDTO_02 psdto) throws SQLException;
}
