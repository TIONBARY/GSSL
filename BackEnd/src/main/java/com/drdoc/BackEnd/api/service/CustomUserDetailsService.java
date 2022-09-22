package com.drdoc.BackEnd.api.service;

import java.util.ArrayList;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.core.GrantedAuthority;
import org.springframework.security.core.authority.SimpleGrantedAuthority;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.security.core.userdetails.UserDetailsService;
import org.springframework.security.core.userdetails.UsernameNotFoundException;
import org.springframework.stereotype.Component;
import org.springframework.transaction.annotation.Transactional;

import com.drdoc.BackEnd.api.domain.User;
import com.drdoc.BackEnd.api.repository.UserRepository;

@Component("userDetailsService")
public class CustomUserDetailsService implements UserDetailsService {
    @Autowired
    UserRepository userRepository;

    //로그인 시, DB에서 유저정보와 권한정보 가져옴, 해당 정보를 기반으로 userdetails.User 객체를 생성해서 리턴
    @Override
    @Transactional
    public UserDetails loadUserByUsername(final String memberId) {
            return userRepository.findByMemberId(memberId)
                    .map(user -> createUser(memberId, user))
                    .orElseThrow(() -> new UsernameNotFoundException(memberId + " -> DB에서 회원을 찾을 수 없습니다."));
    }


    private org.springframework.security.core.userdetails.User createUser(String id, User user) {
        if (user.isLeft()) {
            throw new RuntimeException(id + " -> 활성화되어 있지 않습니다.");
        }
        //DB 가져온 유저가 활성화 상태면
        System.out.println(id);
        System.out.println(user);
        List<GrantedAuthority> grantedAuthorities = new ArrayList<GrantedAuthority>();
        grantedAuthorities.add(new SimpleGrantedAuthority("ROLE_USER"));
        //유저 객체 리턴
       return new org.springframework.security.core.userdetails.User(user.getMemberId()+"",
    		   user.getPassword(),
                grantedAuthorities);
    }

}