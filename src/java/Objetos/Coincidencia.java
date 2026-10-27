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
public class Coincidencia {

    private int idCoincidencia;
    private ObjetoPerdido objetoPerdido;
    private ObjetoEncontrado objetoEncontrado;
    private double porcentajeSimilitud;
    private Date fechaGeneracion;

    public Coincidencia( ObjetoPerdido objetoPerdido, ObjetoEncontrado objetoEncontrado, double porcentajeSimilitud, Date fechaGeneracion) {
        this.objetoPerdido = objetoPerdido;
        this.objetoEncontrado = objetoEncontrado;
        this.porcentajeSimilitud = porcentajeSimilitud;
        this.fechaGeneracion = fechaGeneracion;
    }
    public Coincidencia( ObjetoPerdido objetoPerdido, ObjetoEncontrado objetoEncontrado, double porcentajeSimilitud) {
        this.objetoPerdido = objetoPerdido;
        this.objetoEncontrado = objetoEncontrado;
        this.porcentajeSimilitud = porcentajeSimilitud;
    }

    public int getIdCoincidencia() {
        return idCoincidencia;
    }

    public void setIdCoincidencia(int idCoincidencia) {
        this.idCoincidencia = idCoincidencia;
    }

    public ObjetoPerdido getObjetoPerdido() {
        return objetoPerdido;
    }

    public void setObjetoPerdido(ObjetoPerdido objetoPerdido) {
        this.objetoPerdido = objetoPerdido;
    }

    public ObjetoEncontrado getObjetoEncontrado() {
        return objetoEncontrado;
    }

    public void setObjetoEncontrado(ObjetoEncontrado objetoEncontrado) {
        this.objetoEncontrado = objetoEncontrado;
    }

    public double getPorcentajeSimilitud() {
        return porcentajeSimilitud;
    }

    public void setPorcentajeSimilitud(double porcentajeSimilitud) {
        this.porcentajeSimilitud = porcentajeSimilitud;
    }

    public Date getFechaGeneracion() {
        return fechaGeneracion;
    }

    public void setFechaGeneracion(Date fechaGeneracion) {
        this.fechaGeneracion = fechaGeneracion;
    }

}
