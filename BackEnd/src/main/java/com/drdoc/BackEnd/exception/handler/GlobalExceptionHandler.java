package com.drdoc.BackEnd.exception.handler;

import java.util.List;
import java.util.stream.Collectors;

import org.springframework.dao.DataIntegrityViolationException;
import org.springframework.http.ResponseEntity;
import org.springframework.security.access.AccessDeniedException;
import org.springframework.security.authentication.BadCredentialsException;
import org.springframework.validation.FieldError;
import org.springframework.web.bind.MethodArgumentNotValidException;
import org.springframework.web.bind.annotation.ControllerAdvice;
import org.springframework.web.bind.annotation.ExceptionHandler;

import com.drdoc.BackEnd.api.domain.dto.BaseResponseDto;

import io.jsonwebtoken.JwtException;

@ControllerAdvice
public class GlobalExceptionHandler {

//	@ExceptionHandler(MatchingUserNotFoundException.class)
//    protected ResponseEntity<BaseResponseDto> handleMatchingUserNotFoundException(MatchingUserNotFoundException e) {
//        return ResponseEntity.status(404).body(BaseResponseDto.of(404, "User Not Exist In Matching"));
//    }

	@ExceptionHandler(IllegalArgumentException.class)
	protected ResponseEntity<BaseResponseDto> handleIllegalArgumentException(IllegalArgumentException e) {
		return ResponseEntity.status(400).body(BaseResponseDto.of(400, e.getMessage()));
	}

	@ExceptionHandler(BadCredentialsException.class)
	protected ResponseEntity<BaseResponseDto> handleTokenExpiredException(BadCredentialsException e) {
		return ResponseEntity.status(401).body(BaseResponseDto.of(401, "회원정보가 일치하지 않습니다."));
	}

	@ExceptionHandler(JwtException.class)
	protected ResponseEntity<BaseResponseDto> handleJwtException(JwtException e) {
		return ResponseEntity.status(401).body(BaseResponseDto.of(401, e.getMessage()));
	}

//	@ExceptionHandler(TokenExpiredException.class)
//    protected ResponseEntity<BaseResponseDto> handleTokenExpiredException(TokenExpiredException e) {
//        return ResponseEntity.status(401).body(BaseResponseDto.of(401, "Unauthorized"));
//    }
//	
//	@ExceptionHandler(BanNotFoundException.class)
//    protected ResponseEntity<BaseResponseDto> handleBanNotFoundException(BanNotFoundException e) {
//        return ResponseEntity.status(404).body(BaseResponseDto.of(404, "Ban Not Found"));
//    }
//	
//	@ExceptionHandler(BanDuplicationException.class)
//    protected ResponseEntity<BaseResponseDto> handleBanDuplicationException(BanDuplicationException e) {
//        return ResponseEntity.status(404).body(BaseResponseDto.of(400, "exist ban"));
//    }
//	
//	@ExceptionHandler(EmailConfirmNotFoundException.class)
//    protected ResponseEntity<BaseResponseDto> handleEmailConfirmNotFoundException(EmailConfirmNotFoundException e) {
//        return ResponseEntity.status(404).body(BaseResponseDto.of(404, "Code Not Sent"));
//    }
//	
//	@ExceptionHandler(EmailTimeoutException.class)
//    protected ResponseEntity<BaseResponseDto> handleEmailTimeoutException(EmailTimeoutException e) {
//        return ResponseEntity.status(408).body(BaseResponseDto.of(408, "Email Confirm Time Out"));
//    }
//	
//	@ExceptionHandler(InquiryNotFoundException.class)
//    protected ResponseEntity<BaseResponseDto> handleInquiryNotFoundException(InquiryNotFoundException e) {
//        return ResponseEntity.status(404).body(BaseResponseDto.of(404, "Inquiry Not Found"));
//    }
//	
//	@ExceptionHandler(LoginProhibitedException.class)
//    protected ResponseEntity<BaseResponseDto> handleLoginProhibitedException(LoginProhibitedException e) {
//        return ResponseEntity.status(403).body(BaseResponseDto.of(403, "Login Prohibited"));
//    }
//	
//	@ExceptionHandler(NoticeNotFoundException.class)
//    protected ResponseEntity<BaseResponseDto> handleNoticeNotFoundException(NoticeNotFoundException e) {
//        return ResponseEntity.status(404).body(BaseResponseDto.of(404, "Notice Not Found"));
//    }
//	
//	@ExceptionHandler(ReportNotFoundException.class)
//    protected ResponseEntity<BaseResponseDto> handleReportNotFoundException(ReportNotFoundException e) {
//        return ResponseEntity.status(404).body(BaseResponseDto.of(404, "Report Not Found"));
//    }
//	
//	@ExceptionHandler(UserNotFoundException.class)
//    protected ResponseEntity<BaseResponseDto> handleUserNotFoundException(UserNotFoundException e) {
//        return ResponseEntity.status(400).body(BaseResponseDto.of(404, "가입하지 않은 계정입니다."));
//    }
//	
//	@ExceptionHandler(WrongPasswordException.class)
//    protected ResponseEntity<BaseResponseDto> handleWrongPasswordException(WrongPasswordException e) {
//        return ResponseEntity.status(404).body(BaseResponseDto.of(404, "Wrong Password"));
//    }

	@ExceptionHandler(AccessDeniedException.class)
	protected ResponseEntity<BaseResponseDto> handleAccessDeniedException(AccessDeniedException e) {
		return ResponseEntity.status(403).body(BaseResponseDto.of(403, "권한이 없습니다."));
	}

	@ExceptionHandler(DataIntegrityViolationException.class)
	protected ResponseEntity<BaseResponseDto> handleDataIntegrityViolationException(DataIntegrityViolationException e) {
		System.err.println(e.getMessage());
		return ResponseEntity.status(400).body(BaseResponseDto.of(400, "잘못된 요청입니다."));
	}

	@ExceptionHandler(MethodArgumentNotValidException.class)
	protected ResponseEntity<BaseResponseDto> handleMethodArgumentNotValidException(MethodArgumentNotValidException e) {
		System.err.println(e.getMessage());
		List<FieldError> fieldErrors = e.getBindingResult().getFieldErrors();
		List<String> errorLogs = fieldErrors.stream().map((error) -> error.getDefaultMessage())
				.collect(Collectors.toList());
		String errorLog = errorLogs.stream().reduce("",
				(cur, error) -> new StringBuilder(cur).append(" ").append(error).toString());
		return ResponseEntity.status(400).body(BaseResponseDto.of(400, errorLog));
	}

}