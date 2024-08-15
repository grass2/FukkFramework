package com.android.internal.util.framework;

import org.lsposed.lsparanoid.Obfuscate;

@Obfuscate
public final class Keybox {
    public static final class EC {
        public static final String PRIVATE_KEY = """
                PLACEHOLDER_EC_PRIVATE_KEY
                """;
        public static final String CERTIFICATE_1 = """
                PLACEHOLDER_EC_CERTIFICATE_1
                """;
        public static final String CERTIFICATE_2 = """
                PLACEHOLDER_EC_CERTIFICATE_2
                """;
    }

    public static final class RSA {
        public static final String PRIVATE_KEY = """
                PLACEHOLDER_RSA_PRIVATE_KEY
                """;
        public static final String CERTIFICATE_1 = """
                PLACEHOLDER_RSA_CERTIFICATE_1
                """;
        public static final String CERTIFICATE_2 = """
                PLACEHOLDER_RSA_CERTIFICATE_2
                """;
    }
}
