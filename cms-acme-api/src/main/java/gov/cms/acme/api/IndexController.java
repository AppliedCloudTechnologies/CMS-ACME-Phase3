package gov.cms.acme.api;

import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.responses.ApiResponse;
import lombok.extern.slf4j.Slf4j;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import java.util.Map;

@Slf4j
@RestController
public class IndexController {


    @GetMapping("/info/status")
    @Operation(description = "To the status of service.")
    @ApiResponse(description = "status: up")
    public ResponseEntity<Map<String, String>> getHealth() {
        log.info("check status");
        return ResponseEntity.ok(Map.of("status", "UP"));
    }

}
