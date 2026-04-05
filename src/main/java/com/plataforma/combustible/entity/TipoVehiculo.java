package com.plataforma.combustible.entity;

import jakarta.persistence.*;
import lombok.Data;

@Entity
@Table(name = "tipos_vehiculo")
@Data
public class TipoVehiculo {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Short id;
    
    @Column(nullable = false, unique = true)
    private String nombre;
    
    private String descripcion;
    
    private boolean activo;
    
    private Integer ordenDisplay;
    
    public boolean esTodos() {
        return "todos".equalsIgnoreCase(nombre);
    }
}