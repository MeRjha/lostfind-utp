/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package Objetos;

import java.sql.Date;

/**
 *
 * @author Ariana
 */
public class SolicitudReclamo {
    
    private int idSolicitud;
    private int idObjetoEncontrado;
    private int idObjeto;
    private int idUsuario;
    private Date fechaSolicitud;
    private String sustentoPropiedad;
    private String estado;
    private String motivoRechazo;

    // Datos del objeto
    private String nombreObjeto;
    private String categoria;
    private String imagen;

    // Datos del estudiante
    private String nombreEstudiante;
    private String apellidoEstudiante;
    private String correoInstitucional;
    private String sedeEstudiante;
    private String sedeObjeto;

    // Getters y setters
    public int getIdSolicitud() {
        return idSolicitud;
    }

    public void setIdSolicitud(int idSolicitud) {
        this.idSolicitud = idSolicitud;
    }

    public int getIdObjetoEncontrado() {
        return idObjetoEncontrado;
    }

    public void setIdObjetoEncontrado(int idObjetoEncontrado) {
        this.idObjetoEncontrado = idObjetoEncontrado;
    }

    public int getIdObjeto() {
        return idObjeto;
    }

    public void setIdObjeto(int idObjeto) {
        this.idObjeto = idObjeto;
    }

    public int getIdUsuario() {
        return idUsuario;
    }

    public void setIdUsuario(int idUsuario) {
        this.idUsuario = idUsuario;
    }

    public Date getFechaSolicitud() {
        return fechaSolicitud;
    }

    public void setFechaSolicitud(Date fechaSolicitud) {
        this.fechaSolicitud = fechaSolicitud;
    }

    public String getSustentoPropiedad() {
        return sustentoPropiedad;
    }

    public void setSustentoPropiedad(String sustentoPropiedad) {
        this.sustentoPropiedad = sustentoPropiedad;
    }

    public String getEstado() {
        return estado;
    }

    public void setEstado(String estado) {
        this.estado = estado;
    }

    public String getNombreObjeto() {
        return nombreObjeto;
    }

    public void setNombreObjeto(String nombreObjeto) {
        this.nombreObjeto = nombreObjeto;
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

    public String getNombreEstudiante() {
        return nombreEstudiante;
    }

    public void setNombreEstudiante(String nombreEstudiante) {
        this.nombreEstudiante = nombreEstudiante;
    }

    public String getApellidoEstudiante() {
        return apellidoEstudiante;
    }

    public void setApellidoEstudiante(String apellidoEstudiante) {
        this.apellidoEstudiante = apellidoEstudiante;
    }

    public String getCorreoInstitucional() {
        return correoInstitucional;
    }

    public void setCorreoInstitucional(String correoInstitucional) {
        this.correoInstitucional = correoInstitucional;
    }

    public String getSedeEstudiante() {
        return sedeEstudiante;
    }

    public void setSedeEstudiante(String sedeEstudiante) {
        this.sedeEstudiante = sedeEstudiante;
    }

    public String getSedeObjeto() {
        return sedeObjeto;
    }

    public void setSedeObjeto(String sedeObjeto) {
        this.sedeObjeto = sedeObjeto;
    }
    public String getMotivoRechazo() {
    return motivoRechazo;
    }

    public void setMotivoRechazo(String motivoRechazo) {
        this.motivoRechazo = motivoRechazo;
    }
}
