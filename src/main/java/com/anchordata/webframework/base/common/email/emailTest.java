package com.anchordata.webframework.base.common.email;

import com.anchordata.webframework.base.util.TempKey;

public class emailTest {

	@SuppressWarnings("static-access")
	public static void main(String[] args) {
		// TODO Auto-generated method stub
		
		String key = new TempKey().getKey(50, false); // 인증키 생성
		//String authKey = key;
		String baseUrl = "http://localhost:8080/media/authEmail";
		String title = "testEmail";
		GMailSender sender = new GMailSender();
		try {
			//System.out.println(sender.sender("타이틀", "네임", "01028828284", "jinu0425@naver.com", key));
		} catch (Exception e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
			System.out.println("e:"+e.getMessage());
		}
	}

}
