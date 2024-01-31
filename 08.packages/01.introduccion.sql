/***************************************************************************************************
Paquetes en PL/SQL
****************************************************************************************************
Podríamos entender a un paquete como una especie de "librería", es decir, dentro de 
un paquete PL/SQL podemos almacenar otros objetos como: procedimientos almacenados, 
funciones, cursores, variables, etc.

El paquete PL/SQL está formado por dos partes:

1. Spec (Specification Package)
   Es como si fuera el header. En este apartado declaramos todas las 
   variables públicas y procedimientos públicos que vamos a hacer. Aquí no hay
   código, sino más bien, solo declaraciones.
   
2. Body
   Podemos tener otras variables, en este caso, variables privadas, además tendremos
   código de los objetos que hayamos declarado en el Spec. Todo lo que declaremos
   en la zona del Spect lo vamos a tener que programar en el Body, por ejemplo,
   si en el Spec definimos un SP, ese SP debe ser programado en el Body.
   
Importante

- El Spec es obligatorio.
- El Body es  opcional.
*/
