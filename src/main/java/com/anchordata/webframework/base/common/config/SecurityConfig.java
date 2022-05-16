package com.anchordata.webframework.base.common.config;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.core.annotation.Order;
import org.springframework.security.config.annotation.method.configuration.EnableGlobalMethodSecurity;
import org.springframework.security.config.annotation.web.builders.HttpSecurity;
import org.springframework.security.config.annotation.web.builders.WebSecurity;
import org.springframework.security.config.annotation.web.configuration.EnableWebSecurity;
import org.springframework.security.config.annotation.web.configuration.WebSecurityConfigurerAdapter;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.security.web.util.matcher.AntPathRequestMatcher;

import com.anchordata.webframework.base.common.security.handler.LoginAdminHomeSuccessHandler;
import com.anchordata.webframework.base.common.security.handler.LoginFailureHandler;
import com.anchordata.webframework.base.common.security.handler.LoginSuccessHandler;

@Configuration 
@EnableWebSecurity 
@EnableGlobalMethodSecurity(prePostEnabled = true, securedEnabled = true)
public class SecurityConfig {

	
	/**
	 * PasswordEncoder configuration
	 * 
	 * @return
	 */
	@Bean
	public PasswordEncoder passwordEncoder() {
		return new BCryptPasswordEncoder();
	}
	

	// 평가관리 관리자
	@Configuration
	@Order(1)
	public static class App11ConfigurationAdapter extends WebSecurityConfigurerAdapter {

		@Autowired
		LoginSuccessHandler loginSuccessHandler;
		@Autowired
		LoginFailureHandler loginFailureHandler;
		@Autowired
		private CustomAuthenticationEntryPoint authenticationEntryPoint;
		
		@Override
		public void configure(WebSecurity web) throws Exception {
			web.ignoring().antMatchers("/assets/**");
		}

	    @Override
	    protected void configure(HttpSecurity http) throws Exception {
	    	http.httpBasic().disable().csrf().disable();
	    	
	    	http.authorizeRequests()
    			.antMatchers("/member/**").access("hasAnyRole('ROLE_SUPER_ADMIN','ROLE_MEMBER','ROLE_ADMIN','ROLE_MANAGER','ROLE_EXPERT','ROLE_COMMISSIONER')")
    			.antMatchers("/admin/**").access("hasAnyRole('ROLE_SUPER_ADMIN','ROLE_ADMIN','ROLE_MANAGER')")
    			.antMatchers("/adminHome/**").access("hasAnyRole('ROLE_SUPER_ADMIN','ROLE_ADMIN','ROLE_MANAGER')");
		
	    	
			http.antMatcher("/admin/**").authorizeRequests()
				.antMatchers("/", "/verifyEmail", "/signUp", "/error", "/logoutJson", "/user/**", "/userHome/**").permitAll()
				.and().exceptionHandling().authenticationEntryPoint(authenticationEntryPoint);
			
			// login
			http.formLogin().loginPage("/admin/fwd/login/adminLogin")
//				.defaultSuccessUrl("/user/member/loginSuccess")
//				.failureUrl("/user/member/loginFail")
				.failureHandler(loginFailureHandler)
				.successHandler(loginSuccessHandler)
//	       	.loginProcessingUrl("/login")
				.usernameParameter("member_id").passwordParameter("pwd").permitAll();

			// logout
			http.logout().invalidateHttpSession(true).clearAuthentication(true)
						 .logoutRequestMatcher(new AntPathRequestMatcher("/logout")).logoutSuccessUrl("/member/login")
						 .permitAll();
	    }
	}
	
	// Home 관리자
	@Configuration
	@Order(2)
	public static class App2ConfigurationAdapter extends WebSecurityConfigurerAdapter {

		@Autowired
		LoginAdminHomeSuccessHandler loginSuccessHandler;
		@Autowired
		LoginFailureHandler loginFailureHandler;
		@Autowired
		private CustomAuthenticationEntryPoint authenticationEntryPoint;
		
		@Override
		public void configure(WebSecurity web) throws Exception {
			web.ignoring().antMatchers("/assets/**");
		}

	    @Override
	    protected void configure(HttpSecurity http) throws Exception {
	    	http.httpBasic().disable().csrf().disable();
	    	
	    	http.authorizeRequests()
    			.antMatchers("/member/**").access("hasAnyRole('ROLE_SUPER_ADMIN','ROLE_MEMBER','ROLE_ADMIN','ROLE_MANAGER','ROLE_EXPERT','ROLE_COMMISSIONER')")
    			.antMatchers("/admin/**").access("hasAnyRole('ROLE_SUPER_ADMIN','ROLE_ADMIN','ROLE_MANAGER')")
    			.antMatchers("/adminHome/**").access("hasAnyRole('ROLE_SUPER_ADMIN','ROLE_ADMIN','ROLE_MANAGER')");
		
	    	
			http.antMatcher("/adminHome/**").authorizeRequests()
				.antMatchers("/", "/verifyEmail", "/signUp", "/error", "/logoutJson", "/user/**", "/userHome/**").permitAll()
				.and().exceptionHandling().authenticationEntryPoint(authenticationEntryPoint);
			
			// login
			http.formLogin().loginPage("/adminHome/login")
//					.defaultSuccessUrl("/user/member/loginSuccess")
//					.failureUrl("/user/member/loginFail")
				.failureHandler(loginFailureHandler)
				.successHandler(loginSuccessHandler)
//		       	.loginProcessingUrl("/login")
				.usernameParameter("member_id").passwordParameter("pwd").permitAll();

			// logout
			http.logout().invalidateHttpSession(true).clearAuthentication(true)
						 .logoutRequestMatcher(new AntPathRequestMatcher("/logout")).logoutSuccessUrl("/member/login")
						 .permitAll();
	    }
	}
	
	// 회원
	@Configuration
	@Order(3)
	public static class App3ConfigurationAdapter  extends WebSecurityConfigurerAdapter {

		@Autowired
		LoginSuccessHandler loginSuccessHandler;
		@Autowired
		LoginFailureHandler loginFailureHandler;
		@Autowired
		private CustomAuthenticationEntryPoint authenticationEntryPoint;
		
	    @Override
		public void configure(WebSecurity web) throws Exception {
			web.ignoring().antMatchers("/assets/**");
		}

	    @Override
	    protected void configure(HttpSecurity http) throws Exception {
	    	http.httpBasic().disable().csrf().disable();

			http.authorizeRequests()
		        .antMatchers("/member/**").access("hasAnyRole('ROLE_SUPER_ADMIN','ROLE_MEMBER','ROLE_ADMIN','ROLE_MANAGER','ROLE_EXPERT','ROLE_COMMISSIONER')")
		        .antMatchers("/admin/**").access("hasAnyRole('ROLE_SUPER_ADMIN','ROLE_ADMIN','ROLE_MANAGER')")
				.antMatchers("/adminHome/**").access("hasAnyRole('ROLE_SUPER_ADMIN','ROLE_ADMIN','ROLE_MANAGER')");
			
			http.antMatcher("/member/**").authorizeRequests()
					.antMatchers("/", "/verifyEmail", "/signUp", "/error", "/logoutJson", "/user/**", "/userHome/**").permitAll()
					.and().exceptionHandling().authenticationEntryPoint(authenticationEntryPoint);
			// login
			http.formLogin().loginPage("/member/login")
//				.defaultSuccessUrl("/user/member/loginSuccess")
//				.failureUrl("/user/member/loginFail")
				.failureHandler(loginFailureHandler)
				.successHandler(loginSuccessHandler)
//		       	.loginProcessingUrl("/login")
				.usernameParameter("member_id").passwordParameter("pwd").permitAll();
	    }
	}
	
	// 사용자
	@Configuration
	@Order(4)
	public static class App4ConfigurationAdapter  extends WebSecurityConfigurerAdapter {

		@Autowired
		LoginSuccessHandler loginSuccessHandler;
		@Autowired
		LoginFailureHandler loginFailureHandler;
		
		
	    @Override
		public void configure(WebSecurity web) throws Exception {
			web.ignoring().antMatchers("/assets/**");
		}

	    @Override
	    protected void configure(HttpSecurity http) throws Exception {
	    	http.httpBasic().disable().csrf().disable();

			http.authorizeRequests()
		        .antMatchers("/member/**").access("hasAnyRole('ROLE_SUPER_ADMIN','ROLE_MEMBER','ROLE_ADMIN','ROLE_MANAGER','ROLE_EXPERT','ROLE_COMMISSIONER')")
		        .antMatchers("/admin/**").access("hasAnyRole('ROLE_SUPER_ADMIN','ROLE_ADMIN','ROLE_MANAGER')")
		        .antMatchers("/adminHome/**").access("hasAnyRole('ROLE_SUPER_ADMIN','ROLE_ADMIN','ROLE_MANAGER')");
			
			http.antMatcher("**").authorizeRequests()
					.antMatchers("/", "/verifyEmail", "/signUp", "/error", "/logoutJson", "/user/**", "/userHome/**").permitAll().anyRequest()
					.authenticated();
	    }
	}


}
