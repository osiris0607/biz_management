package com.anchordata.webframework.base.util;

import java.io.File;
import java.io.IOException;
import java.text.DateFormat;
import java.text.SimpleDateFormat;
import java.util.Calendar;
import java.util.Date;
import java.util.List;
import java.util.Properties;

import javax.activation.DataHandler;
import javax.activation.FileDataSource;
import javax.mail.Message;
import javax.mail.MessagingException;
import javax.mail.Multipart;
import javax.mail.Session;
import javax.mail.Transport;
import javax.mail.internet.AddressException;
import javax.mail.internet.InternetAddress;
import javax.mail.internet.MimeBodyPart;
import javax.mail.internet.MimeMessage;
import javax.mail.internet.MimeMultipart;
import javax.mail.internet.MimeUtility;

import org.springframework.web.multipart.MultipartFile;

import com.anchordata.webframework.base.common.email.HTMLDataSource;
import com.anchordata.webframework.base.common.email.MyAuthenticator;

/**
 * @author Sang Hyup Lee
 * @version 1.0
 *
 */
public class NaverMailSender {
    /**
     * @param args
     */
    public static boolean sender(String title, String senderName, List<String> toMail, String contents) throws Exception {
        // TODO Auto-generated method stub
        String host = "smtp.naver.com";//smtp 서버
        //String subject = "인사이트랩입니다.";
        String from = "ozz75@naver.com"; //보내는 메일
        String fromName = senderName;
        
        //String content = "메일발송 테스트 입니다.";
        try {
            // 프로퍼티 값 인스턴스 생성과 기본세션(SMTP 서버 호스트 지정)
            Properties props = new Properties();
            
            // NAVER SMTP 사용시
    		props.put("mail.smtp.host", host);  
    		props.put("mail.smtp.port", "465");  
    		props.put("mail.smtp.auth", "true");  
    		props.put("mail.smtp.ssl.enable", "true");  
    		props.put("mail.smtp.ssl.trust", host); 
    		props.put("defaultEncoding", "utf-8");
    		props.setProperty("mail.smtp.socketFactory.class","javax.net.ssl.SSLSocketFactory");
            
            MyAuthenticator auth = new MyAuthenticator("ozz75", "park03151025");
            
            Session mailSession = Session.getInstance(props, auth);
            
            Message message = new MimeMessage(mailSession);
            message.setFrom(new InternetAddress(from, MimeUtility.encodeText(fromName,"UTF-8","B")));//보내는 사람 설정
            
            InternetAddress[] address = new InternetAddress[toMail.size()];
            int index = 0;
            for (String mail : toMail) {
            	address[index] = new InternetAddress(mail);
            	index++;
            }
            
            contents = contents.replace("&amp;lt;", "<");
            contents = contents.replace("&amp;gt;", ">");
            
            message.setRecipients(Message.RecipientType.TO, address);//받는 사람설정
            message.setSubject(title);// 제목 설정
            message.setSentDate(new java.util.Date());// 보내는 날짜 설정
            message.setContent(contents, "text/html;charset=utf-8"); // 내용 설정 (HTML 형식)
            
            //message.setDataHandler(new DataHandler(new HTMLDataSource(contents)));
            //setHTMLContent(message);
            
            Transport.send(message); // 메일 보내기
            
            System.out.println("메일 발송을 완료하였습니다.");
            
            return true;
        } catch ( AddressException  e ) {
        	System.out.println("AddressException :  " + e.getMessage());
        	e.printStackTrace();
            return false;
        } catch ( MessagingException ex ) {
        	System.out.println("MessagingException : " + ex.getMessage());
        	ex.printStackTrace();
            return false;
        } 
    }
    
    public static boolean gmailSender(String title, String senderName, List<String> toMail, String contents, String link) throws Exception {
        // TODO Auto-generated method stub
        String host = "smtp.gmail.com";//smtp 서버
        //String subject = "인사이트랩입니다.";
        String from = "sitinnotech@gmail.com"; //보내는 메일
        String fromName = senderName;
       // String to = email;
        
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
            
            MyAuthenticator auth = new MyAuthenticator("sitinnotech@gmail.com", "llyhwjusftuwvhlo");
            
            //Session mailSession = Session.getDefaultInstance(props, auth);
            Session mailSession  = Session.getInstance(props, auth);
            Message msg = new MimeMessage(mailSession);
            msg.setFrom(new InternetAddress(from, MimeUtility.encodeText(fromName,"UTF-8","B")));//보내는 사람 설정
            
            InternetAddress[] address = new InternetAddress[toMail.size()];
            int index = 0;
            for (String mail : toMail) {
            	address[index] = new InternetAddress(mail);
            	index++;
            }
            
            //본문 + 링크
            contents = contents + "\r\n" + link;
            contents = contents.replace("\r\n", "<br>");
 //           contents = contents.replace("&amp;gt;", ">");

            //날짜 설정
            Calendar cal = Calendar.getInstance();
            cal.setTime(new Date());
            DateFormat df = new SimpleDateFormat("yyyy-MM-dd");
            cal.add(Calendar.DATE, +7);
            String overDate = df.format(cal.getTime());
            
            contents = contents.replace("sysdate+7", overDate);
            
            
          //받는 사람설정
            msg.setRecipients(Message.RecipientType.TO, address);
            
            msg.setSubject(title);// 제목 설정
            msg.setSentDate(new java.util.Date());// 보내는 날짜 설정
           // msg.setContent(contents, contents); // 내용 설정 (HTML 형식)
            msg.setContent(contents, "text/html;charset=utf-8"); // 내용 설정 (HTML 형식)
            setHTMLContent(msg);
            
            
         // 메일 보내기
            Transport.send(msg); 
            System.out.println("메일 발송을 완료하였습니다.");
            
            return true;
        } catch ( AddressException  e ) {
        	System.out.println("AddressException :  " + e.getMessage());
        	e.printStackTrace();
            return false;
        } catch ( MessagingException ex ) {
        	System.out.println("MessagingException : " + ex.getMessage());
        	ex.printStackTrace();
            return false;
        } 
    }
    
    
    public static String senderWithAttachFile(String title, String email, String contents, MultipartFile multipartFile) throws Exception {
        // TODO Auto-generated method stub
        String host = "smtp.gmail.com";//smtp 서버
        String from = "bareunmedia01@gmail.com"; //보내는 메일
        String fromName = "barunmc";
        String to = email;
        
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
            
            MyAuthenticator auth = new MyAuthenticator("", "");
            
            Session mailSession = Session.getInstance(props, auth);
            
            Message message = new MimeMessage(mailSession);
            message.setFrom(new InternetAddress(from, MimeUtility.encodeText(fromName,"UTF-8","B")));//보내는 사람 설정
            InternetAddress[] address = {new InternetAddress(to)};
            message.setRecipients(Message.RecipientType.TO, address);//받는 사람설정
            
            message.setSubject(title);// 제목 설정
            message.setSentDate(new java.util.Date());// 보내는 날짜 설정
            
            
            MimeBodyPart mbp1 = new MimeBodyPart();
            mbp1.setText(contents);
            String html = "<html><head><title>" +
            		title +
                    "</title></head><body>" +
                    contents +
                    "</body></html>";
            mbp1.setDataHandler(new DataHandler(new HTMLDataSource(html)));
            
            // 파일 첨부
            MimeBodyPart mbp2 = new MimeBodyPart();
            // MultipartFile to file 변환.
            File file = new File(multipartFile.getOriginalFilename());
            multipartFile.transferTo(file);
            FileDataSource fds = new FileDataSource(file);
            mbp2.setDataHandler(new DataHandler(fds));
            mbp2.setFileName(fds.getName());
            
            Multipart mp = new MimeMultipart();
            mp.addBodyPart(mbp1);
            mp.addBodyPart(mbp2);
            
            message.setContent(mp);
            
            Transport.send(message); // 메일 보내기
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
                       "</title></head><body>" +
                       msg.getContent() +
                       "</body></html>";
 
        // HTMLDataSource is a static nested class
        msg.setDataHandler(new DataHandler(new HTMLDataSource(html)));
    }
    
}
