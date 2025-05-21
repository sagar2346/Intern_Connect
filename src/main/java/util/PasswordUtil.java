package util;

import java.security.MessageDigest;
import java.security.NoSuchAlgorithmException;
import java.nio.charset.StandardCharsets;

public class PasswordUtil {
    
    /**
     * Hashes a password using SHA-256 algorithm
     * @param password The password to hash
     * @return The hashed password
     * @throws NoSuchAlgorithmException if the algorithm is not available
     */
    public static String hashPassword(String password) throws NoSuchAlgorithmException {
        MessageDigest digest = MessageDigest.getInstance("SHA-256");
        byte[] encodedHash = digest.digest(
                password.getBytes(StandardCharsets.UTF_8));
        
        return bytesToHex(encodedHash);
    }
    
    /**
     * Converts a byte array to a hexadecimal string
     * @param hash The byte array to convert
     * @return The hexadecimal string
     */
    private static String bytesToHex(byte[] hash) {
        StringBuilder hexString = new StringBuilder(2 * hash.length);
        for (byte b : hash) {
            String hex = Integer.toHexString(0xff & b);
            if (hex.length() == 1) {
                hexString.append('0');
            }
            hexString.append(hex);
        }
        return hexString.toString();
    }
}
