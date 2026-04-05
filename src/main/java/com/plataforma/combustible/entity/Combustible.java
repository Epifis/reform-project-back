package com.plataforma.combustible.entity;

import jakarta.persistence.*;
import lombok.Data;

@Entity
@Table(name = "combustibles")
@Data
public class Combustible {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;
    
    @Column(nullable = false, unique = true)
    private String nombre;
    
    private String descripcion;
    
    private boolean activo;
    
    @ManyToOne
    @JoinColumn(name = "tipo_vehiculo_id")
    private TipoVehiculo tipoVehiculo;
}