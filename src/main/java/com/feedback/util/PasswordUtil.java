package com.feedback.util;

import java.nio.charset.StandardCharsets;
import java.security.MessageDigest;
import java.security.NoSuchAlgorithmException;

/**
 * Utility for hashing and verifying passwords securely using SHA-256.
 * Beginner-friendly and standard without heavy external cryptographic libraries.
 */
public class PasswordUtil {

    private PasswordUtil() {
        // Prevent instantiation
    }

    /**
     * Hashes a plain-text password using SHA-256.
     *
     * @param plainText the plain password
     * @return 64-character lowercase hex string
     */
    public static String hashPassword(String plainText) {
        if (plainText == null) {
            throw new IllegalArgumentException("Password cannot be null");
        }
        try {
            MessageDigest digest = MessageDigest.getInstance("SHA-256");
            byte[] encodedhash = digest.digest(plainText.getBytes(StandardCharsets.UTF_8));
            StringBuilder hexString = new StringBuilder();
            for (byte b : encodedhash) {
                String hex = Integer.toHexString(0xff & b);
                if (hex.length() == 1) {
                    hexString.append('0');
                }
                hexString.append(hex);
            }
            return hexString.toString();
        } catch (NoSuchAlgorithmException e) {
            throw new RuntimeException("SHA-256 algorithm not available in current JVM", e);
        }
    }

    /**
     * Verifies if a given plain-text password matches an existing SHA-256 hash.
     *
     * @param plainText the candidate password
     * @param storedHash the stored 64-character hash
     * @return true if match, false otherwise
     */
    public static boolean verifyPassword(String plainText, String storedHash) {
        if (plainText == null || storedHash == null) {
            return false;
        }
        String calculated = hashPassword(plainText);
        return calculated.equalsIgnoreCase(storedHash);
    }
}
