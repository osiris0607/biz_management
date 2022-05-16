package com.anchordata.webframework.base.util;

import java.util.Base64.Encoder;

import org.json.simple.JSONObject;
import org.springframework.stereotype.Service;

import okhttp3.MediaType;
import okhttp3.OkHttpClient;
import okhttp3.Request;
import okhttp3.RequestBody;
import okhttp3.Response;
import okhttp3.ResponseBody;

@Service("GabiaSmsSender")
public class GabiaSmsSender {

	//사용자 인증
	public boolean userAuth() {
		System.out.println("호출됐니???");
		try {

			OkHttpClient client = new OkHttpClient();
			
			// RequestBody 생성
			MediaType mediaType = MediaType.parse("application/x-www-form-urlencoded");
			
			//requestBody JSON 세팅
			//JSONObject data = new JSONObject();
			//data.put("client_id", "innotech0941");
			//data.put("client_secret", "password");
			//data.put("grant_type", "client_credentials");
			
			//RequestBody requestBody = RequestBody.create(mediaType, data.toString());

			 RequestBody requestBody = RequestBody.create(mediaType,"grant_type=client_credential");

			
			System.out.println(requestBody.contentType());
			
			//API_KEY : 62dbc6f3d21edffc04122c893e47d380
			String apiKey = "innotech0941:62dbc6f3d21edffc04122c893e47d380";
			byte[] testToByte = apiKey.getBytes();
			
			Encoder encode = java.util.Base64.getEncoder();
			byte[] encodeByte = encode.encode(testToByte);
			
			System.out.println("인코딩 전: "+ apiKey);
			System.out.println("인코딩: "+ new String(encodeByte));
			
			
			
			// Post 객체 생성
			Request request = new Request.Builder()
					.url("https://sms.gabia.com/oauth/token")
					.post(requestBody)
					.addHeader("Content-Type", "application/x-www-form-urlencoded")
					.addHeader("Authorization", "Basic aW5ub3RlY2gwOTQxOjYyZGJjNmYzZDIxZWRmZmMwNDEyMmM4OTNlNDdkMzgw")
					.addHeader("cache-control", "no-cache")
					.build();
			// 요청 전송
			Response response = client.newCall(request).execute();
			System.out.println("request HEADER:: "+request.headers());
			System.out.println("request requestBody:: "+requestBody);
			System.out.println("response message:: "+response.message());

			//if (response.isSuccessful()) {
				ResponseBody body = response.body();
				//if (body != null) {
				//	System.out.println("Response : " + body.string());
				//}
			//} else {
				System.out.println("Response : " + body.string());
				System.out.println("Error Occurred :: " + response);
			//}
			return false;
		} catch (Exception e) {
			e.printStackTrace();
		}
		return true;
	}

	
	//단문 SMS 발송
	public boolean sendSms(String phone, String message) {
		try {
			OkHttpClient client = new OkHttpClient();

			MediaType mediaType = MediaType.parse("application/x-www-form-urlencoded");
			RequestBody requestBody = RequestBody.create(mediaType,
					"phone="+phone+"&callback=15444370&message="+message+"&refkey=RESTAPITEST1547509987");
			Request request = new Request.Builder().url("https://sms.gabia.com/api/send/sms").post(requestBody)
					.addHeader("Content-Type", "application/x-www-form-urlencoded")
					.addHeader("Authorization",
							"Basic DckviEksLs6ZXlKMGVYQWlPaUpLVhiR2NpT2lKU1V6STFOaUo5LmV5SnBjM01pT2lKb2RIUndjenBjTDF3dmMyMXpMbWRoWW1saExtTnZiVnd2SWl3aVlYVmtJam9pWEM5dllYVjBhRnd2ZEc5clpXNGlMQ0pshWFhnT2pBNG5uVkVuLWtnVEJoRGpPeWc=")
					.addHeader("cache-control", "no-cache").build();

			Response response = client.newCall(request).execute();

			if (response.isSuccessful()) {
				ResponseBody body = response.body();
				if (body != null) {
					System.out.println("Response : " + body.string());
				}
			} else {
				System.out.println("Error Occurred :: " + response);
			}
			return false;
		} catch (Exception e) {
			e.printStackTrace();
		}
		return true;
	}
}
