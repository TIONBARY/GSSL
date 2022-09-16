package com.drdoc.BackEnd.api.controller;

import javax.validation.Valid;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.validation.Errors;
import org.springframework.web.bind.annotation.CrossOrigin;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestPart;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.multipart.MultipartFile;

import com.drdoc.BackEnd.api.domain.dto.BaseResponseDto;
import com.drdoc.BackEnd.api.domain.dto.RefreshTokenDto;
import com.drdoc.BackEnd.api.domain.dto.TokenDto;
import com.drdoc.BackEnd.api.domain.dto.UserInfoResponseDto;
import com.drdoc.BackEnd.api.domain.dto.UserLoginRequestDto;
import com.drdoc.BackEnd.api.domain.dto.UserLoginResponseDto;
import com.drdoc.BackEnd.api.domain.dto.UserLogoutRequestDto;
import com.drdoc.BackEnd.api.domain.dto.UserRegisterRequestDto;
import com.drdoc.BackEnd.api.repository.UserRepository;
import com.drdoc.BackEnd.api.service.S3Service;
import com.drdoc.BackEnd.api.service.UserService;
import com.drdoc.BackEnd.api.util.SecurityUtil;

import io.swagger.annotations.Api;
import io.swagger.annotations.ApiOperation;
import io.swagger.annotations.ApiResponse;
import io.swagger.annotations.ApiResponses;
import springfox.documentation.annotations.ApiIgnore;

@Api(value = "유저 API", tags = { "User 관리" })
@RestController
@CrossOrigin("*")
@RequestMapping("/api/user")
public class UserController {

	@Autowired
	private S3Service s3Service;

	@Autowired
	private UserService userService;

	@ApiOperation(value = "회원가입", notes = "유저 정보 삽입")
	@PostMapping("/public/signup")
	@ApiResponses({ @ApiResponse(code = 200, message = "성공"), @ApiResponse(code = 400, message = "부적절한 요청"),
			@ApiResponse(code = 500, message = "서버 오류") })
	public ResponseEntity<BaseResponseDto> register(
			@RequestPart(value = "user") @Valid UserRegisterRequestDto requestDto,
			@RequestPart("file") MultipartFile file) {
		try {
			if (file != null) {
				if (file.getSize() >= 10485760) {
					return ResponseEntity.status(400).body(BaseResponseDto.of(400, "이미지 크기 제한은 10MB 입니다."));
				}
				String originFile = file.getOriginalFilename();
				String originFileExtension = originFile.substring(originFile.lastIndexOf("."));
				if (!originFileExtension.equalsIgnoreCase(".jpg") && !originFileExtension.equalsIgnoreCase(".png")
						&& !originFileExtension.equalsIgnoreCase(".jpeg")) {
					return ResponseEntity.status(400).body(BaseResponseDto.of(400, "jpg, jpeg, png의 이미지 파일만 업로드해주세요"));
				}
				String imgPath = s3Service.upload("", file);
				requestDto.setProfile_pic(imgPath);
			}
		} catch (Exception e) {
			e.printStackTrace();
			return ResponseEntity.status(400).body(BaseResponseDto.of(400, "파일 업로드에 실패했습니다."));
		}
		userService.register(requestDto);
		return ResponseEntity.status(201).body(BaseResponseDto.of(201, "Created"));
	}

	@ApiOperation(value = "아이디 중복체크", notes = "memberId 중복체크")
	@GetMapping("/public/id/{id}")
	@ApiResponses({ @ApiResponse(code = 200, message = "사용가능한 아이디입니다."),
			@ApiResponse(code = 400, message = "중복된 아이디입니다."), @ApiResponse(code = 500, message = "서버 오류") })
	public ResponseEntity<BaseResponseDto> checkMemberId(@PathVariable("id") String memberId) {
		if (userService.checkMemberId(memberId)) {
			return ResponseEntity.status(200).body(BaseResponseDto.of(200, "사용가능한 아이디입니다."));
		}
		return ResponseEntity.status(400).body(BaseResponseDto.of(400, "중복된 아이디입니다."));
	}

	@ApiOperation(value = "닉네임 중복체크", notes = "nickname 중복체크")
	@GetMapping("/public/nickname/{nickname}")
	@ApiResponses({ @ApiResponse(code = 200, message = "사용가능한 닉네임입니다."),
			@ApiResponse(code = 400, message = "중복된 닉네임입니다."), @ApiResponse(code = 500, message = "서버 오류") })
	public ResponseEntity<BaseResponseDto> checkNickname(@PathVariable("nickname") String nickname) {
		if (userService.checkNickname(nickname)) {
			return ResponseEntity.status(200).body(BaseResponseDto.of(200, "사용가능한 닉네임입니다."));
		}
		return ResponseEntity.status(400).body(BaseResponseDto.of(400, "중복된 닉네임입니다."));
	}

	@ApiOperation(value = "로그인", notes = "memberId와 password를 사용해 로그인")
	@PostMapping("/public/login")
	@ApiResponses({ @ApiResponse(code = 200, message = "로그인 성공"),
			@ApiResponse(code = 400, message = "회원정보가 일치하지 않습니다."), @ApiResponse(code = 500, message = "서버 오류") })
	public ResponseEntity<BaseResponseDto> login(@RequestBody UserLoginRequestDto userLoginRequestDto) {
		TokenDto tokenDto = userService.login(userLoginRequestDto);
		return ResponseEntity.status(200).body(UserLoginResponseDto.of(200, "로그인 성공", tokenDto));
	}

	@ApiOperation(value = "Access 토큰 재발급", notes = "JWT Refresh 토큰을 사용해 재발급")
	@PostMapping("/auth/reissue")
	@ApiResponses({ @ApiResponse(code = 200, message = "재발급 성공"), @ApiResponse(code = 400, message = "정보가 일치하지 않습니다."),
			@ApiResponse(code = 500, message = "서버 오류") })
	public ResponseEntity<BaseResponseDto> reissue(@RequestBody RefreshTokenDto tokenRequestDto) {
		TokenDto tokenDto = userService.reissue(tokenRequestDto);
		return ResponseEntity.status(200).body(UserLoginResponseDto.of(200, "재발급 성공", tokenDto));
	}

	@ApiOperation(value = "로그아웃", notes = "현재 사용중인 Refresh Token을 DB에서 삭제")
	@PostMapping("/auth/logout")
	@ApiResponses({ @ApiResponse(code = 200, message = "로그아웃 성공"),
			@ApiResponse(code = 400, message = "회원정보가 일치하지 않습니다."), @ApiResponse(code = 500, message = "서버 오류") })
	public ResponseEntity<BaseResponseDto> logout(@RequestBody UserLogoutRequestDto userLogoutRequestDto) {
		userService.logout(userLogoutRequestDto.getRefresh_token());
		return ResponseEntity.status(200).body(BaseResponseDto.of(200, "로그아웃 성공"));
	}
	
	@ApiOperation(value = "회원정보 조회", notes = "회원 아이디를 이용해 회원정보를 조회합니다.")
	@GetMapping
	@ApiResponses({ @ApiResponse(code = 200, message = "회원정보를 성공적으로 불러왔습니다."),
			@ApiResponse(code = 400, message = "가입하지 않거나 탈퇴한 회원입니다."), 
			@ApiResponse(code = 401, message = "인증이 만료되어 로그인이 필요합니다."), @ApiResponse(code = 500, message = "서버 오류") })
	public ResponseEntity<BaseResponseDto> getUserDetail() {
		String memberId = SecurityUtil.getCurrentUsername();
		return ResponseEntity.status(200).body(UserInfoResponseDto.of(200, "Success", userService.getUserDetail(memberId)));
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

//    @PostMapping("/modify")
//    @ApiOperation(value = "학생 정보 수정", notes = "학생정보 수정")
//    @PreAuthorize("hasRole('STUDENT')")
//    public ResponseEntity<String> modify(@RequestPart(value = "student") StudentRequest student, @RequestPart(value = "file", required = false) MultipartFile file) throws IOException {
//        try {
//            if(file!=null) {
//                if (file.getSize() >= 10485760) {
//                    return new ResponseEntity<String>("이미지 크기 제한은 10MB 입니다.", HttpStatus.FORBIDDEN);
//                }
//                String originFile = file.getOriginalFilename();
//                String originFileExtension = originFile.substring(originFile.lastIndexOf("."));
//                if (!originFileExtension.equalsIgnoreCase(".jpg") && !originFileExtension.equalsIgnoreCase(".png")
//                        && !originFileExtension.equalsIgnoreCase(".jpeg")) {
//                    return new ResponseEntity<String>("jpg, jpeg, png의 이미지 파일만 업로드해주세요", HttpStatus.FORBIDDEN);
//                }
//                StudentEntity entity = repository.getOne(student.getStudentId());
//                String imgPath = s3Service.upload(entity.getProfile(), file);
//                student.setProfile(imgPath);
//                service.modify(student);
//            } else if(student.getProfile()!=null && student.getProfile().equals("reset")) {
//                StudentEntity entity = repository.getOne(student.getStudentId());
//                //이미지 있으면 s3 버킷에서 지움
//                s3Service.delete(entity.getProfile());
//
//                //이미지 컬럼 null로 변경
//                student.setProfile("null");
//                service.modify(student);
//            } else {
//                service.modify(student);
//            }
//            return new ResponseEntity<String>("학생 정보수정 성공.", HttpStatus.OK);
//        } catch (Exception e){
//            e.printStackTrace();
//            return new ResponseEntity<String>("학생 정보수정 실패", HttpStatus.FORBIDDEN);
//        }
//    }
}
