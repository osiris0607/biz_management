package com.anchordata.webframework.base.util;

import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStreamReader;
import java.net.HttpURLConnection;
import java.net.URL;

import com.google.gson.JsonArray;
import com.google.gson.JsonElement;
import com.google.gson.JsonObject;
import com.google.gson.JsonParser;

public class SGISOpenAPI {
	static public String getAccessToken (String publicKey, String serviceId) {
        String accessToken = "";
        String reqURL = "https://sgisapi.kostat.go.kr/OpenAPI3/auth/authentication.json" +
					   	"?consumer_key=" + serviceId + 
					   	"&consumer_secret=" + publicKey;
        
        try {
            URL url = new URL(reqURL);
            HttpURLConnection conn = (HttpURLConnection) url.openConnection();
            
            //    POST 요청을 위해 기본값이 false인 setDoOutput을 true로
            conn.setRequestMethod("GET");
            
            //    결과 코드가 200이라면 성공
            int responseCode = conn.getResponseCode();
 
            //    요청을 통해 얻은 JSON타입의 Response 메세지 읽어오기
            BufferedReader br = new BufferedReader(new InputStreamReader(conn.getInputStream()));
            String line = "";
            String result = "";
            
            while ((line = br.readLine()) != null) {
                result += line;
            }
            
            // Gson 라이브러리에 포함된 클래스로 JSON파싱 객체 생성
            JsonParser parser = new JsonParser();
            JsonElement element = parser.parse(result);
            
	        JsonObject resultJson = element.getAsJsonObject().get("result").getAsJsonObject();
            accessToken = resultJson.getAsJsonObject().get("accessToken").getAsString();
            
            br.close();
//            bw.close();
        } catch (IOException e) {
            // TODO Auto-generated catch block
            e.printStackTrace();
        } 
        
        return accessToken;
    }
	
	
	static public JsonArray getSIDOInfo(String accessToken) {
	    String reqURL = "https://sgisapi.kostat.go.kr/OpenAPI3/addr/stage.json" +
	    				"?accessToken=" + accessToken + 
	    				"&pg_yn=0";
	    try {
	        URL url = new URL(reqURL);
	        HttpURLConnection conn = (HttpURLConnection) url.openConnection();
	        conn.setRequestMethod("GET");
	        
	        int responseCode = conn.getResponseCode();
	        System.out.println("responseCode : " + responseCode);
	        
	        BufferedReader br = new BufferedReader(new InputStreamReader(conn.getInputStream()));
	        
	        String line = "";
	        String result = "";
	        
	        while ((line = br.readLine()) != null) {
	            result += line;
	        }
	        
	        JsonParser parser = new JsonParser();
	        JsonElement element = parser.parse(result);
	        
	        JsonArray resultJson = (JsonArray) element.getAsJsonObject().get("result").getAsJsonArray();
	        return resultJson;
	        
	    } catch (IOException e) {
	        // TODO Auto-generated catch block
	        e.printStackTrace();
	        return null;
	    }
	}
	
	
	static public JsonArray getSIDODetailInfo(String accessToken, String cd) {
	    String reqURL = "https://sgisapi.kostat.go.kr/OpenAPI3/addr/stage.json" +
	    				"?accessToken=" + accessToken + 
	    				"&cd=" + cd + 
	    				"&pg_yn=0";
	    try {
	        URL url = new URL(reqURL);
	        HttpURLConnection conn = (HttpURLConnection) url.openConnection();
	        conn.setRequestMethod("GET");
	        
	        int responseCode = conn.getResponseCode();
	        System.out.println("responseCode : " + responseCode);
	        
	        BufferedReader br = new BufferedReader(new InputStreamReader(conn.getInputStream()));
	        
	        String line = "";
	        String result = "";
	        
	        while ((line = br.readLine()) != null) {
	            result += line;
	        }
	        
	        JsonParser parser = new JsonParser();
	        JsonElement element = parser.parse(result);
	        
	        JsonArray resultJson = (JsonArray) element.getAsJsonObject().get("result").getAsJsonArray();
	        return resultJson;
	        
	    } catch (IOException e) {
	        // TODO Auto-generated catch block
	        e.printStackTrace();
	        return null;
	    }
	}
	
	

}
