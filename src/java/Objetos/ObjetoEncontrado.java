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
public class ObjetoEncontrado extends Objeto {

    private Date fechaHallazgo;

    public ObjetoEncontrado(Date fechaHallazgo, String categoria, String imagen, String nombre, String color, String marca, String descripcion, String lugarReferencia, String estado) {
        super(categoria, imagen, nombre, color, marca, descripcion, lugarReferencia, estado);
        this.fechaHallazgo = fechaHallazgo;
    }

    public Date getFechaHallazgo() {
        return fechaHallazgo;
    }

    public void setFechaHallazgo(Date fechaHallazgo) {
        this.fechaHallazgo = fechaHallazgo;
    }

}
