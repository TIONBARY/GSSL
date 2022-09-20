package com.drdoc.BackEnd.api.domain.dto;

import java.util.List;

import io.swagger.annotations.ApiModelProperty;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class WalkBatchDeleteRequestDto {

	@ApiModelProperty(name="walk_ids", example="[1, 2, 3]")
    private List<Integer> walk_ids;
}
