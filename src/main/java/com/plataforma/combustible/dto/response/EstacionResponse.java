package com.plataforma.combustible.dto.response;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;
import java.time.LocalDateTime;

@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class EstacionResponse {
    private Long id;
    private String nombre;
    private String nit;
    private String ubicacion;
    private String telefono;
    private String horario;
    private Double latitud;
    private Double longitud;
    private boolean activa;
    private LocalDateTime fechaRegistro;
}