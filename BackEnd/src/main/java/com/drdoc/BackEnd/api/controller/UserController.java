package com.drdoc.BackEnd.api.controller;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.web.bind.annotation.CrossOrigin;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import com.drdoc.BackEnd.api.domain.dto.BaseResponseDto;
import com.drdoc.BackEnd.api.domain.dto.UserRegisterRequestDto;
import com.drdoc.BackEnd.api.service.UserService;

import io.swagger.annotations.Api;
import io.swagger.annotations.ApiOperation;
import io.swagger.annotations.ApiResponse;
import io.swagger.annotations.ApiResponses;
import lombok.RequiredArgsConstructor;

@Api(value = "유저 API", tags={"User 관리"})
@RestController
@CrossOrigin("*")
@RequestMapping("/be/users")
@RequiredArgsConstructor
public class UserController {

    private final UserService userService;
    @Autowired
    PasswordEncoder passwordEncoder;

    @ApiOperation(value = "회원가입", notes = "유저 정보 삽입")
    @PostMapping
    @ApiResponses({
        @ApiResponse(code = 200, message = "성공"),
        @ApiResponse(code = 400, message = "부적절한 요청"),
        @ApiResponse(code = 500, message = "서버 오류")
    })
    public ResponseEntity<BaseResponseDto> register(@RequestBody UserRegisterRequestDto requestDto){
    		userService.register(requestDto);
		return ResponseEntity.status(200).body(BaseResponseDto.of(200, "Success"));    	
    }

//    @GetMapping("/email/{email}")
//    @ApiOperation(value = "이메일 중복 체크", notes = "중복 이메일인지 체크")
//    public ResponseEntity<String> hasEmail(@PathVariable String email){
//        Boolean isExists = studentService.hasEmail(email) || teacherService.hasEmail(email);
//        if(isExists){
//            return new ResponseEntity<String>("중복된 이메일입니다.", HttpStatus.FORBIDDEN);
//        } else{
//            return new ResponseEntity<String>("사용가능한 이메일입니다.", HttpStatus.OK);
//        }
//    }

//    @GetMapping("/info")
//    @PreAuthorize("hasRole('STUDENT')")
//    @ApiOperation(value = "유저 정보 제공!!!", notes = "")
//    public ResponseEntity<?> getUserInfo() {
//        String id = SecurityUtil.getCurrentUsername();
//        if(id == null) return new ResponseEntity<String>("로그인된 회원을 찾을 수 없습니다.", HttpStatus.NOT_FOUND);
//        if(id.length() == 10){
//            StudentEntity student = studentRepository.getOne(Integer.parseInt(id));
//            int rank = studentRepository.countByTotalPointGreaterThan(student.getTotalPoint())+1;
//            if(rankingRepository.findFirstByStudent(student)!=null) rank = rankingRepository.findFirstByStudent(student).getRankNum();
//            return ResponseEntity.ok(new StudentResponse(student, rank));
//        } else{
//            return ResponseEntity.ok(new TeacherResponse(teacherRepository.getOne(Integer.parseInt(id))));
//        }
//    }

//    @PostMapping("/myinfo")
//    @PreAuthorize("hasRole('STUDENT')")
//    @ApiOperation(value = "마이페이지 진입", notes = "마이페이지 진입을 위한 api")
//    public ResponseEntity<?> checkPassword(@RequestBody Map<String, String> map) {
//        String id = SecurityUtil.getCurrentUsername();
//        String password = map.get("password");
//        System.out.println(id+" "+password);
//        if(id == null) return new ResponseEntity<String>("로그인된 회원을 찾을 수 없습니다.", HttpStatus.NOT_FOUND);
//        if(id.length() == 10){
//            StudentEntity student = studentRepository.getOne(Integer.parseInt(id));
//            if(passwordEncoder.matches(password, student.getPassword()))
//                return new ResponseEntity<String>("비밀번호 동일", HttpStatus.OK);
//            else return new ResponseEntity<String>("비밀번호 틀림", HttpStatus.FORBIDDEN);
//        } else{
//            TeacherEntity teacher = teacherRepository.getOne(Integer.parseInt(id));
//            if(passwordEncoder.matches(password,teacher.getPassword()))
//                return new ResponseEntity<String>("비밀번호 동일", HttpStatus.OK);
//            else return new ResponseEntity<String>("비밀번호 틀림", HttpStatus.FORBIDDEN);
//        }
//    }
}
