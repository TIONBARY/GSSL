package com.drdoc.BackEnd.api.util;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.security.core.userdetails.UserDetails;

public class SecurityUtil {

    private static final Logger logger = LoggerFactory.getLogger(SecurityUtil.class);

    private SecurityUtil() {
    }

    //Security Context의 Authentication 객체를 이용해 id을 리턴해주는 유틸성 메소드
    public static String getCurrentUsername() {
        //SecurityContext에 Authentication객체가 저장되는 시점은 JwtFilter의 doFilter메소드에서 Request가 들어올 때
        //SecurityContext에 Authentication 객체를 저장해서 사용
        final Authentication authentication = SecurityContextHolder.getContext().getAuthentication();

        if (authentication == null) {
            throw  new RuntimeException("Security Context 에 인증 정보가 없습니다.");
        }

        String username = "";
        if (authentication.getPrincipal() instanceof UserDetails) {
            UserDetails springSecurityUser = (UserDetails) authentication.getPrincipal();
            username = springSecurityUser.getUsername();
        } else if (authentication.getPrincipal() instanceof String) {
            username = (String)authentication.getPrincipal();
        }

        return username;
    }
}