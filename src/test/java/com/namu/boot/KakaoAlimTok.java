package com.namu.boot;

import java.io.IOException;
import java.io.UnsupportedEncodingException;

import org.apache.http.HttpResponse;
import org.apache.http.client.ClientProtocolException;
import org.apache.http.client.HttpClient;
import org.apache.http.client.methods.HttpPost;
import org.apache.http.entity.ContentType;
import org.apache.http.entity.StringEntity;
import org.apache.http.impl.client.HttpClientBuilder;
import org.codehaus.jackson.JsonNode;
import org.codehaus.jackson.map.ObjectMapper;
import org.json.simple.JSONArray;
import org.json.simple.JSONObject;

public class KakaoAlimTok {

	@SuppressWarnings({ "unchecked", "unused" })
	public static void main(String[] args) {
		// TODO Auto-generated method stub
		final String RequestUrl = "https://api.tason.com/tas-api/kakaosend";

		final HttpClient client = HttpClientBuilder.create().build();
		final HttpPost httpPost  = new HttpPost(RequestUrl);
		JSONObject json = new JSONObject();
		JSONObject jsonData = new JSONObject();
		JSONArray jsonArr = new JSONArray();

		// add header
		httpPost.addHeader("content-type", "application/json");
		// add header
		JsonNode returnNode = null;

		try {

			json.put("tas_id", "goodmorris");
			json.put("send_type", "KA");
			json.put("auth_key", "SJV3FP-HME80Y-X1QQV1-GIJWW4_220");
			
			jsonData.put("user_name", "이진우");
			jsonData.put("user_email", "821028828284");
			jsonData.put("map_content", "안녕하세요. 바른미디어 입니다. \n이진우님 새로운 번역 의뢰가 있습니다. \n홈페이지에서 지원해 주세요.");
			jsonData.put("sender", "821033448284");
			jsonData.put("sender_name", "namuCnd");
			jsonData.put("template_code", "C_ZS_020_02_18926");
			jsonArr.add(jsonData);
			json.put("data", jsonArr);
			System.out.println("json.toString():"+ json.toString());
			httpPost.setEntity(new StringEntity(json.toString(), ContentType.APPLICATION_JSON));
			final HttpResponse response = client.execute(httpPost);
			final int responseCode = response.getStatusLine().getStatusCode();
			
			System.out.println("\nSending 'POST' request to URL : " + RequestUrl);
			System.out.println("Response Code : " + responseCode);

			// JSON
			ObjectMapper mapper = new ObjectMapper();
			returnNode = mapper.readTree(response.getEntity().getContent());

		} catch (UnsupportedEncodingException e) {
			e.printStackTrace();
		} catch (ClientProtocolException e) {
			e.printStackTrace();
		} catch (IOException e) {
			e.printStackTrace();
		} finally {
			// clear resources
		}
	}

}
