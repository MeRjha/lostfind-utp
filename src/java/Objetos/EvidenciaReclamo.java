/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package Objetos;

import java.sql.Date;

/**
 *
 * @author Axel
 */
public class EvidenciaReclamo {
    
    private int idEvidencia;
    private int idSolicitud;
    private String urlArchivo;
    private Date fechaSubida;

    public int getIdEvidencia() {
        return idEvidencia;
    }
    public void setIdEvidencia(int idEvidencia) {
        this.idEvidencia = idEvidencia;
    }

    public int getIdSolicitud() {
        return idSolicitud;
    }

    public void setIdSolicitud(int idSolicitud) {
        this.idSolicitud = idSolicitud;
    }

    public String getUrlArchivo() {
        return urlArchivo;
    }

    public void setUrlArchivo(String urlArchivo) {
        this.urlArchivo = urlArchivo;
    }

    public Date getFechaSubida() {
        return fechaSubida;
    }

    public void setFechaSubida(Date fechaSubida) {
        this.fechaSubida = fechaSubida;
    }
}
