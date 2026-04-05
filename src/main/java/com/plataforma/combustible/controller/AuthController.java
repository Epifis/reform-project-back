package com.plataforma.combustible.controller;

import com.plataforma.combustible.dto.request.LoginRequest;
import com.plataforma.combustible.dto.request.RegisterRequest;
import com.plataforma.combustible.dto.response.LoginResponse;
import com.plataforma.combustible.dto.response.MensajeResponse;
import com.plataforma.combustible.service.AutenticacionService;
import jakarta.validation.Valid;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

@RestController
@RequestMapping("/api/auth")
public class AuthController {
    private final AutenticacionService autenticacionService;

    public AuthController(AutenticacionService autenticacionService) {
        this.autenticacionService = autenticacionService;
    }

    @PostMapping("/login")
    public ResponseEntity<LoginResponse> login(@Valid @RequestBody LoginRequest request) {
        return ResponseEntity.ok(autenticacionService.login(request));
    }

    @PostMapping("/register")
    public ResponseEntity<MensajeResponse> register(@Valid @RequestBody RegisterRequest request) {
        return ResponseEntity.ok(autenticacionService.register(request));
    }

    @PostMapping("/refresh-token")
    public ResponseEntity<LoginResponse> refreshToken(@RequestParam String refreshToken) {
        return ResponseEntity.ok(autenticacionService.refreshToken(refreshToken));
    }

    @GetMapping("/confirmar-cuenta")
    public ResponseEntity<MensajeResponse> confirmarCuenta(@RequestParam String token) {
        return ResponseEntity.ok(autenticacionService.confirmarCuenta(token));
    }
}