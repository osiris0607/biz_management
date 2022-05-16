package com.anchordata.webframework.base.common.email;

import java.io.IOException;
import java.util.Properties;

import javax.activation.DataHandler;
import javax.mail.Message;
import javax.mail.MessagingException;
import javax.mail.Session;
import javax.mail.Transport;
import javax.mail.internet.InternetAddress;
import javax.mail.internet.MimeMessage;
import javax.mail.internet.MimeUtility;

/**
 * @author Sang Hyup Lee
 * @version 1.0
 *
 */
public class GMailSender {
    /**
     * @param args
     */
    public static String sender(String title, String email, String contents) throws Exception {
        // TODO Auto-generated method stub
        String host = "smtp.gmail.com";//smtp 서버
        //String subject = "인사이트랩입니다.";
        String from = "orcl@namucnd.com"; //보내는 메일
        String fromName = "나무씨앤디 김코치";
        String to = email;
        
        //String content = "메일발송 테스트 입니다.";
        try {
            // 프로퍼티 값 인스턴스 생성과 기본세션(SMTP 서버 호스트 지정)
            Properties props = new Properties();
            
            // G-Mail SMTP 사용시
            props.put("mail.smtp.starttls.enable","true");
            props.put("mail.transport.protocol", "smtp");
            props.put("mail.smtp.host", host);
            props.setProperty("mail.smtp.socketFactory.class","javax.net.ssl.SSLSocketFactory");
            props.put("mail.smtp.port", "465");
            props.put("mail.smtp.auth", "true");
            
            MyAuthenticator auth = new MyAuthenticator("jinu0425@gmail.com", "zlupiodpgntttlpr");
            
            Session mailSession = Session.getDefaultInstance(props, auth);
            
            Message msg = new MimeMessage(mailSession);
            msg.setFrom(new InternetAddress(from, MimeUtility.encodeText(fromName,"UTF-8","B")));//보내는 사람 설정
            InternetAddress[] address = {new InternetAddress(to)};
            msg.setRecipients(Message.RecipientType.TO, address);//받는 사람설정
            
            msg.setSubject(title);// 제목 설정
            msg.setSentDate(new java.util.Date());// 보내는 날짜 설정
            msg.setContent(contents, contents); // 내용 설정 (HTML 형식)
            
            setHTMLContent(msg);
            
            Transport.send(msg); // 메일 보내기
            
            System.out.println("메일 발송을 완료하였습니다.");
            
            return "success";
        } catch ( MessagingException ex ) {
        	System.out.println("mail send error : " + ex.getMessage());
        	System.out.println("mail send error : " + ex.getStackTrace());
            return "mail send error : " + ex.getStackTrace();
        } catch ( Exception e ) {
        	System.out.println("error :  " + e.getMessage());
        	System.out.println("error :  " + e.getStackTrace());
            return "error : " + e.getMessage();
        }
    }
    
    public static void setHTMLContent(Message msg) throws MessagingException, IOException {
    	 
        String html = "<html><head><title>" +
                        msg.getSubject() +
                        "</title></head><body><h1>" +
                        msg.getContent() +
                        "</h1><p>해찬솔 이메일 인증입니다.</p></body></html>";
 
        // HTMLDataSource is a static nested class
        msg.setDataHandler(new DataHandler(new HTMLDataSource(html)));
    }
    
}
