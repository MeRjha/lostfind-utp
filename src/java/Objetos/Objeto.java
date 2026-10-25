/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package Objetos;

import java.util.Date;

/**
 *
 * @author Axel
 */
public abstract class Objeto {

    private int idObjeto;
    private String categoria;
    private String imagen;
    private String nombre;
    private String color;
    private String marca;
    private String descripcion;
    private String lugarReferencia;
    private Date fechaRegistro;
    private String estado;

    public Objeto(int idObjeto, String categoria, String imagen, String nombre, String color, String marca, String descripcion, String lugarReferencia, Date fechaRegistro, String estado) {
        this.idObjeto = idObjeto;
        this.categoria = categoria;
        this.imagen = imagen;
        this.nombre = nombre;
        this.color = color;
        this.marca = marca;
        this.descripcion = descripcion;
        this.lugarReferencia = lugarReferencia;
        this.fechaRegistro = fechaRegistro;
        this.estado = estado;
    }

    public int getIdObjeto() {
        return idObjeto;
    }

    public void setIdObjeto(int idObjeto) {
        this.idObjeto = idObjeto;
    }

    public String getCategoria() {
        return categoria;
    }

    public void setCategoria(String categoria) {
        this.categoria = categoria;
    }

    public String getImagen() {
        return imagen;
    }

    public void setImagen(String imagen) {
        this.imagen = imagen;
    }

    public String getNombre() {
        return nombre;
    }

    public void setNombre(String nombre) {
        this.nombre = nombre;
    }

    public String getColor() {
        return color;
    }

    public void setColor(String color) {
        this.color = color;
    }

    public String getMarca() {
        return marca;
    }

    public void setMarca(String marca) {
        this.marca = marca;
    }

    public String getDescripcion() {
        return descripcion;
    }

    public void setDescripcion(String descripcion) {
        this.descripcion = descripcion;
    }

    public String getLugarReferencia() {
        return lugarReferencia;
    }

    public void setLugarReferencia(String lugarReferencia) {
        this.lugarReferencia = lugarReferencia;
    }

    public Date getFechaRegistro() {
        return fechaRegistro;
    }

    public void setFechaRegistro(Date fechaRegistro) {
        this.fechaRegistro = fechaRegistro;
    }

    public String getEstado() {
        return estado;
    }

    public void setEstado(String estado) {
        this.estado = estado;
    }

}
