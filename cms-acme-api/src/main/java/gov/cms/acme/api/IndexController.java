package gov.cms.acme.api;

import lombok.extern.slf4j.Slf4j;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import java.util.Map;

@Slf4j
@RestController
public class IndexController {

    @RequestMapping("/info/status")
    public ResponseEntity<Map<String, String>> getHealth() {
        log.info("check status");
        return ResponseEntity.ok(Map.of("status", "UP"));
    }

}
