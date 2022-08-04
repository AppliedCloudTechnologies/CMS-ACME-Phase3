package gov.cms.acme.utils;

import gov.cms.acme.constants.Constants;
import lombok.extern.slf4j.Slf4j;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.security.oauth2.jwt.Jwt;

import java.util.Collection;
import java.util.Map;
import java.util.Objects;

@Slf4j
public class SecurityUtil {

    /**
     * This use jwt token to get user claims
     * @return jwt_claims
     */
    public static Map<String, Object> getUserClaims() {
        Jwt principal = getJwtPrincipal();
        Map<String, Object> claims = principal.getClaims();
        log.debug("current user claims : {}", claims);
        return claims;
    }

    public static Jwt getJwtPrincipal() {
        Authentication authentication = SecurityContextHolder.getContext().getAuthentication();
        Jwt principal = (Jwt) authentication.getPrincipal();
        log.debug("user principal : {} ", principal);
        return principal;
    }

    /**
     * Get username from jwt token
     * @return username
     */
    public static String getUsername() {
        Jwt principal = getJwtPrincipal();
        String username = principal.getClaimAsString(Constants.CLAIM_USERNAME);
        return Objects.isNull(username) ? principal.getClaimAsString(Constants.CLAIM_COGNITO_USERNAME) : username;
    }

    /**
     * Get Current user groups
     * @return list for user groups
     */
    public static Collection<String> getUserGroup() {
        Jwt principal = getJwtPrincipal();
        return principal.getClaimAsStringList(Constants.CLAIM_COGNITO_GROUP);
    }


}
