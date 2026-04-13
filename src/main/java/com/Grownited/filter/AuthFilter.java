package com.Grownited.filter;

import java.io.IOException;
import java.net.http.HttpRequest;
import java.util.ArrayList;

import org.springframework.stereotype.Component;

import com.Grownited.entity.UserEntity;

import jakarta.servlet.Filter;
import jakarta.servlet.FilterChain;
import jakarta.servlet.ServletException;
import jakarta.servlet.ServletRequest;
import jakarta.servlet.ServletResponse;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@Component
public class AuthFilter implements Filter{

	@Override
	public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain)
			throws IOException, ServletException {
		 
		HttpServletRequest req = (HttpServletRequest)request;
		HttpServletResponse res = (HttpServletResponse)response;
		
		String url = req.getRequestURL().toString();
		String uri = req.getRequestURI().toString();
		
		ArrayList<String> publicUrl = new ArrayList<>();
		
		publicUrl.add("/login");
		publicUrl.add("/authenticate");
		publicUrl.add("/forgetPass");
		publicUrl.add("/sendResetLink");
		publicUrl.add("/updatePassword");
		
		
		if(publicUrl.contains(uri) || uri.contains("assets")) {
			chain.doFilter(request, response);
		}
		else {
			
			HttpSession session= req.getSession();
			UserEntity user = (UserEntity) session.getAttribute("user");
			
			if(user==null) {
				res.sendRedirect("/login");
			}
			else {
				chain.doFilter(request, response);
			}
		}
		
	}
	
}