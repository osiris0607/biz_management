package com.anchordata.webframework.base.util;

import java.util.List;
import java.util.Arrays;
import java.util.Base64.Encoder;

import javax.mail.internet.InternetAddress;

import org.json.simple.JSONObject;
import org.json.simple.parser.JSONParser;
import org.springframework.stereotype.Service;

import com.anchordata.webframework.service.emailSMS.emailSMSVO;
import com.google.gson.Gson;

import okhttp3.MediaType;
import okhttp3.OkHttpClient;
import okhttp3.Request;
import okhttp3.RequestBody;
import okhttp3.Response;
import okhttp3.ResponseBody;

@Service("GabiaSmsSender")
public class GabiaSmsSender {

	static String accessToken = "";
	//사용자 인증
	public static boolean userAuth() {
		try {

			OkHttpClient client = new OkHttpClient();
			
			// RequestBody 생성
			MediaType mediaType = MediaType.parse("application/x-www-form-urlencoded");
			RequestBody requestBody = RequestBody.create(mediaType,"grant_type=client_credentials");
			
			//API_KEY : 62dbc6f3d21edffc04122c893e47d380 - base64로 인코딩
			String apiKey = "innotech0941:62dbc6f3d21edffc04122c893e47d380";
			byte[] testToByte = apiKey.getBytes();
			
			Encoder encode = java.util.Base64.getEncoder();
			byte[] encodeByte = encode.encode(testToByte);
			
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
			System.out.println("response message:: "+response.message());

			if (response.isSuccessful()) {
				ResponseBody body = response.body();
				if (body != null) {
					//accessToken 추출하기위해 JSON 파싱
				String strJson = body.string();
				JSONParser jsonParser = new JSONParser();
				Object obj = jsonParser.parse(strJson);
				JSONObject jsonObj = (JSONObject) obj;
				
		        accessToken = (String) jsonObj.get("access_token");
				}
			} else {
				System.out.println("Error Occurred :: " + response);
				return false;
			}
		} catch (Exception e) {
			e.printStackTrace();
		}
		return true;
	}

	
	//단문 SMS 발송
	public static boolean sendSMS(emailSMSVO vo) {
		String title = vo.getTitle();
		String comment = vo.getComment();
		List<String> toPhone = vo.getTo_phone();
		String link = vo.getLink();
		String senderName = vo.getSender();
		
		String message = comment + "\r\n" + link;
		try {
			//사용자 인증
			if(userAuth() == true) {
				System.out.println("userAuth ::: 성공" );
			}else {
				System.out.println("userAuth ::: 실패 ");
			}
			InternetAddress[] address = new InternetAddress[toPhone.size()];
            int index = 0;
            for (String phone : toPhone) {
            	address[index] = new InternetAddress(phone);
            	index++;
            }
			System.out.println("수신자 목록" + Arrays.toString(address));
			OkHttpClient client = new OkHttpClient();

			MediaType mediaType = MediaType.parse("application/x-www-form-urlencoded");
			
			//API_KEY : 62dbc6f3d21edffc04122c893e47d380 - base64로 인코딩
			String refKey = "RESTAPITEST1547509989";
			String authorization = "innotech0941:" + accessToken;
			byte[] testToByte = authorization.getBytes();
			
			Encoder encode = java.util.Base64.getEncoder();
			byte[] encodeByte = encode.encode(testToByte);
			
			System.out.println("인코딩 전: "+ authorization);
			System.out.println("인코딩: "+ new String(encodeByte));
			
			for(int i = 0; i < address.length; i++) {
				System.out.println("대상 폰넘버: "+ address[i]);
			
				RequestBody requestBody = RequestBody.create(mediaType,
						"phone="+address[i]+"&callback=0269120941&message="+message+"&refkey="+refKey);
				Request request = new Request.Builder().url("https://sms.gabia.com/api/send/sms").post(requestBody)
						.addHeader("Content-Type", "application/x-www-form-urlencoded")
						.addHeader("Authorization",
								"Basic " + new String(encodeByte))
						.addHeader("cache-control", "no-cache").build();
	
				//발송
				Response response = client.newCall(request).execute();
				
				//결과 확인
				sendResult(refKey);
				if (response.isSuccessful()) {
					ResponseBody body = response.body();
					if (body != null) {
						System.out.println("Response : " + body.string());
					}
				} else {
					System.out.println("Error Occurred :: " + response);
					return false;
				}
			}
		} catch (Exception e) {
			e.printStackTrace();
		}
		return true;
	}
	
	//장문 LMS 발송
		public static boolean sendLMS(emailSMSVO vo) {
			String title = vo.getTitle();
			String comment = vo.getComment();
			List<String> toPhone = vo.getTo_phone();
			String link = vo.getLink();
			String senderName = vo.getSender();
			
			String message = comment + "\r\n" + link;
			System.out.println(message);
			
			try {
				//사용자 인증
				//userAuth();
				if(userAuth() == true) {
					System.out.println("userAuth ::: true" );
				}else {
					System.out.println("userAuth ::: 실패 ");
				}
				InternetAddress[] address = new InternetAddress[toPhone.size()];
	            int index = 0;
	            for (String phone : toPhone) {
	            	address[index] = new InternetAddress(phone);
	            	index++;
	            }
				System.out.println("수신자 목록" + Arrays.toString(address));
				OkHttpClient client = new OkHttpClient();

				MediaType mediaType = MediaType.parse("application/x-www-form-urlencoded");
				
				String refKey = "RESTAPITEST1547509990";
				String authorization = "innotech0941:" + accessToken;
				byte[] testToByte = authorization.getBytes();
				
				Encoder encode = java.util.Base64.getEncoder();
				byte[] encodeByte = encode.encode(testToByte);
				
				System.out.println("인코딩 전: "+ authorization);
				System.out.println("인코딩: "+ new String(encodeByte));
				for(int i = 0; i < address.length; i++) {
					System.out.println("대상 폰넘버: "+ address[i]);
				
					RequestBody requestBody = RequestBody.create(mediaType,
							"phone="+address[i]+"&callback=0269120941&message="+message+"&refkey="+refKey+"&subject="+title);
					Request request = new Request.Builder().url("https://sms.gabia.com/api/send/lms").post(requestBody)
							.addHeader("Content-Type", "application/x-www-form-urlencoded")
							.addHeader("Authorization",
									"Basic " + new String(encodeByte))
							.addHeader("cache-control", "no-cache").build();
		
					//발송
					Response response = client.newCall(request).execute();
					
					//결과 확인
					sendResult(refKey);
					if (response.isSuccessful()) {
						ResponseBody body = response.body();
						if (body != null) {
							System.out.println("Response : " + body.string());
						}
					} else {
						System.out.println("Error Occurred :: " + response);
						return false;
					}
				}
			} catch (Exception e) {
				e.printStackTrace();
			}
			return true;
		}
	
	
	public static boolean sendResult(String refKey) {
		try {
			//사용자 인증
			if(userAuth() == true) {
				System.out.println("userAuth ::: true" );
			}else {
				System.out.println("userAuth ::: 실패 ");
			}
			
			OkHttpClient client = new OkHttpClient();

			MediaType mediaType = MediaType.parse("application/x-www-form-urlencoded");
			
			String authorization = "innotech0941:" + accessToken;
			byte[] testToByte = authorization.getBytes();
			
			Encoder encode = java.util.Base64.getEncoder();
			byte[] encodeByte = encode.encode(testToByte);
			
			System.out.println("결과확인 인코딩 전: "+ authorization);
			System.out.println("결과확인 인코딩: "+ new String(encodeByte));
			
			RequestBody requestBody = RequestBody.create(mediaType,"undefined=");
			Request request = new Request.Builder().url("https://sms.gabia.com/api/result_log/byRefkey?refkey="+refKey).get()
					.addHeader("Authorization",
							"Basic " + new String(encodeByte))
					.addHeader("cache-control", "no-cache").build();

			//발송
			Response response = client.newCall(request).execute();

			if (response.isSuccessful()) {
				ResponseBody body = response.body();
				if (body != null) {
					System.out.println("Response : " + body.string());
				}
			} else {
				System.out.println("Error Occurred :: " + response);
				return false;
			}
		} catch (Exception e) {
			e.printStackTrace();
		}
		return true;
	}
	
}
