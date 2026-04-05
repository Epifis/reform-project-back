package com.plataforma.combustible.entity;

import jakarta.persistence.*;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;
import java.math.BigDecimal;
import java.time.LocalDate;

@Entity
@Table(name = "normativa")
@Data
@NoArgsConstructor
@AllArgsConstructor
public class Normativa {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Column(nullable = false, length = 150)
    private String nombre;

    private String descripcion;

    @Column(name = "aplica_subsidio", nullable = false)
    private Boolean aplicaSubsidio = false;

    @Column(name = "porcentaje_ajuste", precision = 5, scale = 2)
    private BigDecimal porcentajeAjuste;

    @Column(name = "fecha_inicio", nullable = false)
    private LocalDate fechaInicio;

    @Column(name = "fecha_fin")
    private LocalDate fechaFin;

    @Column(nullable = false)
    private Boolean activa = true;
}