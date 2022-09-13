package com.drdoc.BackEnd.api.jwt;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.util.StringUtils;
import org.springframework.web.filter.GenericFilterBean;
import org.springframework.web.filter.OncePerRequestFilter;

import javax.servlet.FilterChain;
import javax.servlet.ServletException;
import javax.servlet.ServletRequest;
import javax.servlet.ServletResponse;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import java.io.IOException;

//JWT를 위한 커스텀 필터
public class JwtFilter extends OncePerRequestFilter {

    private static final Logger logger = LoggerFactory.getLogger(JwtFilter.class);

    public static final String AUTHORIZATION_HEADER = "Authorization";

    private TokenProvider tokenProvider;

    public JwtFilter(TokenProvider tokenProvider) {
        this.tokenProvider = tokenProvider;
    }


    /**
     * JWT 토큰의 인증정보를 현재 실행중인 SecurityContext 에 저장하는 역할
     * 메소드 내부에 실제 필터링 로직 작성
     * > 유효성 검증 (토큰 파싱시(잘못된,만료된,지원하지않는..) 유효한지,
     */
    @Override
    public void doFilterInternal(HttpServletRequest servletRequest, HttpServletResponse servletResponse, FilterChain filterChain)
            throws IOException, ServletException {
        System.out.println("---------------doFilter");
        HttpServletRequest httpServletRequest = (HttpServletRequest) servletRequest;
        String jwt = resolveToken(httpServletRequest);  //request에서 토큰 받기
        String requestURI = httpServletRequest.getRequestURI();

//        System.out.println(requestURI);
        if (requestURI.equals("/api/user/auth/reissue")) {
            logger.debug("token 재발급 중...");        	
        } else if (requestURI.equals("/api/user/auth/logout")) {
            logger.debug("로그아웃 중...");        	
        } else if (StringUtils.hasText(jwt) && tokenProvider.validateToken(jwt)) {         //유효성 검증 메서드 통과
            System.out.println("---------------Security Context에 저장함");
            Authentication authentication = tokenProvider.getAuthentication(jwt);   //정상 토큰이면 SecurityContext에 저장
            SecurityContextHolder.getContext().setAuthentication(authentication);
            logger.debug("Security Context에 '{}' 인증 정보를 저장했습니다, uri: {}", authentication.getName(), requestURI);
        } else {
            logger.debug("유효한 JWT 토큰이 없습니다, uri: {}", requestURI);
        }

        filterChain.doFilter(servletRequest, servletResponse);
    }

    //Request Header에서 토큰 정보를 꺼내오기 위한 메소드
    private String resolveToken(HttpServletRequest request) {
        String bearerToken = request.getHeader(AUTHORIZATION_HEADER);
        if (StringUtils.hasText(bearerToken) && bearerToken.startsWith("Bearer ")) {
            return bearerToken.substring(7);
        }
        return null;
    }


//	@Override
//	protected void doFilterInternal(HttpServletRequest request, HttpServletResponse response, FilterChain filterChain)
//			throws ServletException, IOException {
//		// TODO Auto-generated method stub
//		
//	}
}