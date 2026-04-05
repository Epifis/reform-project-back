package com.plataforma.combustible.dto.request;

import jakarta.validation.constraints.NotNull;
import jakarta.validation.constraints.Positive;
import lombok.Data;
import java.time.LocalDate;

@Data
public class PrecioRequest {
    @NotNull(message = "El ID de la estación es obligatorio")
    private Long estacionId;
    
    @NotNull(message = "El ID del combustible es obligatorio")
    private Long combustibleId;
    
    @NotNull(message = "El precio es obligatorio")
    @Positive(message = "El precio debe ser positivo")
    private Double precio;
    
    private LocalDate fecha;
}