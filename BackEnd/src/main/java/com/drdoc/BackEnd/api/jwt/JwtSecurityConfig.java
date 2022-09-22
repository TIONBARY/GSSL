package com.drdoc.BackEnd.api.jwt;

import org.springframework.security.config.annotation.SecurityConfigurerAdapter;
import org.springframework.security.config.annotation.web.builders.HttpSecurity;
import org.springframework.security.web.DefaultSecurityFilterChain;
import org.springframework.security.web.authentication.UsernamePasswordAuthenticationFilter;

import lombok.RequiredArgsConstructor;
//TokenProvider, JwtFilter를 SecurityConfig에 적용할 때 사용할 클래스
//SecurityConfigurerAdapter를 extends하고

@RequiredArgsConstructor
public class JwtSecurityConfig extends SecurityConfigurerAdapter<DefaultSecurityFilterChain, HttpSecurity> {
    private final TokenProvider tokenProvider;
    private final JwtExceptionFilter jwtExceptionFilter;

//    //TokenProvider를 주입받음
//    public JwtSecurityConfig(TokenProvider tokenProvider) {
//        this.tokenProvider = tokenProvider;
//    }

    //TokenProvider를 주입받아서 JwtFilter를 통해 Security 로직에 필터를 등록
    @Override
    public void configure(HttpSecurity http) {
        JwtFilter customFilter = new JwtFilter(tokenProvider);
        http.addFilterBefore(customFilter, UsernamePasswordAuthenticationFilter.class);
        //Security로직에 JwtFilter를 등록
        http.addFilterBefore(jwtExceptionFilter, JwtFilter.class);
    }
}