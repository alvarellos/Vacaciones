
/* ------------------------------------------------------ */
/* INTRODUCCION                                           */

/* Informacion general */

/**********************************************************/

/* Fundamentos de Inteligencia Artificial. */
/* Universidad de Educación a distancia UNED */

/* Autor: Diego Díaz Alvarellos */

/* Interprete :  SWI-Prolog */
/* Fichero    :  vacaciones-Diego-Diaz.pl */

/* Version    :  1.1 */
/* Fecha      :  Abril-2015 */

/**********************************************************/


/* Pantalla de Ayuda */

ayuda :- nl,

         write('*************************************************************************'),nl,
         write('Autor: | Fundamentos de Inteligencia Artificial UNED                     '),nl,
         write('                                                                         '),nl,
         tab(7),
         write('Planificador de vacaciones. Opciones                                     '),nl,
         write('                                                                         '),nl,
         tab(7),
         write('lista(todas).            |  Lista de lugares disponibles en la agencia   '),nl,
         tab(7),         
         write('lista("lugar").          |  Lista de actividades de un lugar             '),nl,
         tab(7),         
         write('disponibles(X).          |  Muestra los dias totales disponibles         '),nl,         
         tab(7),
         write('cambio("dias").          |  Modifica el valor de los dias disponibles    '),nl,        
         tab(7),
         write('viajes(X).               |  Lugares dependiendo del tiempo del cliente   '),nl,         
         tab(7),
         write('contratar("lugar").      |  Incluye un lugar en el planificador          '),nl,
         tab(7),         
         write('cancelar("lugar").       |  Saca del planificador un lugar               '),nl,
         tab(7), 
         write('vacaciones(X).           |  Imprime las vacaciones seleccionadas         '),nl,
         tab(7),                
         write('total(X).                |  Indica la cantidad que se tendria que pagar  '),nl,
         tab(7),                
         write('pagar(X,S).              |  Indica el precio a pagar                     '),nl,
         tab(7),
         write('clear.                   |  Limpia la pantalla                           '),nl,
         tab(7),
         write('ayuda.                   |  Muestra este MENU                            '),nl,
         write('                                                                         '),nl,
         write('*************************************************************************'),nl,
         nl.

/* ------------------------------------------------------ */
/* HECHOS                                                 */

/* Lugar, dias y precio para un viaje --> dias(destino, dias, precio) */

dias(bosque, 3, 50). 
dias(ciudad, 5, 200).
dias(desierto, 10, 500).
dias(lago, 2, 20).
dias(montania, 5, 300).
dias(oceano, 4, 200).
dias(playa, 10, 500).
dias(rio, 1, 15).
dias(sabana, 10, 600).
dias(volcan, 6, 700).
dias(X,34, 1000).

/* Listas de actividades --> actividades(lugar[lista]) */

actividades(todas, [bosque,ciudad,desierto,lago,montania,oceano,playa,rio,sabana,volcan]).
actividades(bosque, [setas,barbacoa,acampada]).
actividades(ciudad, [museos,edificios,parques]).
actividades(desierto, [dunas,oasis,camellos]).
actividades(lago, [navegar,pescar,nadar]).
actividades(montania, [eskiar,glaciares,escalada]).
actividades(oceano, [buceo,nadar,pescar]).
actividades(playa, [nadar,surf,palas]).
actividades(rio, [pescar,cascadas,rafting]).
actividades(sabana, [safari,fotos,acampada]).
actividades(volcan, [geiser,lava,fumarola]).

/* 3 datos cambian de forma dinamica en este programa durante su ejecucion: */
/* Los dias totales disponibles, los destinos que contrata el cliente y el precio total */

:- dynamic
disponibles/1.
disponibles(10).

:- dynamic
destino/1.

:- dynamic
total/1.
total(0).

/* ------------------------------------------------------ */
/* REGLAS                                                 */

/* Lista de actividades */

/* Verificar elemento en lista */
pertenece(E,L)     :- L=[E|_].
pertenece(E,[_|T]) :- pertenece(E,T).

/* Permite imprimir las actividades del lugar recorriendo la lista de uno en uno */
bosque(P)   :- actividades(bosque, L), pertenece(P,L).
ciudad(P)   :- actividades(ciudad, L), pertenece(P,L).
desierto(P) :- actividades(desierto, L), pertenece(P,L).
lago(P)     :- actividades(lago, L), pertenece(P,L).
montania(P) :- actividades(montania, L), pertenece(P,L).
oceano(P)   :- actividades(oceano, L), pertenece(P,L).
playa(P)    :- actividades(playa, L), pertenece(P,L).
rio(P)      :- actividades(rio, L), pertenece(P,L).
sabana(P)   :- actividades(sabana, L), pertenece(P,L).
volcan(P)   :- actividades(volcan, L), pertenece(P,L).

/* Imprime toda la lista seleccionada utilizando una función recursiva */
imprimeLista([]).
            imprimeLista([X|Y]) :- write(X),nl,imprimeLista(Y).
            listado(X,L) :- actividades(X,L), imprimeLista(L).
            lista(X) :- listado(X,L).

/* Se pueden incluir nuevas clasificaciones (aventura, familiares,...) */
/* para crear listas de forma variable sin tener que declararlas */ 

/* Actividades Aventura */
aventura(X) :- desierto(X); montania(X); rio(X); sabana(X); volcan(X).
aventura(X) :- write('No hay mas actividades de aventura').

/* Actividades Familiares */
familiares(X) :- bosque(X); ciudad(X); lago(X); oceano(X); playa(X).
familiares(X) :- write('No hay mas actividades familiares').

/* Cambio directo de los dias disponibles --> cambio("ahora") */
cambio(X) :- disponibles(Z),
             retract(disponibles(Z)), 
             assert(disponibles(X)).

/* Posibles lugares y dias dependiendo de los dias disponibles del cliente */
posibles(X,Y,P) :- disponibles(Z), dias(X,Y,P), Z>=Y, nl.

/* Contratar y cancelar */

contrata(X,Y,P,T,S) :- posibles(X,_,P),
                       assert(destino(X)),
                       dias(X,Z,P),
                       disponibles(Y),
                       T is Y-Z,
                       retract(disponibles(Y)), 
                       assert(disponibles(T)),
                       total(J),
                       S is J+P,
                       retract(total(J)),
                       assert(total(S)).

cancela(X,Y,P,T,S) :-  retract(destino(X)),
                       dias(X,Z,P),
                       disponibles(Y),
                       T is Y+Z,
                       retract(disponibles(Y)),
                       assert(disponibles(T)),
                       total(J),
                       S is J-P,
                       retract(total(J)),
                       assert(total(S)).

/* Simplificacion de las reglas */
viajes(X)     :- posibles(X,Y,P).
contratar(X)  :- contrata(X,Y,P,T,S).
cancelar(X)   :- cancela(X,Y,P,T,S).
vacaciones(X) :- destino(X).

/* Oferta del mes */
paquete(X) :- destino(montania), destino(lago), destino(bosque).

/* Se efectua el pago del cliente. Detecta si se ha contratado un paquete el cliente y se le ofrece un regalo */
pagar(X,S) :- paquete(X), !, write('Se le regala un vale para Spa por contrato de paquete. Total a pagar'), total(S).
pagar(X,S) :- write('El total a pagar es '), total(S).

/* Limpia la pantalla del interprete SWI-Prolog */
clear :-write('\033[2J').