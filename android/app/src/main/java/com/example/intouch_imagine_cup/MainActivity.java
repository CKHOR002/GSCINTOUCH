package com.example.intouch_imagine_cup;

import androidx.annotation.NonNull;
import io.flutter.embedding.android.FlutterActivity;
import io.flutter.embedding.engine.FlutterEngine;
import io.flutter.plugin.common.MethodChannel;

/* Imports for access token*/
import java.time.Instant;
import java.util.Date;
import java.util.HashMap;
import java.util.Map;
import java.util.UUID;
import io.jsonwebtoken.Jwts;
import io.jsonwebtoken.SignatureAlgorithm;


public class MainActivity extends FlutterActivity {
    private static final String CHANNEL = "com.example.intouch_imagine_cup/100ms_token";

    @Override
    public void configureFlutterEngine(@NonNull FlutterEngine flutterEngine) {

        super.configureFlutterEngine(flutterEngine);
        new MethodChannel(flutterEngine.getDartExecutor().getBinaryMessenger(), CHANNEL).setMethodCallHandler(
                (call, result) -> {
                    if (call.method.equals("generateAccessToken")) {

                        String accessToken = generateManagementToken();

                        result.success(accessToken);
                    }
                }
        );
    }

    private String generateManagementToken() { 
        String app_access=BuildConfig.APPACCESSKEY;
        String app_secret=BuildConfig.APPSECRET;
        Map<String, Object> payload = new HashMap<>();
        payload.put("access_key", app_access);
        payload.put("type", "management");
        payload.put("version", 2);
        String token = Jwts.builder().setClaims(payload).setId(UUID.randomUUID().toString())
                .setExpiration(new Date(System.currentTimeMillis() + 86400 * 1000))
                .setIssuedAt(Date.from(Instant.ofEpochMilli(System.currentTimeMillis() - 60000)))
                .setNotBefore(new Date(System.currentTimeMillis()))
                .signWith(SignatureAlgorithm.HS256, app_secret.getBytes()).compact();
        return token;
    }

}