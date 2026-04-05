package com.plataforma.combustible.entity;

import jakarta.persistence.*;
import lombok.Data;
import java.time.LocalDateTime;
import java.util.List;

@Entity
@Table(name = "estaciones")
@Data
public class Estacion {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;
    
    @Column(nullable = false)
    private String nombre;
    
    @Column(unique = true, nullable = false)
    private String nit;
    
    private String ubicacion;
    
    private String telefono;
    
    private String horario;
    
    private Double latitud;
    
    private Double longitud;
    
    private boolean activa;
    
    private LocalDateTime fechaRegistro;
    
    @OneToMany(mappedBy = "estacion")
    private List<PrecioCombustible> precios;
}