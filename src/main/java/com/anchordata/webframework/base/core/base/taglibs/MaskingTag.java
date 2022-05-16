package com.anchordata.webframework.base.core.base.taglibs;

import java.io.IOException;
import java.util.Arrays;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

import javax.servlet.jsp.JspException;
import javax.servlet.jsp.JspWriter;
import javax.servlet.jsp.tagext.TagSupport;

public class MaskingTag extends TagSupport {

	private static final long serialVersionUID = -3873102923861663894L;
	
	private static final String PHONE_NUM_PATTERN = "(01[016789])(\\d{3,4})(\\d{4})";
	
	private static final String EMAIL_PATTERN = "^[_A-Za-z0-9-\\+]+(\\.[_A-Za-z0-9-]+)*@" + "[A-Za-z0-9-]+(\\.[A-Za-z0-9]+)*(\\.[A-Za-z]{2,})$";
	
	private static final String MAC_PATTERN = "^([0-9A-Fa-f]{2}[:-]){5}([0-9A-Fa-f]{2})$";
	
	private static final String IP_PATTERN = "^([0-9]{1,3})\\.([0-9]{1,3})\\.([0-9]{1,3})\\.([0-9]{1,3})$";
	
	private String value;
	
	public int doEndTag() throws JspException {
		try {
			JspWriter out = pageContext.getOut();
			String contents = getMaskedValue(value);
			
			out.println(contents);
			return EVAL_PAGE;
		} catch (IOException e) {
			throw new JspException();
		}
	}
	
	/**
	 * 이메일이든, 휴대폰번호든 각 포맷에 맞게 마스킹된 결과값 리턴해주는 함수 포맷이 맞지 않을 경우 인풋으로 들어온 값 그대로 리턴
	 * 
	 * @param id
	 * @return
	 */
	public String getMaskedValue(String value) {
		if (isEmail(value)) {
			return getMaskedEmail(value);
		} else if (isPhoneNum(value)) {
			return getMaskedPhoneNum(value);
		} else if (isMacAddr(value)) {
			return getMaskedMacAddr(value);
		} else if (isIp(value)) {
			return getMaskedIp(value);
		}
		return value;
	}
	

	/**
	 * 이메일 포맷 Validator
	 * 
	 * @param str
	 * @return
	 */
	private boolean isEmail(final String str) {
		return isValid(EMAIL_PATTERN, str);
	}

	/**
	 * 휴대폰 번호 포맷 Validator
	 * 
	 * @param str
	 * @return
	 */
	private boolean isPhoneNum(final String str) {
		return isValid(PHONE_NUM_PATTERN, str);
	}
	
	/**
	 * 맥어드레스 번호 포맷 Validator
	 * 
	 * @param str
	 * @return
	 */
	private boolean isMacAddr(final String str) {
		return isValid(MAC_PATTERN, str);
	}
	
	/**
	 * 아이피 포맷 Validator
	 * 
	 * @param str
	 * @return
	 */
	private boolean isIp(final String str) {
		return isValid(IP_PATTERN, str);
	}

	/**
	 * 문자열이 정규식에 맞는 포맷인지 체크
	 * 
	 * @param regex
	 * @param target
	 * @return
	 */
	private boolean isValid(final String regex, final String target) {
		Matcher matcher = Pattern.compile(regex).matcher(target);
		return matcher.matches();
	}

	/**
	 * 이메일 주소 마스킹 처리
	 * 
	 * @param email
	 * @return
	 */
	private String getMaskedEmail(String email) {      
		String regex = "\\b(\\S+)+@(\\S+.\\S+)";
		Matcher matcher = Pattern.compile(regex).matcher(email);
		if (matcher.find()) {
			String id = matcher.group(1);			
			int length = id.length();
			if (length < 3) {
				char[] c = new char[length];
				Arrays.fill(c, '*');
				return email.replace(id, String.valueOf(c));
			} else if (length == 3) {
				return email.replaceAll("\\b(\\S+)[^@][^@]+@(\\S+)", "$1**@$2");
			} else {
				return email.replaceAll("\\b(\\S{2})[^@][^@][^@]+@(\\S+)", "$1***@$2");
			}
		}
		return email;
	}

	/**
	 * 휴대폰 번호 마스킹 처리
	 * 
	 * @param phoneNum
	 * @return
	 */
	private static String getMaskedPhoneNum(String phoneNum) {		
		String regex = "(01[016789])(\\d{3,4})\\d{4}$";
		Matcher matcher = Pattern.compile(regex).matcher(phoneNum);
		if (matcher.find()) {
			String replaceTarget = matcher.group(2);
			char[] c = new char[replaceTarget.length()];
			Arrays.fill(c, '*');
			String maskPhone = phoneNum.replace(replaceTarget, String.valueOf(c));
			return maskPhone.substring(0, 3) + "-"
					+maskPhone.substring(3, 3 + replaceTarget.length())+"-"
					+maskPhone.substring(3 + replaceTarget.length(), maskPhone.length());
		}
		return phoneNum;
	}
	
	private static String getMaskedMacAddr(String macAddr) {
		/*
		Matcher matcher = Pattern.compile(MAC_PATTERN).matcher(macAddr);
		if (matchFind) {
			
			String replaceTarget = matcher.group(1);
			char[] c = new char[replaceTarget.length()];
			Arrays.fill(c, '*');
			String maskMac = macAddr.replace(replaceTarget, String.valueOf(c));
			return maskMac.substring(0, 1) + ":"
					
					+maskMac.substring(3, 3 + replaceTarget.length())+":"
					+maskMac.substring(3 + replaceTarget.length(), maskMac.length());
			
			
		}
		
		return macAddr;
		*/
		String hyphen = macAddr.substring(2, 3);
		String asterisk = hyphen + "**" + hyphen + "**" + hyphen + "**" + hyphen + "**";
		
		return macAddr.substring(0, 5) + asterisk;
	}
	
	private static String getMaskedIp(String str) {
		StringBuffer replaceString = new StringBuffer();
		Matcher matcher = Pattern.compile("^([0-9]{1,3})\\.([0-9]{1,3})\\.([0-9]{1,3})\\.([0-9]{1,3})$").matcher(str);
		
		if (matcher.matches()) {
			for (int i=1;i<=matcher.groupCount();i++) {
				String replaceTarget = matcher.group(i);
				if (i == 1) {
					char[] c = new char[replaceTarget.length()];
					Arrays.fill(c, '*');
					replaceString.append(String.valueOf(c));	
				} else if (i == 3) {
					char[] c = new char[replaceTarget.length()];
					Arrays.fill(c, '*');
					replaceString.append(String.valueOf(c));
				} else {
					replaceString.append(replaceTarget);
				}
				if (i < matcher.groupCount()) {
					replaceString.append(".");
				}
			}
		}
		return replaceString.toString();
	}

	public String getValue() {
		return value;
	}

	public void setValue(String value) {
		this.value = value;
	}
}
