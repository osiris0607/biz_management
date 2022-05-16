/*******************************************************************************
 *
 * Copyright ⓒ 2019 namu C&D corp. All rights reserved.
 *
 * This is a proprietary software of namu C&D corp, and you may not use this file except in
 * compliance with license agreement with namu C&D corp. Any redistribution or use of this
 * software, with or without modification shall be strictly prohibited without prior written
 * approval of namu C&D corp, and the copyright notice above does not evidence any actual or
 * intended publication of such software.
 *
 *******************************************************************************/
package com.anchordata.webframework.base.common.security.encoder;

import java.security.MessageDigest;
import java.security.SecureRandom;
import java.util.Base64;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Component;

@Component
public class SHA256PasswordEncoder {
	
	protected transient Logger logger = LoggerFactory.getLogger(this.getClass());

	private final static int ITERATION_NUMBER = 1000;
	
	public String encode(String rawPassword, String salt) {
		return getPassword(rawPassword, salt);
	}

	public boolean matches(String rawPassword, String encodedPassword, String salt) {
		String encriptPassword = getPassword(rawPassword, salt);
		return encriptPassword.equals(encodedPassword);
	}
	
	/**
	 * SALT 생성
	 * @return
	 * @throws NoSuchAlgorithmException
	 */
	public String getSalt() {
		String value = "";
		try {
			SecureRandom secureRandom = SecureRandom.getInstance("SHA1PRNG");
			// Salt generation 128 bits long
			byte[] salt = new byte[16];
			secureRandom.nextBytes(salt);
			byte[] encoded = Base64.getEncoder().encode(salt);
			return new String(encoded);
		} catch(Exception e) {
			logger.error(e.getMessage());
		}
		return value;
	}
	
	/**
	 * 비밀번호 생성
	 * @param password 평문 비밀번호
	 * @param salt
	 * @return
	 * @throws Exception
	 */
	public String getPassword(String password, String salt) {
		String encriptPassword = "";
		try {
			MessageDigest digest = MessageDigest.getInstance("SHA-256");
			digest.reset();
			digest.update(salt.getBytes());
			byte[] input = digest.digest(password.getBytes("UTF-8"));
			for (int i = 0; i < ITERATION_NUMBER; i++) {
				digest.reset();
				input = digest.digest(input);
			}
			
			encriptPassword =  new String(Base64.getEncoder().encode(input));
		} catch(Exception e) {
			logger.error(e.getMessage());
		}
		return encriptPassword;
	}
}
