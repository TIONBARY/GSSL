package com.drdoc.BackEnd.config;

import java.awt.print.Pageable;
import java.util.Arrays;
import java.util.List;

import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;

import com.fasterxml.classmate.TypeResolver;

import io.swagger.annotations.ApiModel;
import io.swagger.annotations.ApiModelProperty;
import lombok.Getter;
import lombok.Setter;
import springfox.documentation.builders.ApiInfoBuilder;
import springfox.documentation.builders.PathSelectors;
import springfox.documentation.builders.RequestHandlerSelectors;
import springfox.documentation.schema.AlternateTypeRules;
import springfox.documentation.service.ApiInfo;
import springfox.documentation.service.ApiKey;
import springfox.documentation.service.AuthorizationScope;
import springfox.documentation.service.Contact;
import springfox.documentation.service.SecurityReference;
import springfox.documentation.spi.DocumentationType;
import springfox.documentation.spi.service.contexts.SecurityContext;
import springfox.documentation.spring.web.plugins.Docket;
import springfox.documentation.swagger2.annotations.EnableSwagger2;

//swagger address : http://localhost:8080/swagger-ui/#/
@Configuration
@EnableSwagger2
public class SwaggerConfig {
    TypeResolver typeResolver = new TypeResolver();
    @Bean
    public Docket swagger() {
        return new Docket(DocumentationType.SWAGGER_2)
                .alternateTypeRules(AlternateTypeRules.newRule(typeResolver.resolve(Pageable.class), typeResolver.resolve(Page.class)))
                .ignoredParameterTypes(java.sql.Date.class)
                .forCodeGeneration(true)
                .select()
                .apis(RequestHandlerSelectors.any())
                .paths(PathSelectors.any())
                .build()
                .apiInfo(apiInfo())
                .enable(true)
                .securityContexts(Arrays.asList(securityContext()))
                .securitySchemes(Arrays.asList(apiKey()));
    }

    @Getter @Setter
    @ApiModel
    static class Page {
        @ApiModelProperty(value = "????????? ??????(0..N)")
        private Integer page;

        @ApiModelProperty(value = "????????? ??????", allowableValues = "range[0,100]")
        private Integer size;

        @ApiModelProperty(value = "??????(????????? : ?????????,ASC|DESC)")
        private List<String> sort;
    }

    private ApiInfo apiInfo(){
        return new ApiInfoBuilder()
                .title("???????????? ????????? API ?????????")
                .description("???????????? ?????? ????????? API ???????????? ??? ?????????")
                .contact(new Contact("drdoc", "drdoc.com", "drdoc@gmail.com"))
                .version("1.0")
                .build();
    }

    private ApiKey apiKey() {
        return new ApiKey("JWT", "Authorization", "header");
    }

    private SecurityContext securityContext() {
        return springfox
                .documentation
                .spi.service
                .contexts
                .SecurityContext
                .builder()
                .securityReferences(defaultAuth()).forPaths(PathSelectors.any()).build();
    }

    List<SecurityReference> defaultAuth() {
        AuthorizationScope authorizationScope = new AuthorizationScope("global", "accessEverything");
        AuthorizationScope[] authorizationScopes = new AuthorizationScope[1];
        authorizationScopes[0] = authorizationScope;
        return Arrays.asList(new SecurityReference("JWT", authorizationScopes));
    }
}