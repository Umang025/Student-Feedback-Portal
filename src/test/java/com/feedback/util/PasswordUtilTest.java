package com.feedback.util;

import org.junit.jupiter.api.Test;

import static org.junit.jupiter.api.Assertions.*;

public class PasswordUtilTest {

    @Test
    public void testHashPasswordGeneratesCorrectSha256() {
        // Known SHA-256 for 'admin123'
        String expectedHash = "240be518fabd2724ddb6f04eeb1da5967448d7e831c08c8fa822809f74c720a9";
        String actualHash = PasswordUtil.hashPassword("admin123");

        assertEquals(expectedHash, actualHash);
    }

    @Test
    public void testVerifyPassword() {
        String hash = PasswordUtil.hashPassword("secretPass@2026");

        assertTrue(PasswordUtil.verifyPassword("secretPass@2026", hash));
        assertFalse(PasswordUtil.verifyPassword("wrongPassword", hash));
        assertFalse(PasswordUtil.verifyPassword(null, hash));
        assertFalse(PasswordUtil.verifyPassword("secretPass@2026", null));
    }
}
