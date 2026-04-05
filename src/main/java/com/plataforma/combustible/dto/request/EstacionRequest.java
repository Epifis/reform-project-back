package com.plataforma.combustible.dto.request;

import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.Pattern;
import lombok.Data;

@Data
public class EstacionRequest {
    @NotBlank(message = "El nombre es obligatorio")
    private String nombre;
    
    @NotBlank(message = "El NIT es obligatorio")
    @Pattern(regexp = "^[0-9]+$", message = "El NIT debe contener solo números")
    private String nit;
    
    private String ubicacion;
    
    private String telefono;
    
    private String horario;
    
    private Double latitud;
    
    private Double longitud;
}