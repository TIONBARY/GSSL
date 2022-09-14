package com.drdoc.BackEnd.api.domain.dto;

import lombok.*;

@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class RefreshTokenDto {
    private String refreshToken;
}