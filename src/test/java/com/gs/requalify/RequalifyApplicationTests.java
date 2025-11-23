package com.gs.requalify;

import org.junit.jupiter.api.Test;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.test.context.ActiveProfiles;

import static org.junit.jupiter.api.Assertions.assertTrue;
@SpringBootTest
@ActiveProfiles("test")
class RequalifyApplicationTests {

    @Test
    void contextLoads() {
        assertTrue(true, "Application context loaded successfully!");
    }
}
