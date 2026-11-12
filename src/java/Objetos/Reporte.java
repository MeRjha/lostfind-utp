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
public class Reporte {

    private int idReporte;
    private Usuario usuario;
    private ObjetoPerdido objetoPerdido;
    private Date fechaReporte;
    private String estado;

    public Reporte(int idReporte, Usuario usuario, ObjetoPerdido objetoPerdido, Date fechaReporte, String estado) {
        this.idReporte = idReporte;
        this.usuario = usuario;
        this.objetoPerdido = objetoPerdido;
        this.fechaReporte = fechaReporte;
        this.estado = estado;
    }

    public int getIdReporte() {
        return idReporte;
    }

    public void setIdReporte(int idReporte) {
        this.idReporte = idReporte;
    }

    public Usuario getUsuario() {
        return usuario;
    }

    public void setUsuario(Usuario usuario) {
        this.usuario = usuario;
    }

    public ObjetoPerdido getObjetoPerdido() {
        return objetoPerdido;
    }

    public void setObjetoPerdido(ObjetoPerdido objetoPerdido) {
        this.objetoPerdido = objetoPerdido;
    }

    public Date getFechaReporte() {
        return fechaReporte;
    }

    public void setFechaReporte(Date fechaReporte) {
        this.fechaReporte = fechaReporte;
    }

    public String getEstado() {
        return estado;
    }

    public void setEstado(String estado) {
        this.estado = estado;
    }

}
