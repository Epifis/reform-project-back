package com.plataforma.combustible.entity;

import jakarta.persistence.*;
import lombok.Data;
import java.time.LocalDate;

@Entity
@Table(name = "precios_combustible")
@Data
public class PrecioCombustible {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;
    
    @ManyToOne
    @JoinColumn(name = "estacion_id", nullable = false)
    private Estacion estacion;
    
    @ManyToOne
    @JoinColumn(name = "combustible_id", nullable = false)
    private Combustible combustible;
    
    @Column(nullable = false)
    private Double precio;
    
    @Column(nullable = false)
    private LocalDate fecha;
    
    private boolean precioRegulado;
}