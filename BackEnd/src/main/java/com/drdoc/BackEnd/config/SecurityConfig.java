package com.drdoc.BackEnd.config;

import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.security.config.annotation.method.configuration.EnableGlobalMethodSecurity;
import org.springframework.security.config.annotation.web.builders.HttpSecurity;
import org.springframework.security.config.annotation.web.builders.WebSecurity;
import org.springframework.security.config.annotation.web.configuration.EnableWebSecurity;
import org.springframework.security.config.annotation.web.configuration.WebSecurityConfigurerAdapter;
import org.springframework.security.config.http.SessionCreationPolicy;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.web.cors.CorsUtils;

import com.drdoc.BackEnd.api.jwt.JwtAccessDeniedHandler;
import com.drdoc.BackEnd.api.jwt.JwtAuthenticationEntryPoint;
import com.drdoc.BackEnd.api.jwt.JwtExceptionFilter;
import com.drdoc.BackEnd.api.jwt.JwtSecurityConfig;
import com.drdoc.BackEnd.api.jwt.TokenProvider;

import lombok.RequiredArgsConstructor;

@EnableWebSecurity      //기본적인 웹 보안 활성화
@EnableGlobalMethodSecurity(prePostEnabled = true)  //@PreAuthorize 어노테이션을 메소드단위로 추가하기 위해 적용
@Configuration
@RequiredArgsConstructor
public class SecurityConfig extends WebSecurityConfigurerAdapter { //추가적인 보안 설정
    private final TokenProvider tokenProvider;
    private final JwtAuthenticationEntryPoint jwtAuthenticationEntryPoint;
    private final JwtAccessDeniedHandler jwtAccessDeniedHandler;
    private final JwtExceptionFilter jwtExceptionFilter;
    
    //주입
//    public SecurityConfig(
//            TokenProvider tokenProvider,
//            JwtAuthenticationEntryPoint jwtAuthenticationEntryPoint,
//            JwtAccessDeniedHandler jwtAccessDeniedHandler
//    ) {
//        this.tokenProvider = tokenProvider;
////        this.corsFilter = corsFilter;
//        this.jwtAuthenticationEntryPoint = jwtAuthenticationEntryPoint;
//        this.jwtAccessDeniedHandler = jwtAccessDeniedHandler;
//    }

    //passwordEncoder 로는 BCryptPasswordEncoder 사용
    @Bean
    public PasswordEncoder passwordEncoder() {
        return new BCryptPasswordEncoder();
    }

    //antMatchers에 파라미터로 넘겨주는 endpoints는 Spring Security Filter Chain을 거치지 않기 때문에 '인증' , '인가' 서비스가 모두 적용되지 않는다.
    //HttpSecurity보다 우선적용
    //일반적으로 로그인 페이지, public 페이지 등 인증, 인가 서비스가 필요하지 않은 endpoint에 사용
    @Override
    public void configure(WebSecurity web) {
//        web.ignoring().antMatchers("/v2/api-docs", "/swagger-resources/**", "/swagger-ui.html", "/webjars/**", "/swagger/**");
        web.ignoring()
                .antMatchers(
                        "/h2-console/**",
                        "/favicon.ico",
                        "/error",
                        "/api/authenticate",
                        /* swagger v2 */
                        "/v2/api-docs",
                        "/swagger-resources",
                        "/swagger-resources/**",
                        "/configuration/ui",
                        "/configuration/security",
                        "/swagger-ui.html",
                        "/webjars/**",
                        /* swagger v3 */
                        "/v3/api-docs/**",
                        "/swagger-ui/**",
                        "/css/**",
                        "/fonts/**",
                        "/img/**",
                        "/js/**",
                        "/be/auth/**",
                        "/"
                );
    }

    //antMatchers에 있는 endpoint에 대한 '인증'을 무시한다.
    //Security Filter Chain에서 요청에 접근할 수 있기 때문에(요청이 security filter chain 거침) 인증, 인가 서비스와
    //Secure headers, CSRF protection 등 같은 Security Features 또한 사용된다.
    //취약점에 대한 보안이 필요할 경우 HttpSecurity 설정을 사용
    @Override
    protected void configure(HttpSecurity httpSecurity) throws Exception {
        httpSecurity
                // token을 사용하는 방식이기 때문에 csrf설정을 disable합니다.
                .csrf().disable()

                //Exception 핸들링 (직접 만든 클래스로)
                .exceptionHandling()
                .authenticationEntryPoint(jwtAuthenticationEntryPoint)
                .accessDeniedHandler(jwtAccessDeniedHandler)

                // enable h2-console 설정 추가
                .and()
                .headers()
                .frameOptions()
                .sameOrigin()

                // 세션을 사용하지 않기 때문에 STATELESS로 설정
                .and()
                .sessionManagement()
                .sessionCreationPolicy(SessionCreationPolicy.STATELESS)

                .and()
                .authorizeRequests() //HttpServletRequest를 사용하는 요청들에 대한 접근제한 설정하겠다
                .requestMatchers(CorsUtils::isPreFlightRequest).permitAll()
                .antMatchers( "/web-resources/**", "/actuator/**", "/api/user/public/**", "/api/user/auth/reissue", "/api/user/auth/logout").permitAll()//해당 api 요청은 인증없이 접근 허용하겠다는 의미
//                .antMatchers("/be/items/**").hasRole("STUDENT")
//                .antMatchers("/be/admin/**","/be/excel/**").hasRole("ADMIN")
                .anyRequest().authenticated() //나머지 요청들은 모두 인증되어야 한다

                //JWTFilter를 addFilterBefore로 등록했던 JwtSecurityConfig클래스도 적용
                .and()
                .apply(new JwtSecurityConfig(tokenProvider, jwtExceptionFilter));
    }
}
