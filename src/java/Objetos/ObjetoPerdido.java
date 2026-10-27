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
public class ObjetoPerdido extends Objeto {

    private Date fechaPerdida;

    public ObjetoPerdido(Date fechaPerdida, String categoria, String imagen, String nombre, String color, String marca, String descripcion, String lugarReferencia, String estado) {
        super(categoria, imagen, nombre, color, marca, descripcion, lugarReferencia, estado);
        this.fechaPerdida = fechaPerdida;
    } 

    public Date getFechaPerdida() {
        return fechaPerdida;
    }

    public void setFechaPerdida(Date fechaPerdida) {
        this.fechaPerdida = fechaPerdida;
    }

    

}
