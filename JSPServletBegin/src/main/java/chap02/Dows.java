package chap02;

import java.util.Scanner;

public class Dows {
	@SuppressWarnings("unlikely-arg-type")
	public static void main(String[] args) {
		Scanner sc = new Scanner(System.in);

		while (true) {
			System.out.print("문자열을 입력해주세요 : ");
			String str = sc.nextLine();

			if (str.equalsIgnoreCase("exit")) {
				
				break;
			} else {
				System.out.println(str.length() + "글자입니다.");

			}
			
		}
		
		System.out.println("프로그램을 종료합니다.");
	}

}
