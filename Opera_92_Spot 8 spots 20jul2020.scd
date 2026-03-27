// =====================================================================
//
//                                    ÓPERA
//
//                                  Versión 88
//                                     ADC
//
//                         Yurián Zerón y Ernesto Romero
//                                    México
//                                20 de julio 2020
//                              Era del Coronavirus
//
//
// =====================================================================


/*
------------------------------------------------------------------------

INICIO

1- Conectar el Ópera a la computadora
2- Ejecutar la aplicación: selecciona todo y declara (cmd + RETURN)
3- Activar la comunicación presionando el botón "Serial"


Notas:
Si en el menú de dispositivos seriales no está seleccionada la opción
correcta es necesario indicarla
Para detener todos los procesos cmd + . (cmd + punto)
Agregar la clase ServerMeterOpera.sc en el folder:
"/usr/share/SuperCollider/SCClassLibrary/Common/GUI/"
En MacOS instalar el driver PL2303 para reconocimiento del puerto serial-USB

------------------------------------------------------------------------
*/



// Usar aplha para el indicador del Teclado


// NO DETECTA EL FOLDER DE TRABAJO!








/*
Pendientes:

* Asignar nombre a la grabacion de sde el principio
* El loop no sirve en los canales 5 para arriba
* Slider de velocidad de reproduccion en los canales de entradas
* Entradas: Al cambiar la cantidad de canales conservar el modo y volumen de cada canal
* Las notas del teclado no corresponden con el sonido resultante.
* No funcionan los ruidos.
* La ventana Entradas debe poder relacionar cada canal con alguna muestra de audio(ya), video, led o relay.
* Slider de volumen en el teclado
* Poder seleccionar el rango de cuartos a ejecutar en el secuenciador del teclado
* Si se cierran las ventanas de Teclado, Salidas y Entradas desde la cruz superior derecha (o cmd+w) los botones se ponen negros en la ventana principal  hasta que esta queda al frente
* Establecer paths relativos para facilitar el escoger documentos en las ventanas de diálogos (ver código en  "/home/tito/Respaldo_2/Documents/Opera_SuperCollider/Varios/Dialog_relative_Path.scd")







// -------------------------------------------------------------------------
// Pendientes resueltos:

// Ventana principal
Se Agregó botón de Teatrino (como el del teclado. Van juntos en una paleta de menús)
Ya no hay que conectar el Opera a la computadora antes de ejecutar el código
(Cada vez que se abre el menu de dispositivos seriales se releen los
dispositivos disponibles)
Si el Opera está conectado el dispositivo serial se selecciona automáticamente (se selecciona por default la primera opción del menú)
Ya se pueden volver a abrir las ventanas de Teclado, Salidas y Entradas si
se habían cerrado desde la cruz superior derecha. Pero los botones en la ventana principal no se ponen negros.
Poner un foquito que parpadee mientras la coneccion serial esta activa
Falta un menu para seleccionar el puerto serial.
Poner una post window en el GUI
Poner los elementos de salidas en una ventana aparte y un boton que la abra.
Hacer una ventana aparte para control de entradas y un boton para abrirla.
Cuando se oprime el botón Serial para conectarse se imprime en la post
"Puerto Serial conectado" aunque no se haya conectado.


//  Entradas
Los canales de entradas se duplican los sonidos aveces y no se pueden detener
Cuando se expanden a 5 canales a veces manda error de concatenacion ++
Las amplitudes en los canales no se aplican en el loop
Cargar muestras mono y stereo
Poner un reproductor de la grabacion de la ventana de entradas (Cualquier canal lo es)
Hacer que cuando se cambie de 4 a 10 16 o 25 y de regreso se mantengan los audios que se cargaron en los canales y sus nombres
Boton de grabar que se ponga rojo cuando esta grabando y un cronometro del tiempo que llevas grabando

//  Salidas
Se muestra el nombre del documento de sets abierto
Botones de salvar y abrir sets
Hacer un Number Box con el valor de entrada del potenciometro
Hacer una entrada numerica para establecer un valor de referencia del potenciometro
Hacer un indicador cuando el valor del potenciometro sea igual al valor de referencia
Hacer un indicador cuando el valor del potenciometro sea menor al valor de referencia
Hacer un indicador cuando el valor del potenciometro sea mayor al valor de referencia

// Teclado
Poner letrero de velocidad bpm

// Esto no está claro qué es
Mostrar el nombre del archivo abierto en el secuenciador

Notas:

//  Resuelto
Problema:
No se accionan los botones de las Salidas cuando se usan los Sets ni el secuenciadoors
Solucion:
La velocidad de transmision del Opera no esta bien.  Es necesario meter en SuperCollider un wait de al menos 0.06 seg en el envio de datos simultaneos
Se comentaron unas lineas a partir de la linea 625. No originó problema pero no está claro si puede causar error después.
//

Fonts: "Wingdings 3", "DJ Icons", "Modern Pictograms", "Webdings", "Arial Black", "Courier", "Sjonarbok Classic", "Heydings Controls", "Eleganticons"


// ------------------------------------------------------------------------


*/


(
//var port="/dev/ttyUSB0";

// General

//var background = Color.new255(236,0,140); // #EA0098 Rosa Mexicano
//var background = Color.new255(177,44,122); // #EA0098 Rosa Mexicano
//var butColor= Color.white;
//var butColor= Color.new255(220,220,200);
//var butColor= Color.new255(142,187,7); // #F66EBE


/*
var background = Color.new255(185,46,86); // #EA0098 Rojo
var stringColor= Color.new255(220,220,200);
var butColor= Color.new255(185,46,86); // #EA0098 Rojo
*/

var background =Color.new255(105,16,66); // #EA0098 Rojo
var stringColor= Color.new255(220,220,200);
//var butColor= background; // #EA0098 Rojo
var butColor= Color.new255(105,16,66); // #EA0098 Rojo



//  Ventana Principal

var port=SerialPort.devices.reverse[0];
var ventanaPrincipal, principalView;
var x=20, y=115;
var xSec=40, ySec=190;
var textoOPE, textoRA;
var textoYurix;
var textoMR;
var textoInfo;
var serialPop, serialPopView;
var salidas, salidasView;
var entradas, entradasView;
var teclado, tecladoView;
var teatrino, teatrinoView;
var osc, oscView;
var dato;
var datoAnt;
var postGUI,botonClearPost;
var focoConexion, cuentaFoco=0;
var botonMeter;
var	oscOpera=NetAddr("0.0.0.0", 00000);
var logo;
var serialView;
var indBotones=90, indBotonesY=0;




//  Teclado

var ventanaTeclado;
var offSetX=10, offSetY;  // (10,50)
var indBotonesXTeclado;
var close;
var rangoCompases,rangoCompasesLo=0,rangoCompasesHi=63;
var botonStartNotas, botonPauseNotas, botonStopNotas, sliderTempoNotas, tempoTecladoNumber, tempoSecNotas=0.1;
var botonClose;
var botonRandomNotas, botonBorraNotas, botonGuardaNotas, botonCargaNotas;
var matrizGuardaNotas, matrizNotasRandom;
var dialogoCarga, dialogoSalva;
var arrayTeclado, negrasBlancas;
var arrayTecladoRuido;
var arrayNotas127, arrayRuidos255;
var compases, compases2;
var largoTecla=50, anchoTecla=20, teclasLargo, teclasAncho, negrasShift, rotaTecla= -7;
var lineasY, lineasX, colorLineas=0.75, matrizNotas, buttonSize=10, colorLineasRuido;
var arrayMatrizVal,arrayMatrizValMIDI;
var cutOff=1000;
var columnaResetTeclado=0;
var tecladoTextoInfo;





//  Ventana Salidas

var ventanaSalidas;
var botonCloseSalidas;
var textoSalidas;
var textoSets;
var textoBorrarSalidas;
var textoBorrarSets;
var dialogoSalvaSets, dialogoCargaSets, textSetsCargados;
var borrarOpOp;
var arrayButOpera=nil!5;
var asciiOpera=[75,63,62,64,61];
var charOpera=["K", "?", ">", "@", "="];
var arrayButOpereta=nil!8;
var asciiOpereta=[65,66,67,68,69,70,72,74];
var charOpereta=["A", "B", "C", "D", "E", "F", "H", "J"];
var arrayButConf=nil!10;
var waitButConf=0.009;  //  Lo mas rapido que ha funcionado es 0.003
var arrayButGrabConf=nil!10;
var conf0, conf1, conf2, conf3, conf4, conf5;
var conf6, conf7, conf8, conf9, conf10, conf11, conf12, conf13;
var conf;
var borrarConfs;
var sizeLetra=20;
var sizeBoton=30;
var serial;
var textoSecuenciador;
var butSecPlay,butSecPausa,butSecStop,numBoxTempo,numBoxTempoIn, textoBPM,sliderTempo,arrayButPas=nil!16,tempo=60;
var stoPause="stop";
var pasos=Array.fill(16,{Array.rand(13,0,1)});
var colorPasos;
var arrayButGrabPas=nil!16;
var dialogoSalvaSec, dialogoCargaSec, pasoSec;
var botonW, numeroADC, numeroRefADC, butIgualADC, butMayorADC, butMenorADC,textoNumeroADC,textoRefADC;
var oscResponderSalidas=nil!5;
var salidasX, salidasY, setsX, setsY, adcX, adcY, secX;
var graficaADC, userView, slider, numero, xADC=0, xAnt=90, numeroAnt=200;





//  Ventana Entradas

var ventanaEntradas;
var xIn=20, yIn=100;
var botonCloseEntradas;
var botonesN=4;
var botonesEntrada=nil!botonesN;
var inDialog=nil!botonesN;
var botonesModo=nil!botonesN;
var loop=0;
var bufs=nil!25;
var bufDefault;
var synths=nil!botonesN;
var inSlids=nil!botonesN;
var textSample=nil!botonesN;
var textSampleArray="vacio"!25;
var amps=0!botonesN;
var fEntradas=nil!botonesN, fEntradas0=nil!botonesN, fEntradas1=nil!botonesN, fEntradas2=nil!botonesN;
var contIn=0!botonesN;
var asciiIn=["y","u","r","o","l","m","n","t","p","q"];
var botonMatriz, ventanaMatriz;
var botonesEntradasY, botonesEntradasXModulo=13;
var botonEntradas4, botonEntradas10, botonEntradas16, botonEntradas25;
var botonGrabarEntradas;
var cronoGrabaEntradas, hrs="00", mins="00", segs="00";
var funcBotonesEntradas;
var oscResponderBotonesEntrada=nil!botonesN;
var menuEntradas;




//  Ventana Teatrino

var ventanaTeatrino;
var botonCloseTeatrino;
var xInTeatrino=70, yInTeatrino=115;
var servosTeatrino=2, ledsTeatrino=3;
var knobServosTeatrino=nil!servosTeatrino;
var textoServosTeatrino=nil!servosTeatrino;
var numeroServosTeatrino=nil!servosTeatrino;
var valorServosTeatrino=nil!servosTeatrino;
var botonLEDsTeatrino=nil!ledsTeatrino;
var textoLEDsTeatrino=nil!ledsTeatrino;
var cuadroServosTeatrino=nil!ledsTeatrino;
var teatrinoInfo;



//  Ventana OSC

var ventanaOSC;
var botonCloseOSC;
var xInOSC=160, yInOSC=25;
var textoRecepcionOSC;
var textoRecepcionIPOSC;
var textoRecepcionPuertoOSC;
var campoIPRecepcion;
var campoPuertoRecepcion;
var textoEnvioOSC;
var textoEnvioIPOSC;
var textoEnvioPuertoOSC;
var campoIPEnvio;
var campoPuertoEnvio;
var ipEnvio="0.0.0.0";
var puertoEnvio=0;


// Ventana SPOT

var ventanaSPOT;
var dSpots;
var offSetXSpot;
var offSetYSpot;
var spotSize;
var numeroSpot;
var cuadroLucesSPOT;
var d;
var botonesSpot, spotButSize;
var alargamiento;
var textSpot, textSpot2;
var spotsColor;
var fSpots;
var slider1, colorBoton1SPOT=Color(l,0,0,1);
var rango = 1.0;
var radioSPOT;
var calibracion;
var curva;
var proporcionX, proporcionY;






























//////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////

Window.closeAll;

s.boot.doWhenBooted({



	conf0=0!13;
	conf1=[1,1,1,1,1,0,0,0,0,0,0,0,0];
	conf2=[0,0,0,0,0,1,1,1,1,1,1,1,1];
	conf3=[1,0,1,0,1,0,1,0,1,0,1,0,1];
	conf4=[0,1,0,1,0,1,0,1,0,1,0,1,0];
	conf5=[1,1,1,0,0,0,0,0,0,0,0,0,0];
	conf6=[0,0,0,1,1,0,0,0,0,0,0,0,0];
	conf7=[0,0,0,0,0,1,1,1,1,0,0,0,0];
	conf8=[0,0,0,0,0,0,0,0,0,1,1,1,1];
	conf9=[1,1,1,0,0,1,1,1,1,0,0,0,0];
	conf10=[0,0,0,1,1,0,0,0,0,1,1,1,1];
	conf=[conf1,conf2,conf3,conf4,conf5,conf6,conf7,conf8,conf9,conf10];

	ventanaPrincipal=Window("OPERA", Rect(0,Window.screenBounds.height,(x*2)+(70*5)+57+indBotones,380)).front;
	ventanaPrincipal.acceptsMouseOver=true;
	ventanaPrincipal.view.background_(background);
	ventanaPrincipal.toFrontAction={|...msg|
		if(ventanaTeclado.visible,{},{teclado.valueAction=0});
		if(ventanaSalidas.visible,{},{salidas.valueAction=0});
		if(ventanaEntradas.visible,{},{entradas.valueAction=0});
	};
    principalView=View(ventanaPrincipal,Rect(0,0,(x*2)+(70*5)+57,470));
	principalView.mouseOverAction={|view,x,y| textoInfo.string="";};




///  LOGO

logo={|ventana|
	var array=[StaticText(ventana, Rect(x,0,300,60)).stringColor_(stringColor),              // OPE   [0]
		             StaticText(ventana, Rect(x+20,32,300,60)).stringColor_(stringColor),      // RA     [1]
		             StaticText(ventana, Rect(x+80,-15,100,60)).stringColor_(stringColor),    // Yurix  [2]
		             StaticText(ventana, Rect(x+115,-19,100,60)).stringColor_(stringColor)]; // MR     [3]



	// Opera Texto
	array[0].string="O P E";
	array[0].font=Font("Blackout Midnight",30);

	array[1].string="R A";
	array[1].font=Font("Blackout Midnight",30);

	// Yurix Texto
	array[2].string="Yurix";
	array[2].font=Font("Arial",15);

	// MR Texto
	array[3].string="MR";
	array[3].font=Font("Arial",5) ;

	// Circulo
	ventana.drawFunc = {
        Pen.color = Color.white;
	    Pen.addOval(Rect(0,-10,100,100));
        Pen.perform(\stroke);
	};

};


	logo.value(ventanaPrincipal);

	/////////////////////
	/////////////////////


	textoInfo=StaticText(ventanaPrincipal, Rect(x+(70*4)+indBotones, indBotonesY+(sizeBoton*0)+5, 120, 20)).stringColor_(stringColor);
	textoInfo.string="";
	textoInfo.align_(\right);

	// Tdef foco comunicacion serial inactiva
	(
		Tdef(\serialInactivo, {var do=6;
			do.do{|i| if(i==(do -1),{
				{focoConexion.valueAction=0}.defer;
				{postGUI.string=postGUI.string+"Comunicacion serial inactiva\n";
					postGUI.stringColor_(stringColor);
					postGUI.select(postGUI.string.size,0)}.defer;
			});0.5.wait;}
		}).quant_(0);
	);
	Tdef(\serialInactivo).stop;




	// Boton inicio Puerto Serial
	serial=Button(ventanaPrincipal, Rect(x+indBotones, indBotonesY+(sizeBoton*1) ,60,60));
	serial.font=Font("Wingdings 3", 35);
	serial.states=[["D",stringColor, butColor],
		["D",Color.white, Color.red]];
	serial.mouseOverAction={|view,x,y| textoInfo.string="Conexión Serial";};

	serial.action={|val| if(val.value==1,
		{
			//p=SerialPort(port,baudrate:9600*2,crtscts: true); // Opera
			p=SerialPort(port,baudrate:9600*2,crtscts: false, xonxoff: true); // BlueTooth
			if(p.isOpen,{postGUI.string=postGUI.string+"Puerto serial conectado\n";
				postGUI.stringColor_(stringColor)},
				{postGUI.string=postGUI.string+"Puerto serial no conectado\n";
					postGUI.stringColor_(stringColor);
					postGUI.select(postGUI.string.size,0)});

			Tdef(\si, {
				inf.do{|a|
					dato=p.read;

					// foco Conexión
					if(dato!=nil,{
						cuentaFoco=cuentaFoco+1;
						{focoConexion.valueAction=cuentaFoco%2}.defer;
						Tdef(\serialInactivo).reset.play;
					});

					if(dato!=48,{
						[dato,dato.asAscii].postln;	{postGUI.string=postGUI.string+([dato,dato.asAscii].asString+"\n");
							postGUI.stringColor_(stringColor);
							postGUI.select(postGUI.string.size,0)}.defer;
					});


					if(datoAnt!=dato, {
						botonesN.do{|i|fEntradas[i].value(dato)}}); //  comentar cuando se usa el de arriba


					// Para ADC en ventana salidas
					if(a%1==0,{
						{numeroADC.value=dato;
						if(numeroADC.value==numeroRefADC.value,{butIgualADC.valueAction=1},
							{butIgualADC.valueAction=0});
						if(numeroADC.value<numeroRefADC.value,{butMenorADC.valueAction=1},
							{butMenorADC.valueAction=0});
						if(numeroADC.value>numeroRefADC.value,{butMayorADC.valueAction=1},
							{butMayorADC.valueAction=0});

							if(botonW.value==1,{

								xAnt=xADC;numeroAnt=numeroADC.value.linlin(0,127,0,400);   xADC=(xADC+1); graficaADC.refresh;

								if(xADC>=590,{userView.clearOnRefresh = true;xADC=0;xAnt=0;},{userView.clearOnRefresh = false;});

								userView.drawFunc = { |v|
									Pen.width = 5;
									Pen.strokeColor = Color.black;
									Pen.moveTo(xAnt.postln@numeroAnt.postln);
									Pen.lineTo(xADC@numeroADC.value.linlin(0,127,0,400));
									Pen.fillStroke;
								}
							}
							);

					}.defer;
					});
					0.0001.wait;
					datoAnt=dato;
			}}).play
		},
		{p.close; Tdef(\si).stop;
			{postGUI.string=postGUI.string+"Puerto serial cerrado\n";
				postGUI.stringColor_(stringColor);
				postGUI.select(postGUI.string.size,0)}.defer;
	})};


    // Led indicador de transmión de datos del puerto serial

	focoConexion=Button(ventanaPrincipal.asView,Rect(x+indBotones+45, indBotonesY+(sizeBoton*1)+5 ,10,10));
	focoConexion.states=[[" ",stringColor, butColor],[" ",Color.white,Color.green]];


	// Boton teclado
	teclado=Button(ventanaPrincipal, Rect(x+(70*1)+indBotones,indBotonesY+(sizeBoton*1),60,60));
	teclado.font=Font("DJ Icons", 50);
	teclado.states=[["?",stringColor, butColor], ["?",Color.white, Color.red]];
	teclado.action={|val| if(val.value==1,
		{ventanaTeclado.visible=true},
		{ventanaTeclado.visible=false})
	};
	teclado.mouseOverAction={|view,x,y| textoInfo.string="Piano Roll";};



	// Boton salidas
	salidas=Button(ventanaPrincipal, Rect(x+(70*2)+indBotones,indBotonesY+(sizeBoton*1),60,60));
	/*salidas.font=Font("Heydings Common Icons", 45);
	salidas.states=[["l",stringColor, butColor],
		["/",Color.white, Color.red]];*/
	/*salidas.font=Font("Arrow 7", 30);
	salidas.states=[["I",stringColor, butColor],
		["I",Color.white, Color.red]];*/
	salidas.font=Font("Modern Pictograms", 45);
	salidas.states=[["]",stringColor, butColor],
		["]",Color.white, Color.red]];
	salidas.action={|val| if(val.value==1,
		{ventanaSalidas.visible=true},
		{ventanaSalidas.visible=false})
	};
	salidas.mouseOverAction={|view,x,y| textoInfo.string="Salidas";};


	// Boton entradas
	entradas=Button(ventanaPrincipal, Rect(x+(70*3)+indBotones,indBotonesY+(sizeBoton*1),60,60));
	/*entradas.font=Font("DJ Icons", 50);
	entradas.states=[["(",stringColor, butColor],
		["(",Color.white, Color.red]];*/
	/*entradas.font=Font("Arrow 7", 30);
	entradas.states=[["H",stringColor, butColor],
		["H",Color.white, Color.red]];*/
	entradas.font=Font("Modern Pictograms", 45);
	entradas.states=[["[",stringColor, butColor],
		["[",Color.white, Color.red]];
	entradas.action={|val| if(val.value==1,
		{ventanaEntradas.visible=true},
		{ventanaEntradas.visible=false})
	};
	entradas.mouseOverAction={|view,x,y| textoInfo.string="Entradas";};


	// Boton Teatrino
	teatrino=Button(ventanaPrincipal, Rect(x+(70*4)+indBotones,indBotonesY+(sizeBoton*1),60,60));
	teatrino.font=Font("Webdings", 50);
	teatrino.states=[["®",stringColor, butColor], ["®",Color.white, Color.red]];
	teatrino.action={|val| if(val.value==1,
		{ventanaTeatrino.visible=true; p.put("T".ascii[0]);p.put(49);},
		{ventanaTeatrino.visible=false; p.put("T".ascii[0]);})
	};
	teatrino.mouseOverAction={|view,x,y| textoInfo.string="Teatrino";};


	// Boton OSC
	osc=Button(ventanaPrincipal, Rect(x+(70*5)+indBotones,indBotonesY+(sizeBoton*1),60,60));
	osc.font=Font("Arial Black", 17);
	osc.states=[["OSC",stringColor, butColor],
		["OSC",Color.white, Color.red]];
	osc.action={|val| if(val.value==1,
		{ventanaOSC.visible=true;},
		{ventanaOSC.visible=false;})
	};
	osc.mouseOverAction={|view,x,y|  textoInfo.string="OSC";};


	// Menu pop Serial
	serialPop = PopUpMenu(ventanaPrincipal,Rect(x+indBotones,indBotonesY+(sizeBoton*1)+70,70*6 -10,20));
	serialPop.mouseDownAction={|...msg|
		serialPop.items = SerialPort.devices.reverse;};
	serialPop.items = SerialPort.devices.reverse;
	serialPop.background_(butColor);
	serialPop.stringColor_(stringColor);
	serialPop.font_(Font("Courier", 13));
	serialPop.allowsReselection=true;
	serialPop.action = { arg menu;
		[menu.value, menu.item].postln;
		port=menu.item;
	};
	serialPop.mouseOverAction={|view,x,y| textoInfo.string="Puerto Serial";};


	// Post

	postGUI=TextView(ventanaPrincipal.asView,Rect(x+indBotones,indBotonesY+(sizeBoton*1)+70+30,70*6 - 10,235)).focus(true);
	postGUI.background_(butColor);
	//postGUI.setStringColor (Color.white,0,postGUI.string.size);
	postGUI.string="Bienvenidos a Ópera\nVersión 92 20/07/2020\nYurian Zerón y Ernesto Romero\nServidor Listo\n";
	postGUI.stringColor_(stringColor);

	botonClearPost=Button(ventanaPrincipal.asView,Rect(x+indBotones+(sizeBoton*11) -20,indBotonesY+(sizeBoton*1)+70+240,80,20));
	botonClearPost.states=[["Borrar Post",stringColor, butColor]];
	botonClearPost.action={|val| postGUI.string="";
		postGUI.stringColor_(stringColor);};




	// Meter

	// Boton meter
	botonMeter=Button(ventanaPrincipal, Rect(x - 10,indBotonesY+(sizeBoton*1)+70,80 +10,20 + 235 + 10));
	botonMeter.states=[[" ",stringColor, butColor]];

  //ServerMeterViewOpera(s,ventanaPrincipal,((x*2)+(70*5) - 20)@125,0,2);
	ServerMeterViewOpera(s,ventanaPrincipal,x@125,0,2);




















	//////////////////////////////////
	//  Teclado
	//////////////////////////////////



	offSetY=indBotonesY+(sizeBoton*5) -7;

    indBotonesXTeclado=38;

	// ventanaTeclado=Window("OPERA Secuenciador Teclado", Rect((x*2)+(70*5)+57+indBotones,Window.screenBounds.height +100,810,700), scroll: true);
	ventanaTeclado=Window("OPERA Secuenciador Teclado", Rect((x*2)+(70*5)+57+indBotones, Window.screenBounds.height, x+indBotonesXTeclado+(70*8) +indBotones+10, 782), scroll: true);
	ventanaTeclado.acceptsMouseOver=true;
	ventanaTeclado.view.background_(background);
	ventanaTeclado.view.deleteOnClose=false;


    tecladoView=View(ventanaTeclado,Rect(0,0,810,700));
	tecladoView.mouseOverAction={|view,x,y| tecladoTextoInfo.string=" ";};


	tecladoTextoInfo=StaticText(ventanaTeclado, Rect(x+(70*6)+indBotones+40, indBotonesY+(sizeBoton*0)+5, 120, 20)).stringColor_(stringColor);
	tecladoTextoInfo.string="";
	tecladoTextoInfo.align_(\right);



	//botonStartNotas=Button(ventanaTeclado, Rect(offSetX - 10 +705,offSetY -anchoTecla,50,50));
	botonStartNotas=Button(ventanaTeclado, Rect(x+indBotonesXTeclado+indBotones, indBotonesY+(sizeBoton*1) ,60,60)).front;
	botonStartNotas.font=Font("Webdings", 40);
	botonStartNotas.states=[["4", stringColor, butColor]];
	botonStartNotas.mouseOverAction={|view,x,y| tecladoTextoInfo.string="Reproducir";};
	botonStartNotas.action={|val| if(botonPauseNotas.value==0,{Tdef(\secNotas).play},
		                                                      {Tdef(\secNotas).resume;botonPauseNotas.valueAction=0})};




	// botonPauseNotas=Button(ventanaTeclado, Rect(offSetX - 10 +705,offSetY -anchoTecla+55,50,50));
	botonPauseNotas=Button(ventanaTeclado, Rect(x+indBotonesXTeclado+(70*1)+indBotones, indBotonesY+(sizeBoton*1) ,60,60)).front;
	botonPauseNotas.font=Font("Webdings", 40);
	botonPauseNotas.states=[[";", stringColor, butColor],[";", Color.white, Color.red]];
	botonPauseNotas.mouseOverAction={|view,x,y| tecladoTextoInfo.string="Pausa";};
	botonPauseNotas.action={|val| if(val.value==0,{Tdef(\secNotas).resume},{Tdef(\secNotas).pause;})};


	// botonStopNotas=Button(ventanaTeclado, Rect(offSetX - 10 +705,offSetY -anchoTecla+55+55,50,50));
	botonStopNotas=Button(ventanaTeclado, Rect(x+indBotonesXTeclado+(70*2)+indBotones, indBotonesY+(sizeBoton*1) ,60,60)).front;
	botonStopNotas.font=Font("Webdings", 40);
	botonStopNotas.states=[["<", stringColor, butColor]];
	botonStopNotas.mouseOverAction={|view,x,y| tecladoTextoInfo.string="Detener";};
	botonStopNotas.action={Tdef(\secNotas).stop;botonPauseNotas.valueAction=0;
//("############################"++columnaResetTeclado).postln;
(105-23).do{|k|
				if(matrizNotas[(columnaResetTeclado )%lineasX+(64*k)].value!=1,{
					                   matrizNotas[(columnaResetTeclado )%lineasX+(64*k)].valueAction=3;
							                                                                                      });
			      };

	};


	// NumberBox Tempo Teclado
	// tempoTecladoNumber=NumberBox(ventanaTeclado, Rect(offSetX - 10 +705,offSetY -anchoTecla+55+55+55,50,25)).background_(butColor).normalColor_(stringColor);
	Button(ventanaTeclado, Rect(x+indBotonesXTeclado+(70*3)+indBotones, indBotonesY+(sizeBoton*1) ,60,60)).states=[["", stringColor, butColor]];
	tempoTecladoNumber=NumberBox(ventanaTeclado, Rect(x+indBotonesXTeclado+(70*3)+indBotones, indBotonesY+(sizeBoton*1)+40 ,60,20)).background_(butColor).normalColor_(stringColor);
	tempoTecladoNumber.mouseOverAction={|view,x,y| tecladoTextoInfo.string="bpm";};
	tempoTecladoNumber.align=\center;
	tempoTecladoNumber.value=(30/(tempoSecNotas*4)).asInteger;

	// sliderTempoNotas=Slider(ventanaTeclado, Rect(offSetX - 10 +705,offSetY -anchoTecla+55+55+55+30,50,200));
	// sliderTempoNotas=Slider(ventanaTeclado, Rect(x+indBotonesXTeclado+(70*4)+indBotones, indBotonesY+(sizeBoton*1) ,120,60));
	sliderTempoNotas=Knob(ventanaTeclado, Rect(x+indBotonesXTeclado+(70*3)+indBotones, indBotonesY+(sizeBoton*1)+3 ,60,36)).front;
	sliderTempoNotas.mouseOverAction={|view,x,y| tecladoTextoInfo.string="bpm";};
	//sliderTempoNotas.action={|val| tempoSecNotas=val.value.linlin(0,1,0.5,0.006);
	sliderTempoNotas.action={|val| tempoSecNotas=val.value.linlin(0,1,0.25,0.018);
		tempoTecladoNumber.value=(30/(tempoSecNotas*4)).asInteger};
	sliderTempoNotas.valueAction=0.5;
	//sliderTempoNotas.background=butColor;

	// botonRandomNotas=Button(ventanaTeclado, Rect(offSetX - 10 +705,offSetY -anchoTecla+55+55+55+205+30,50,50));
	botonRandomNotas=Button(ventanaTeclado, Rect(x+indBotonesXTeclado+(70*4) +indBotones, indBotonesY+(sizeBoton*1) ,60,60));
	botonRandomNotas.states=[["O", stringColor, butColor]];
	botonRandomNotas.font=Font("Block Shape", 40);
	botonRandomNotas.mouseOverAction={|view,x,y| tecladoTextoInfo.string="Aleatorio";};
	botonRandomNotas.action={|val|
		matrizNotasRandom=0!((105-23)*64);
		64.do{|i| matrizNotasRandom[(((0..(104-23))*64)+i).choose]=1};
		~matrizNotasRandom=matrizNotasRandom;
		matrizNotas.size.do{|j| matrizNotas[j].valueAction=matrizNotasRandom[j]};
		(
			64.do{|i|
				(105-23).do{|j|
					if(matrizNotas[i+(64*j)].value==1,{
						//[i,(i+(64*j))].postln;
						arrayMatrizValMIDI[i]=(84 -(3*12) -j +69 -36)
					});
				}
			}
		);
		~arrayMatrizValMIDI=arrayMatrizValMIDI;
	};

	// botonBorraNotas=Button(ventanaTeclado, Rect(offSetX - 10 +705,offSetY -anchoTecla+55+55+55+205+55+30,50,50));
	botonBorraNotas=Button(ventanaTeclado, Rect(x+indBotonesXTeclado+(70*5)  +indBotones, indBotonesY+(sizeBoton*1) ,60,60));
	botonBorraNotas.states=[["X", stringColor, butColor]];
	botonBorraNotas.font=Font("Modern Pictograms", 40);
	botonBorraNotas.mouseOverAction={|view,x,y| tecladoTextoInfo.string="Borrar";};
	botonBorraNotas.action={|val|
		matrizNotas.size.do{|j| matrizNotas[j].valueAction=0};
	};

	//dialogoSalva=Button(ventanaTeclado,Rect(offSetX - 10 +705,offSetY -anchoTecla+55+55+55+205+110+30,50,50));
	dialogoSalva=Button(ventanaTeclado,Rect(x+indBotonesXTeclado+(70*6)  +indBotones, indBotonesY+(sizeBoton*1) ,60,60));
	dialogoSalva.states=[["D", stringColor, butColor]];
	dialogoSalva.font=Font("Heydings Controls", 30);
	dialogoSalva.mouseOverAction={|view,x,y| tecladoTextoInfo.string="Guardar";};
	dialogoSalva.action={|val|
		Dialog.savePanel({|path|
			~matrizGuardaNotas1=0!matrizNotas.size;
			matrizNotas.size.do{|j|
				~matrizGuardaNotas1[j]=matrizNotas[j].value};
			l=~matrizGuardaNotas1[0].asString;
			(~matrizGuardaNotas1.size-1).do{|i|
				l=l++~matrizGuardaNotas1[i+1].asString};
			("touch "++path).unixCmd;
			("echo 'a="++'"'++l.asString++'"'++"' > "++path).unixCmd
		});
	};

	//dialogoCarga=Button(ventanaTeclado,Rect(offSetX - 10 +705,offSetY -anchoTecla+55+55+55+205+165+30,50,50));
	dialogoCarga=Button(ventanaTeclado,Rect(x+indBotonesXTeclado+(70*7) +indBotones, indBotonesY+(sizeBoton*1) ,60,60));
	dialogoCarga.states=[["m", stringColor, butColor]];
	dialogoCarga.font=Font("Eleganticons", 30);
	dialogoCarga.mouseOverAction={|view,x,y| tecladoTextoInfo.string="Abrir";};
	dialogoCarga.action={|val| Dialog.openPanel({|path|
		path.load;
		matrizNotas.size.do{|j| matrizNotas[j].valueAction=a[j].asString.asInteger};
		(
			64.do{|i|
				(105-23).do{|j|
					if(matrizNotas[i+(64*j)].value==1,{
						//[i,(i+(64*j))].postln;
						arrayMatrizValMIDI[i]=(84 -(3*12) -j +69 -36)
					});
				}
			}
		);
		~arrayMatrizValMIDI=arrayMatrizValMIDI;})
	};





    rangoCompases=RangeSlider(ventanaTeclado, Rect(offSetX+largoTecla,offSetY -45,50+((10*((14*4)+3))),20));
	rangoCompases.step=1/64;
	rangoCompases.action={|slider|
		[((slider.lo)*63).ceil+1,((slider.hi)*63).ceil+1].value.postln;
		rangoCompasesLo=(((slider.lo)*63).ceil).value;
		rangoCompasesHi=(((slider.hi)*63).ceil).value;

		(rangoCompasesHi -rangoCompasesLo).do{|m|
		(105-23).do{|j|
				3.do{|n|                 // Borra la linea indicadora donde va y uno atras y uno adelante
					if(matrizNotas[(m+rangoCompasesLo+ (n -1))+(64*j)].value!=1,{
								matrizNotas[(m+rangoCompasesLo+ (n -1))+(64*j)].value=3;
							    //arrayMatrizValMIDI[(i -1)%lineasX]=(84 -(3*12) -j +69 -36)
							});
				}
		}
		}
	};



	arrayTeclado=nil!(85+20);
	negrasBlancas=[1,0,1,0,1,1,0,1,0,1,0,1].rotate(rotaTecla);
	teclasLargo=[1,2/3,1,2/3,1,1,2/3,1,2/3,1,2/3,1].rotate(rotaTecla)*largoTecla;
	teclasAncho=[1,1/2,1,1/2,1,1,1/2,1,1/2,1,1/2,1].rotate(rotaTecla)*anchoTecla;
	negrasShift=[0,1/2,0,1/2,0,0,1/2,0,1/2,0,1/2,0].rotate(rotaTecla)*anchoTecla/2;

	arrayTeclado.size.do{|i|

		if(i<=84,

			// Notas
			{
				if(i!=84,{
					arrayTeclado[i]=Button(ventanaTeclado, Rect(offSetX,offSetY+(i*10), teclasLargo[i%12],teclasAncho[i%12]));
					arrayTeclado[i].states=[[" ", Color.white, Color(1*negrasBlancas[i%12],1*negrasBlancas[i%12],1*negrasBlancas[i%12])]];
					},
					{
						arrayTeclado[i]=Button(ventanaTeclado, Rect(offSetX,offSetY+(i*10), teclasLargo[i%12],teclasAncho[i%12]/2));
						arrayTeclado[i].states=[[" ", Color.white, Color(1*negrasBlancas[i%12],1*negrasBlancas[i%12],1*negrasBlancas[i%12])]];
				});
			},

			// Ruidos
			{
				arrayTeclado[i]=Button(ventanaTeclado, Rect(offSetX,(anchoTecla*1)+offSetY+(i*10), largoTecla,anchoTecla/2));
				arrayTeclado[i].states=[[("/// "++((i-84)-21).abs++" ///"), Color.black, Color.white]];
		});
		arrayTeclado[i].font=Font("Arial",15);
	};

	//arrayTeclado[84]=Button(ventanaTeclado, Rect(offSetX,offSetY+(84*10), teclasLargo[84%12],teclasAncho[84%12]/2));
	7.do{|i|
		arrayTeclado[(45 -36)+(i*12)].states=[["C"++(((i-8).abs)),Color.black,Color.white]];
	};



	lineasY=85+20;
	lineasX=64;
	matrizNotas=nil!(lineasY*lineasX);
	~matrizNotas=matrizNotas;
	arrayMatrizVal=0!lineasX;
	arrayMatrizValMIDI=0!lineasX;

	compases=nil!(lineasX/4);
	compases.size.do{|i|
		compases[i]=StaticText(ventanaTeclado, Rect(offSetX+largoTecla+(i*buttonSize*4),offSetY -anchoTecla, buttonSize*4*0.95, buttonSize*1.75));
		compases[i].background=Color.white;
		compases[i].stringColor=Color.black;
		compases[i].string=(i+1);
	};

	ventanaTeclado.drawFunc={
		(compases.size+1).do{|i|
			//Pen.strokeColor=Color.white;
			Pen.width=5;
			Pen.strokeColor=Color(colorLineas,colorLineas,colorLineas);
			//Pen.line((offSetX+largoTecla+(i*buttonSize*4))@(offSetY -anchoTecla),(offSetX+largoTecla+(i*buttonSize*4))@(offSetY +800));
			Pen.line((offSetX -1+largoTecla+(i*buttonSize*4))@(offSetY -anchoTecla),(offSetX -1+largoTecla+(i*buttonSize*4))@(offSetY+((anchoTecla/2)*lineasY)+(anchoTecla*2)));
			Pen.stroke;
		}
	};

	lineasY.do{|y|
		lineasX.do{|x|

			if(y<=84,

				// Notas
				{
					matrizNotas[(y*lineasX)+x]=Button(ventanaTeclado, Rect(offSetX+largoTecla+(buttonSize*x),offSetY+((anchoTecla/2)*y),buttonSize,buttonSize));
					matrizNotas[(y*lineasX)+x].states=[
						[" ", Color.white, Color((negrasBlancas[y%12]*(1+colorLineas) -colorLineas).abs,(negrasBlancas[y%12]*(1+colorLineas) -colorLineas).abs,(negrasBlancas[y%12]*(1+colorLineas) -colorLineas).abs)],
						[" ", Color.red, Color.red],
						[" ", Color.white, Color((negrasBlancas[y%12]*(0+colorLineas) -colorLineas).abs,(negrasBlancas[y%12]*(0+colorLineas) -colorLineas).abs,(negrasBlancas[y%12]*(0+colorLineas) -colorLineas).abs)],
						[" ", Color.white, Color((negrasBlancas[y%12]*(1+colorLineas) -colorLineas).abs,(negrasBlancas[y%12]*(1+colorLineas) -colorLineas).abs,(negrasBlancas[y%12]*(1+colorLineas) -colorLineas).abs)],
					];

					matrizNotas[(y*lineasX)+x].action={|val|

						if(val.value==1,{
							lineasY.do{|l|
								//("l="++l++" y="++y).postln;
								if(l!=y,{matrizNotas[(l*lineasX)+x].valueAction=0})};
						});

						arrayMatrizVal[x]=val.value*(84 -(3*12) -y).midiratio*440;
						//arrayMatrizVal.postln;
						arrayMatrizValMIDI[x]=val.value*(84 -(3*12) -y +69 -36);
						//arrayMatrizValMIDI.postln;
						~arrayMatrizValMIDI=arrayMatrizValMIDI;

						~matrizNotas=matrizNotas;

					};
				},

				// Ruidos
				{
					matrizNotas[(y*lineasX)+x]=Button(ventanaTeclado, Rect(offSetX+largoTecla+(buttonSize*x),(anchoTecla*1)+offSetY+((anchoTecla/2)*y),buttonSize,buttonSize));
					colorLineasRuido=(y -84)*13;
					matrizNotas[(y*lineasX)+x].states=[[" ", Color.white, Color.new255(colorLineasRuido,colorLineasRuido,colorLineasRuido)],[" ", Color.red, Color.red]];

					matrizNotas[(y*lineasX)+x].action={|val|

						if(val.value==1,{
							lineasY.do{|l|
								//("l="++l++" y="++y).postln;
								if(l!=y,{matrizNotas[(l*lineasX)+x].valueAction=0})};
						});

						arrayMatrizVal[x]=val.value*(84 -(4*12) -y).midiratio* -440;
						//arrayMatrizVal.postln;
						arrayMatrizValMIDI[x]=val.value*(84 -(4*12) -y +69 -36);
						//arrayMatrizValMIDI.postln;
						~arrayMatrizValMIDI=arrayMatrizValMIDI;

					};
			});



		}
	};

	compases2=nil!(lineasX/4);
	compases2.size.do{|i|
		compases2[i]=StaticText(ventanaTeclado, Rect(offSetX+largoTecla+(i*buttonSize*4),(offSetY -anchoTecla)+((anchoTecla* -0.5)+offSetY+((anchoTecla/2)*(85+20))), buttonSize*4*0.95, buttonSize*1.75));
		compases2[i].background=Color.white;
		compases2[i].stringColor=Color.black;
		compases2[i].string=(i+1);
	};




	arrayNotas127=[
		/*C3*/1, 3, 5, 7, 9, 11, 13, 15, 18, 20, 22, 24,
		/*C4*/26, 28, 30, 32, 35, 37, 39, 41, 43, 45, 47, 49,
		/*C5*/52,55,60,64,67,71,74,77,80,83,85,88,
		/*C6*/90, 90, 91, 92, 93, 93, 94, 95, 96, 96, 97, 98,
		/*C7*/99, 100, 100, 101, 102, 103, 103, 104, 105, 106, 106, 107,
		/*C8*/108, 109, 110, 110, 111, 112, 113, 113, 114, 115, 116, 116,
		/*C9*/117, 118, 119, 120, 120, 121, 122, 123, 123, 124, 125, 126,
		/*C10*/127
	];

	arrayRuidos255=[ 128, 134, 140, 147, 153, 159, 166, 172, 178, 185, 191, 197, 204, 210, 216, 223, 229, 235, 242, 248 ];

	(
		Tdef(\secNotas, {var rango;

			inf.do{|i|

				rango=rangoCompasesHi -rangoCompasesLo;

				if(arrayMatrizValMIDI[i%rango+rangoCompasesLo]!=0, {

					if(arrayMatrizValMIDI[i%rango+rangoCompasesLo]>=0,
						{
							//p.put((arrayNotas127[arrayMatrizValMIDI][i%lineasX]));
							2.do{p.put((arrayNotas127[arrayMatrizValMIDI][i%rango+rangoCompasesLo]))};

							/*{Pulse.ar(arrayMatrizVal[i%lineasX])*Line.kr(1,0,0.2,1,0,2)}.play;*/
							/*[arrayMatrizVal[i%lineasX],
								(arrayNotas127[arrayMatrizValMIDI][i%lineasX])];*/
								[arrayMatrizVal[i%rango+rangoCompasesLo], (arrayNotas127[arrayMatrizValMIDI][i%rango+rangoCompasesLo])];
						},
						{
							2.do{p.put(arrayNotas127[arrayMatrizValMIDI][i%rango+rangoCompasesLo])};

							cutOff=arrayMatrizVal[i%rango+rangoCompasesLo].abs*35+100;
							/*{RLPF.ar(LFNoise0.ar(1000),cutOff,0.1)*EnvGen.kr(Env([0,1,1,0],[0.001,tempoSecNotas -0.01, 0.001]),doneAction:2)}.play;*/
							//[cutOff,(arrayRuidos255[arrayMatrizValMIDI -85][i%lineasX])];
							[cutOff,(arrayRuidos255[arrayMatrizValMIDI -85][i%rango+rangoCompasesLo])];
					});
				});


				// Guia Reproduccion Teclado

{
			(105-23).do{|j|
						if(matrizNotas[(i%rango+rangoCompasesLo)+(64*j)].value!=1,{
							matrizNotas[(i%rango+rangoCompasesLo)+(64*j)].value=2;
						//[i,(i+(64*j))].postln;});
					});


					if(i!=0,{
							if(matrizNotas[((i -1)%rango+rangoCompasesLo)+(64*j)].value!=1,{
								matrizNotas[((i -1)%rango+rangoCompasesLo)+(64*j)].value=3;
							    //arrayMatrizValMIDI[(i -1)%lineasX]=(84 -(3*12) -j +69 -36)
							});
						})
				};
}.defer;

               columnaResetTeclado=i;

				tempoSecNotas.wait;
				//p.put(0).postln;
				/*p.put(0);
				tempoSecNotas.wait;*/
			}
		}).quant_(0);
	);
	/*
	Tdef(\secNotas).play;
	Tdef(\secNotas).stop;
	*/

	logo.value(ventanaTeclado);
















	//////////////////////////////////////////
	//   Salidas
	//////////////////////////////////////////


	graficaADC = Window("Grafica ADC", Rect(700,500,700,400)).front;
userView = UserView(graficaADC, Rect(90,10, 590, 380)).background_(Color(1,1,1));
userView.clearOnRefresh = false;

salidasX=100;salidasY=100;

	ventanaSalidas=Window("OPERA Salidas", Rect(0,Window.screenBounds.height -(413.5*2),x+(sizeBoton*16*1.06)+9,380), scroll: true);
	ventanaSalidas.view.background_(background);
	ventanaSalidas.view.deleteOnClose=false;



	logo.value(ventanaSalidas);

	/*botonCloseSalidas=Button(ventanaSalidas, Rect(490,5,50,20));
	botonCloseSalidas.states=[["cerrar", stringColor, butColor]];
	botonCloseSalidas.action={|val| salidas.valueAction=0};*/

	// Salidas Texto
	textoSalidas=StaticText(ventanaSalidas, Rect(x+salidasX+(sizeBoton*5),y-salidasY,sizeBoton*3,sizeBoton)).stringColor_(Color.white);
	textoSalidas.string="Salidas";
	textoSalidas.font=Font("Arial",20);

	// Borrar Salidas Texto
	textoBorrarSalidas=StaticText(ventanaSalidas, Rect(x+salidasX+(sizeBoton*12)-10,y-salidasY,sizeBoton*1.5,sizeBoton)).stringColor_(Color.white);
	textoBorrarSalidas.string="Borrar";
	textoBorrarSalidas.font=Font("Arial",10);

	// Borrar Operas y Operetas
	borrarOpOp=Button(ventanaSalidas,Rect(x+salidasX+(sizeBoton*12.75),y+5-salidasY,sizeBoton*0.5,sizeBoton*0.5));
	borrarOpOp.states=[["x",stringColor, butColor]];
	borrarOpOp.action={
		Tdef(\borrOp, {ß
			13.do{|i| if(i<5, {{arrayButOpera[i].valueAction=0}.defer},
				{{arrayButOpereta[i-5].valueAction=0}.defer});
				waitButConf.wait}
		}).quant_(0).play
	};

	//  Botones de activacion Opera
	arrayButOpera.size.do{|i|
		arrayButOpera[i]=Button(ventanaSalidas,Rect(x+salidasX+(sizeBoton*i),y+sizeBoton-salidasY,sizeBoton,sizeBoton));
		arrayButOpera[i].states=[[charOpera[i],stringColor, butColor],
			[charOpera[i],Color.white, Color.red]];
		arrayButOpera[i].font=Font("Arial", sizeLetra);
		arrayButOpera[i].action={|val|
			if(serial.value==1,{
		                                  if(val.value==1,{p.put(asciiOpera[i]);p.put(49);},
			                                                       {p.put(asciiOpera[i]);p.put(48)});
			                             });

		         /* OSC */                oscOpera.sendMsg("/salida_"++i,val.value);
		                                      };
		oscResponderSalidas[i]=OSCFunc({|...msg| msg.postln; {arrayButOpera[i].valueAction=msg[0][1]}.defer},"/salida_"++i )
	};

	//  Botones de activacion Opereta
	arrayButOpereta.size.do{|i|
		arrayButOpereta[i]=Button(ventanaSalidas, Rect(x+salidasX+(sizeBoton*i)+(arrayButOpera.size*sizeBoton)+10,y+sizeBoton-salidasY,sizeBoton,sizeBoton));
		arrayButOpereta[i].states=[[charOpereta[i], stringColor, butColor],
			[charOpereta[i], Color.white, Color.red]];
		arrayButOpereta[i].action={|val| if(val.value==1, {p.put(asciiOpereta[i]);p.put(49)},
			{p.put(asciiOpereta[i]);p.put(48)})};
		arrayButOpereta[i].font=Font("Arial", sizeLetra)};


	//  Sets
setsY= -30;setsX= -10;
	// Sets Texto
	textoSets=StaticText(ventanaSalidas, Rect(x+salidasX+(sizeBoton*7)+setsX, y+setsY, sizeBoton*1.5, sizeBoton)).stringColor_(Color.white);
	textoSets.string="Sets";
	textoSets.font=Font("Arial",20);


	// Borrar Sets Texto
	textoBorrarSets=StaticText(ventanaSalidas, Rect(x+132+(sizeBoton*11) -5+setsX, y+setsY, sizeBoton*1.5, sizeBoton)).stringColor_(Color.white);
	textoBorrarSets.string="Borrar";
	textoBorrarSets.font=Font("Arial",10);

	// Borrar Sets
	borrarConfs=Button(ventanaSalidas,Rect(x+132+(sizeBoton*12)+setsX, y+5+setsY, sizeBoton*0.5, sizeBoton*0.5));
	borrarConfs.states=[["x",stringColor, butColor]];
	borrarConfs.action={ conf=(0!13)!10};


	//  Botones de Sets
	arrayButConf.size.do{|i|
		arrayButConf[i]=Button(ventanaSalidas, Rect(x+150+(sizeBoton*i)+(sizeBoton*2)+setsX, y+sizeBoton+setsY, sizeBoton, sizeBoton));
		arrayButConf[i].states=[[i+1,stringColor, butColor],[i+1,Color.white,Color.red]];
		arrayButConf[i].action={|val| if(val.value==1,{


			Tdef(\wait1, {
				arrayButConf.size.do{|l| if(l!=i,{{arrayButConf[l].valueAction=0}.defer});
					waitButConf.wait};


				arrayButOpera.size.do{|m|{arrayButOpera[m].valueAction=0}.defer;
					waitButConf.wait};

				arrayButOpereta.size.do{|m|{arrayButOpereta[m].valueAction=0}.defer;
					waitButConf.wait};

				13.do{|j|
					if(j<5,{{arrayButOpera[j].valueAction=conf[i][j]}.defer},
						{{arrayButOpereta[j-5].valueAction=conf[i][j]}.defer});
					0.01.wait;}
			}).play.quant_(0)

		})}
	};

	//  Botones de grabado de configuraciones
	arrayButGrabConf.size.do{|i|
		arrayButGrabConf[i]=Button(ventanaSalidas, Rect(x+128+(sizeBoton*i)+(sizeBoton*3)+setsX, y+7+(sizeBoton*2)+setsY, sizeBoton*0.5, sizeBoton*0.5));
		arrayButGrabConf[i].states=[["s",stringColor, butColor]];
		arrayButGrabConf[i].action={|val|
			(arrayButOpera.size+arrayButOpereta.size).do{|j|
				if(j<5,{conf[i].put(j,arrayButOpera[j].value)},
					{conf[i].put(j,arrayButOpereta[j-5].value)});
			}
		}
	};




	dialogoSalvaSets=Button(ventanaSalidas, Rect(x+salidasX+(sizeBoton*1)+setsX, y+sizeBoton+setsY, sizeBoton, sizeBoton));
	dialogoSalvaSets.states=[["D", stringColor, butColor]];
	dialogoSalvaSets.font=Font("Heydings Controls", 20);
	dialogoSalvaSets.action={|val|
		Dialog.savePanel({|path|
			("touch "++path).unixCmd;
			("echo 'c="++conf++"' > "++path).unixCmd
		});
	};

	dialogoCargaSets=Button(ventanaSalidas, Rect(x+salidasX+(sizeBoton*2)+setsX, y+sizeBoton+setsY, sizeBoton, sizeBoton));
	dialogoCargaSets.states=[["m", stringColor, butColor]];
	dialogoCargaSets.font=Font("Eleganticons", 20);
	dialogoCargaSets.action={|val| Dialog.openPanel({|path|
		path.load;
		textSetsCargados.string=path;
		conf=c;})
	};

	// Texto Sets cargados
	textSetsCargados=TextField(ventanaSalidas,Rect(x+salidasX+(sizeBoton*1)+setsX, y+7+(sizeBoton*2)+setsY, sizeBoton*2, sizeBoton/2)).background_(background).stringColor_(stringColor);
	textSetsCargados.font=Font("Arial", 10);
	textSetsCargados.string="Default";


	/*
	File.getcwd
	*/



	//  Boton W Modo Analogo

	adcX= -10; adcY= -1 * sizeBoton;

	botonW=Button(ventanaSalidas, Rect(x+(sizeBoton*0)+adcX, y+(sizeBoton)+adcY, sizeBoton*2, sizeBoton));
	botonW.states=[["ADC", stringColor, butColor],["ADC", Color.black, Color.red]];
	botonW.action={|val| p.put(87);p.put((val.value+48).asInteger)};

	textoNumeroADC=StaticText(ventanaSalidas, Rect(x+(sizeBoton*2)+adcX, y+(sizeBoton*2)+5+adcY, sizeBoton*2, sizeBoton)).stringColor_(Color.white);
	textoNumeroADC.string="Valor";
	textoNumeroADC.font=Font("Arial",10);

	numeroADC=NumberBox(ventanaSalidas, Rect(x+(sizeBoton*0)+adcX, y+(sizeBoton*2)+5+adcY, sizeBoton*2, sizeBoton)).background_(butColor).normalColor_(stringColor);
	numeroADC.align=\center;

	butMenorADC=Button(ventanaSalidas, Rect(x+(sizeBoton*0)+adcX, y+(sizeBoton*3)+7+adcY ,sizeBoton*(2/3), sizeBoton*(2/3)));
	butMenorADC.states=[["<",stringColor, butColor],["<",Color.white,Color.red]];
	butMenorADC.font=Font("Arial",20);

	butIgualADC=Button(ventanaSalidas, Rect(x+(sizeBoton*0)+(sizeBoton*(2/3))+adcX, y+(sizeBoton*3)+7+adcY, sizeBoton*(2/3), sizeBoton*(2/3)));
	butIgualADC.states=[["=",stringColor, butColor],["=",Color.white,Color.red]];
	butIgualADC.font=Font("Arial",20);

	butMayorADC=Button(ventanaSalidas, Rect(x+(sizeBoton*0)+(sizeBoton*(4/3))+adcX, y+(sizeBoton*3)+7+adcY, sizeBoton*(2/3), sizeBoton*(2/3)));
	butMayorADC.states=[[">",stringColor, butColor],[">",Color.white,Color.red]];
	butMayorADC.font=Font("Arial",20);

	textoRefADC=StaticText(ventanaSalidas, Rect(x+(sizeBoton*2)+adcX, y+(sizeBoton*4)+adcY, sizeBoton*2, sizeBoton)).stringColor_(Color.white);
	textoRefADC.string="Referencia";
	textoRefADC.font=Font("Arial",10);

	numeroRefADC=NumberBox(ventanaSalidas, Rect(x+(sizeBoton*0)+adcX, y+(sizeBoton*4)+adcY, sizeBoton*2, sizeBoton)).background_(butColor).normalColor_(stringColor);
	numeroRefADC.align=\center;









	// Secuenciador
    secX= -10;
	// Secuenciador Texto
	textoSecuenciador=StaticText(ventanaSalidas, Rect(x+secX, ySec+(2*sizeBoton), sizeBoton*5, sizeBoton)).stringColor_(Color.white);
	textoSecuenciador.string="Secuenciador";
	textoSecuenciador.font=Font("Arial",20);

	// Boton Play Secuenciador
	butSecPlay=Button(ventanaSalidas, Rect(x+secX, ySec+(3*sizeBoton), sizeBoton, sizeBoton));
	butSecPlay.states=[[">",stringColor, butColor]];
	butSecPlay.action={|val| if(stoPause=="stop",{Tdef(\seq1).play},{Tdef(\seq1).resume})};

	// Boton Pausa Secuenciador
	butSecPausa=Button(ventanaSalidas, Rect(x+(sizeBoton*1)+secX, ySec+(3*sizeBoton), sizeBoton, sizeBoton));
	butSecPausa.states=[["||",stringColor, butColor]];
	butSecPausa.action={|val| Tdef(\seq1).pause; stoPause="pausa"};

	// Boton Stop Secuenciador
	butSecStop=Button(ventanaSalidas, Rect(x+(sizeBoton*2)+secX, ySec+(3*sizeBoton), sizeBoton, sizeBoton));
	butSecStop.states=[["X",stringColor, butColor]];
	butSecStop.action={|val| Tdef(\seq1).stop; stoPause="stop";
		arrayButPas.size.do{|i| arrayButPas[i].valueAction=0};
		arrayButOpera.size.do{|i| arrayButOpera[i].valueAction=0};
		arrayButOpereta.size.do{|i| arrayButOpereta[i].valueAction=0};
	};

	// NumberBox Tempo Secuenciador
	numBoxTempo=NumberBox(ventanaSalidas, Rect(x+(sizeBoton*6)+12+secX, ySec+(3*sizeBoton), sizeBoton*1.05, sizeBoton)).background_(butColor).normalColor_(stringColor);
	numBoxTempo.value=tempo;

	// BPM Texto
	textoBPM=StaticText(ventanaSalidas, Rect(x+(sizeBoton*7.2)+12+secX, ySec+2+(3*sizeBoton), sizeBoton*1.5, sizeBoton)).stringColor_(Color.white);
	textoBPM.string="bpm";


	// NumberBox In Tempo Secuenciador
	numBoxTempoIn=NumberBox(ventanaSalidas, Rect(x+(sizeBoton*9)+12+secX, ySec+(3*sizeBoton), sizeBoton*1.05,sizeBoton)).background_(butColor).normalColor_(stringColor);
	numBoxTempoIn.action={|val|tempo=val.value};

	// Slider Tempo Secuenciador
	sliderTempo=Slider(ventanaSalidas, Rect(x+(sizeBoton*3)+10+secX, ySec+(3*sizeBoton), sizeBoton*3, sizeBoton)).background_(butColor).knobColor_(Color.black).thumbSize_(8);
	sliderTempo.action={|val| tempo=val.value.linlin(0,1,30,100);
		numBoxTempo.value=tempo.asInteger};
	sliderTempo.valueAction=0.4375;

	// Botones pasos secuenciador
	arrayButPas.size.do{|i|
		arrayButPas[i]=Button(ventanaSalidas, Rect(x+(sizeBoton*i*1.06)+secX, ySec+10+(4*sizeBoton), sizeBoton*0.95, sizeBoton*0.95));
		//colorPasos=(1/(i%4+1)).asInteger*0.3;
		colorPasos=1/(i%4+1);
		arrayButPas[i].states=[[i+1,stringColor,Color(colorPasos,1,1)],[i+1,Color.white,Color.red]];
	};

	//  Botones de grabado de secuenciador
	arrayButGrabPas.size.do{|i|
		arrayButGrabPas[i]=Button(ventanaSalidas, Rect(x+6+(sizeBoton*i*1.06)+secX, ySec+13+(5*sizeBoton), sizeBoton/2, sizeBoton/2));
		arrayButGrabPas[i].states=[["s",stringColor, butColor]];
		arrayButGrabPas[i].action={|val|
			(arrayButOpera.size+arrayButOpereta.size).do{|j|
				if(j<5,{pasos[i].put(j,arrayButOpera[j].value)},
					{pasos[i].put(j,arrayButOpereta[j-5].value)});
			}
		}
	};


	//  Rutina Secuenciador
	(
		Tdef(\seq1, {inf.do{|i|
			//{arrayButPas[i%16].valueAction=1}.defer;
			arrayButPas.size.do{|l| if(l!=(i%16),{{arrayButPas[l].valueAction=0}.defer},
				{{arrayButPas[i%16].valueAction=1}.defer})};
			13.do{|j| if(j<5,{{arrayButOpera[j].valueAction=pasos[i%16][j]}.defer},
				{{arrayButOpereta[j-5].valueAction=pasos[i%16][j]}.defer});
				waitButConf.wait;
			};
			(15/tempo).wait;
			}
		}).quant_(0);
	);



	dialogoSalvaSec=Button(ventanaSalidas, Rect(x+(sizeBoton*12.2)+12+secX, ySec+2+(3*sizeBoton), sizeBoton*1.75, sizeBoton));
	dialogoSalvaSec.states=[["Guarda", stringColor, butColor]];
	dialogoSalvaSec.action={|val|
		Dialog.savePanel({|path|
			pasoSec=pasos[0].asString;
			(pasos.size-1).do{|i|
				pasoSec=pasoSec++","++pasos[i+1].asString};
			("touch "++path).unixCmd;
			("echo 'b="++'['++pasoSec++']'++"' > "++path).unixCmd
		});
	};

	dialogoCargaSec=Button(ventanaSalidas, Rect(x+(sizeBoton*14.2)+12+secX, ySec+2+(3*sizeBoton), sizeBoton*1.75, sizeBoton));
	dialogoCargaSec.states=[["Abre", stringColor, butColor]];
	dialogoCargaSec.action={|val| Dialog.openPanel({|path|
		path.load;
		pasos=b;})
	};





















	//////////////////////////////////////////
	//   Entradas
	//////////////////////////////////////////



	// ventanaEntradas=Window("OPERA Entradas", Rect((x*2)+(70*4)+15+57,40,800,700), scroll: true);
	// ventanaEntradas=Window("OPERA Entradas", Rect(380,Window.screenBounds.height,800,700), scroll: true);
	ventanaEntradas=Window("OPERA Entradas", Rect(ventanaTeclado.bounds.right,Window.screenBounds.height,800,700), scroll: true);


	(
		SynthDef(\playOpera, {|buf=0,amp=1, loop 0, gate=1|
			var sig, env;
			sig=PlayBuf.ar(1,buf, loop:loop)*amp;
			env=EnvGen.kr(Env.asr(0,1,0.01),gate, doneAction:2);
			Out.ar(0,sig*env);
		}).send(s);
	);

	(
		SynthDef(\playOperaStereo, {|buf=0,amp=1, loop 0, gate=1|
			var sig, env;
			sig=PlayBuf.ar(2,buf, loop:loop)*amp;
			env=EnvGen.kr(Env.asr(0,1,0.01),gate, doneAction:2);
			Out.ar(0,sig*env);
		}).send(s);
	);




	// Funcion rediseño ventana ampliación de canales

	funcBotonesEntradas={|n=4|


		botonesN=n;
		botonesEntrada=nil!botonesN;
		inDialog=nil!botonesN;
		botonesModo=nil!botonesN;
		synths=nil!botonesN;
		inSlids=nil!botonesN;
		textSample=nil!botonesN;
		amps=0!botonesN;
		fEntradas=nil!botonesN; fEntradas0=nil!botonesN; fEntradas1=nil!botonesN;
		fEntradas2=nil!botonesN;
		contIn=0!botonesN;
        oscResponderBotonesEntrada=nil!botonesN;

		ventanaEntradas.close;
		// ventanaEntradas=Window("OPERA Entradas", Rect((x*2)+(70*4)+15+57,40,sizeBoton*((n*2)+1),700), scroll: true).front;
		ventanaEntradas=Window("OPERA Entradas", Rect(ventanaTeclado.bounds.right.postln,Window.screenBounds.height,sizeBoton*((n*2)+1),700), scroll: true).front;
		ventanaEntradas.view.background_(background);
		ventanaEntradas.view.deleteOnClose=false;

	    logo.value(ventanaEntradas);

/*
		botonCloseEntradas=Button(ventanaEntradas, Rect(705,5,50,20));
		botonCloseEntradas.states=[["cerrar", stringColor, butColor]];
		botonCloseEntradas.action={|val| entradas.valueAction=0};
*/

		menuEntradas=PopUpMenu(ventanaEntradas,Rect(xIn+(60*1)+88,yIn -60,83,20));
		menuEntradas.items=[4,10,16,26,"matriz"];
		menuEntradas.background_(butColor);
		menuEntradas.stringColor_(stringColor);
		menuEntradas.action={|val| [val.value, val.item].postln;

			if(val.value==0,{funcBotonesEntradas.value(4);
			ventanaEntradas.refresh;
				menuEntradas.value=0;
			ventanaEntradas.visible;
			p.put("E".ascii[0]);
			});

			if(val.value==1,{funcBotonesEntradas.value(10);
			ventanaEntradas.refresh;
				menuEntradas.value=1;
			ventanaEntradas.visible;
			p.put("F".ascii[0]);});

			if(val.value==2,{funcBotonesEntradas.value(16);
			ventanaEntradas.refresh;
				menuEntradas.value=2;
			ventanaEntradas.visible;
			p.put("G".ascii[0]);});

			if(val.value==3,{funcBotonesEntradas.value(25);
			ventanaEntradas.refresh;
				menuEntradas.value=3;
			ventanaEntradas.visible;
			p.put("H".ascii[0]);});

			if(val.value==4,
			{ventanaMatriz.visible=true;
				menuEntradas.value=4;},
			{ventanaMatriz.visible=false})


		};


		//  Grabar Ejecución Sonidos Entradas

		botonGrabarEntradas=Button(ventanaEntradas, Rect(xIn+(60*1),yIn -25,83,20));
		botonGrabarEntradas.states=[["Grabar",stringColor, butColor],["Grabando",Color.white,Color.red]];
		botonGrabarEntradas.action={|val|
			if(val.value==1,{s.record;Tdef(\cronometroGraba).play;},
				{s.stopRecording;Tdef(\cronometroGraba).stop;})
		};



		// Cronómetro

		cronoGrabaEntradas=TextField(ventanaEntradas, Rect(xIn+(60*1)+88,yIn -25,83,20));
		cronoGrabaEntradas.stringColor_(stringColor).background_(butColor);
		cronoGrabaEntradas.align=\center;
		cronoGrabaEntradas.string=hrs++":"++mins++":"++segs;

		(
			Tdef(\cronometroGraba, {var hr,min,seg;
				inf.do{|i|
					hrs=((i/360).asInteger)%60;
					mins=((i/60).asInteger)%60;
					segs=i%60;

					if(segs<10,{seg="0"++segs.asString},{seg=segs.asString});
					if(mins<10,{min="0"++mins.asString},{min=mins.asString});
					if(hrs<10,{hr="0"++hrs.asString},{hr=hrs.asString});
					{cronoGrabaEntradas.string=hr.asString++":"++min.asString++":"++seg.asString;}.defer;
					1.wait;
				}
			}).quant_(0);
		);



		//  Matriz



		// definir el tamaño de la matriz x*y

		~xMatriz=5;
		~yMatriz=5;


		~arrayButMatriz=nil!(~xMatriz*~yMatriz);
		~matrizButSize=100;
		(
			ventanaMatriz=Window("matriz", Rect(100,100,((~matrizButSize+10)*~xMatriz)+15,((~matrizButSize+10)*~yMatriz)+15));
			ventanaMatriz.view.background_(Color.black);
			~yMatriz.do{|y|
				~xMatriz.do{|x|
					~arrayButMatriz[x+y]=Button(ventanaMatriz,Rect(10+((~matrizButSize+10)*x),10+((~matrizButSize+10)*y),~matrizButSize,~matrizButSize));
					~arrayButMatriz[x+y].states=[["",Color.black, Color.white],["",Color.black, Color.red]];
				};
			};
		);






		botonesN.do{|i|
			{
				botonesEntradasY=(((i/botonesEntradasXModulo).floor*(yIn+(sizeBoton*1)+30))*2);

				botonesEntrada[i]=Button(ventanaEntradas, Rect(xIn+(60*(i%botonesEntradasXModulo)),yIn+botonesEntradasY,50,50));
				botonesEntrada[i].states=[[i+1, stringColor, butColor],[i+1, Color.white, Color.red]];
				botonesEntrada[i].action={|val| val.value;
						                  //fEntradas[i].value(asciiIn[i].asString);
					if(val.value==1,{
						/* OSC */       oscOpera.sendMsg(("/boton_"++i).asString, 1);
						if(bufs[i].numChannels==1,{
							synths[i].set(\gate, 0);
							synths[i]=Synth(\playOpera, [\buf, bufs[i], \amp, amps[i], \loop, loop]);},
							{
								synths[i]=Synth(\playOperaStereo, [\buf, bufs[i], \amp, amps[i], \loop, loop]);});

						},
						{
			/* OSC */       oscOpera.sendMsg(("/boton_"++i).asString, 0);
							synths[i].set(\gate, 0)});
				};



				// Texto Sample  (En el documento Varios/TextoSample.scd hay un intento de mostrar el nombre de la muestra sin el path

			/*	textSample[i]=TextField(ventanaEntradas,Rect(xIn+(60*(i%botonesEntradasXModulo)), yIn+(sizeBoton*1)+30+botonesEntradasY+152,50,30));
				textSample[i].font=Font("Arial", 10);
				//textSample[i].string=bufs[i].path;
				textSample[i].string=textSampleArray[i];
*/

				bufDefault=["01_bomboBombon.wav", "02_tarolaBombon.wav","03_hiSoul.wav","04_bell.wav"];
textSample[i] = ListView(ventanaEntradas,Rect(xIn+(60*(i%botonesEntradasXModulo)), yIn+(sizeBoton*2)+30+botonesEntradasY+152,50,170));
textSample[i].font=Font("Arial", 10);
//textSample[i].items=bufDefault;
				textSample[i].items=textSampleArray;
textSample[i].action_({ arg val;
        [val.value, textSample[i].items[val.value]].postln;
					bufs[i]=Buffer.read(s,textSample[i].items[val.value]);// .value returns the integer
    });

				// Boton carga Audio Entrada
				inDialog[i]=Button(ventanaEntradas,Rect(xIn+(60*(i%botonesEntradasXModulo)),yIn+(sizeBoton*2)+botonesEntradasY,20,20));
				inDialog[i].states=[["o", Color.white,Color.green]];
				inDialog[i].action={|val| Dialog.openPanel({|path|
					bufs[i]=Buffer.read(s,path);
					textSampleArray[i]=bufs[i].path;
					//textSample[i].string=textSampleArray[i];
					textSample[i].items=textSampleArray;
					});
				};

				// Boton Modo
				botonesModo[i]=Button(ventanaEntradas,Rect(xIn+(60*(i%botonesEntradasXModulo))+30,yIn+(sizeBoton*2)+botonesEntradasY,20,20));
				botonesModo[i].states=[["0", Color.black,Color.white],
					["1", Color.black,Color.white],
					["2", Color.black,Color.white]];
				botonesModo[i].action={|val|
					/*if(val.value==0,{fEntradas[i]=fEntradas0[i]},{fEntradas[i]=fEntradas1[i]});*/
					switch(val.value,0,{fEntradas[i]=fEntradas0[i]},
						             1,{fEntradas[i]=fEntradas1[i]},
						             2,{fEntradas[i]=fEntradas2[i]}
					);
				};

				// Sliders

				inSlids[i]=Slider(ventanaEntradas, Rect(xIn+(60*(i%botonesEntradasXModulo)), yIn+(sizeBoton*2)+30+botonesEntradasY,50,150));
				inSlids[i].action={|val|
					amps[i]=val.value;
					synths[i].set(\amp, amps[i])};
				inSlids[i].valueAction=1;



				// MODOS botones
				//asciiIn[i].asString

				// Modo 0 enciende/enciende
				(
					fEntradas0[i]={|val|
						if(val.asAscii.asString==asciiIn[i].asString, {contIn[i]=((contIn[i]+1)%1)+1;
							contIn.postln;

							{botonesEntrada[i].valueAction=0}.defer;
							{botonesEntrada[i].valueAction=1;}.defer;
								loop=0;

							//{(bufs[i].numFrames/44100).wait;{botonesEntrada[i].valueAction=0}.defer;}.fork;
							Tdef(("modo0"++i).asSymbol).stop;
								Tdef(("modo0"++i).asSymbol, {1.do{
								              (bufs[i].numFrames/44100).wait;
								              {botonesEntrada[i].valueAction=0}.defer;
							}
							                  }).quant_(0).reset.play;

						})
					}
				);

				// Modo 1 enciende / apaga
				(
					fEntradas1[i]={|val|
						if(val.asAscii.asString==asciiIn[i].asString, {contIn[i]=((contIn[i]+1)%2);
							contIn.postln;
							if(contIn[i]==1,
							{{botonesEntrada[i].valueAction=1}.defer;
								loop=0;},
							{{botonesEntrada[i].valueAction=0}.defer;
								loop=0;});
						});
					};
				);

				// Modo 2 loop
				(
					fEntradas2[i]={|val|
						if(val.asAscii.asString==asciiIn[i].asString, {contIn[i]=((contIn[i]+1)%2);
							contIn.postln;
							if(contIn[i]==1,
						    {{botonesEntrada[i].valueAction=1}.defer;
								loop=1;},
                            {{botonesEntrada[i].valueAction=0}.defer;
								loop=0;});
						});
					};
				);


				// OSC //

				oscResponderBotonesEntrada[i]=OSCFunc({|...msg|
					msg.postln;
					//{postGUI.string="me la pelas"}.defer;
					{botonesEntrada[i].valueAction=msg[0][1]}.defer;
					/*if(msg[2][1]==1,{{botonesEntrada[i].valueAction=1}.defer;("boton "++(i+1)++"=1").postln},
						                      {{botonesEntrada[i].valueAction=0}.defer;("boton "++(i+1)++"=0").postln});*/
				}, "/boton_"++i );



				fEntradas[i]=fEntradas0[i];
			}.defer;
		}
	};
	funcBotonesEntradas.value(4);

	botonesN.do{|i| bufs[i]=Buffer.read(s,"/Users/ernestoromero/Documents/Yurix/Opera/Sonidos/"++bufDefault[i]);
		//botonesN.do{|i| bufs[i]=Buffer.read(s,File.getcwd++"/Sonidos/"++bufDefault[i]);  Para detectar el folder de trabajo
		textSampleArray[i]=bufs[i].path;
		//textSample[i].string=textSampleArray[i];
		textSample[i].items=textSampleArray;
	};
	ventanaEntradas.visible=false;























	//////////////////////////////////////////
	//   Teatrino
	//////////////////////////////////////////



	ventanaTeatrino=Window("OPERA Teatrino", Rect(0,(ventanaSalidas.bounds.top -128),ventanaPrincipal.bounds.right,105), scroll: true);
	ventanaTeatrino.acceptsMouseOver=true;
	ventanaTeatrino.view.background_(background);
	ventanaTeatrino.view.deleteOnClose=false;

    teatrinoView=View(ventanaTeatrino,Rect(0,0,ventanaTeatrino.bounds.right,ventanaTeatrino.bounds.bottom));
	teatrinoView.mouseOverAction={|view,x,y| teatrinoInfo.string=" ";};

	logo.value(ventanaTeatrino);



	teatrinoInfo=StaticText(ventanaTeatrino, Rect(x+(70*4)+indBotones, indBotonesY+(sizeBoton*0)+5, 120, 20)).stringColor_(stringColor);
	teatrinoInfo.string="";
	teatrinoInfo.align_(\right);




	// Servos

	servosTeatrino.do{|i|
		textoServosTeatrino[i]=StaticText(ventanaTeatrino,Rect(xInTeatrino+(67*i) +x+indBotones, yInTeatrino -40 -85,60,60)).stringColor_(Color.white);
		/*textoServosTeatrino[i].string="Servo "++(i+1);
		textoServosTeatrino[i].align=\center;*/

		cuadroServosTeatrino[i]=Button(ventanaTeatrino, Rect(xInTeatrino+(70*i) +x+indBotones, yInTeatrino -85,60,60)).states=[["", stringColor, butColor]];
		cuadroServosTeatrino[i].mouseOverAction={|view,x,y| teatrinoInfo.string="Servo "++(i+1);};
		knobServosTeatrino[i]=Knob(ventanaTeatrino,Rect(xInTeatrino+(70*i)   +x+indBotones, yInTeatrino +2 -85, 60, 36));
		knobServosTeatrino[i].mouseOverAction={|view,x,y| teatrinoInfo.string="Servo "++(i+1);};
		knobServosTeatrino[i].action={|val|
			if(p!=nil,{
				if(p.isOpen,{
			valorServosTeatrino[i]=val.value.linlin(0,1.0,74,220).asInteger;
		    numeroServosTeatrino[i].value=valorServosTeatrino[i];
					p.put(valorServosTeatrino[i])})
			});

				};

		numeroServosTeatrino[i]=NumberBox(ventanaTeatrino,Rect(xInTeatrino+(70*i) +x+indBotones, cuadroServosTeatrino[i].bounds.bottom -20 , 60, 20)).align=\center;
		numeroServosTeatrino[i].background_(butColor).normalColor_(stringColor);
		numeroServosTeatrino[i].value=0;
		numeroServosTeatrino[i].mouseOverAction={|view,x,y| teatrinoInfo.string="Servo "++(i+1);};


	};

	// LEDs

ledsTeatrino.do{|i|	textoLEDsTeatrino[i]=StaticText(ventanaTeatrino,Rect(xInTeatrino+(70*i)+(70*(ledsTeatrino -1)) +x+indBotones, yInTeatrino -40 -85, 60, 60)).stringColor_(Color.white);
		/*textoLEDsTeatrino[i].string="LED "++(i+1);
		//textoLEDsTeatrino[i].font=Font("untitled-font-1", 20);
		textoLEDsTeatrino[i].align=\center;*/
		botonLEDsTeatrino[i]=Button(ventanaTeatrino, Rect(xInTeatrino+(70*i)+(70*servosTeatrino) +x+indBotones, yInTeatrino -85, 60, 60));
		botonLEDsTeatrino[i].font=Font("untitled-font-1", 32);
		botonLEDsTeatrino[i].states=[["e", stringColor, butColor],
			                         ["e", Color.white, Color.red]];
		botonLEDsTeatrino[i].action={|val| val.value.postln;};
		botonLEDsTeatrino[i].mouseOverAction={|view,x,y| teatrinoInfo.string="LED "++(i+1);};
};













	//////////////////////////////////////////
	//   OSC
	//////////////////////////////////////////



	ventanaOSC=Window("OPERA OSC", Rect((x*2)+(70*5)+57+indBotones,(ventanaSalidas.bounds.top -128),400,105), scroll: true);
	ventanaOSC.view.background_(background);
	ventanaOSC.view.deleteOnClose=false;

	logo.value(ventanaOSC);

	// Recepcion

	textoRecepcionOSC=StaticText(ventanaOSC,Rect(xInOSC+(60*0),
		                       yInOSC -24,100,50)).stringColor_(Color.white);
	textoRecepcionOSC.font=Font(size:15,bold:true);
		textoRecepcionOSC.string="Recepcion";
		//textoRecepcionOSC.align=\center;

	textoRecepcionIPOSC=StaticText(ventanaOSC,Rect(xInOSC+(60*0),
		                       yInOSC -22,120,50)).stringColor_(Color.white);
		textoRecepcionIPOSC.string="IP";
		textoRecepcionIPOSC.align=\right;

	textoRecepcionPuertoOSC=StaticText(ventanaOSC,Rect(xInOSC+(60*2),
		                       yInOSC -22,60,50)).stringColor_(Color.white);
		textoRecepcionPuertoOSC.string="Puerto";
		textoRecepcionPuertoOSC.align=\right;

	campoIPRecepcion=TextField(ventanaOSC,Rect(xInOSC+(60*0),
		yInOSC +10,120,20)).background_(butColor).stringColor_(stringColor).align_(\center);
	campoIPRecepcion.string="127.0.0.1";

	campoPuertoRecepcion=TextField(ventanaOSC,Rect(xInOSC+5+(60*2),
		yInOSC +10,60,20)).background_(butColor).stringColor_(stringColor).align_(\center);
	campoPuertoRecepcion.string=NetAddr.langPort;


	// Envio

	textoEnvioOSC=StaticText(ventanaOSC,Rect(xInOSC+(60*0),
		                       yInOSC -24+35,50,50)).stringColor_(Color.white);
	textoEnvioOSC.font=Font(size:15,bold:true);
		textoEnvioOSC.string="Envio";
		//textoEnvioOSC.align=\center;

	textoEnvioIPOSC=StaticText(ventanaOSC,Rect(xInOSC+(60*0),
		                       yInOSC -22+35,120,50)).stringColor_(Color.white);
		textoEnvioIPOSC.string="IP";
		textoEnvioIPOSC.align=\right;

	textoEnvioPuertoOSC=StaticText(ventanaOSC,Rect(xInOSC+(60*2),
		                       yInOSC -22+35,60,50)).stringColor_(Color.white);
		textoEnvioPuertoOSC.string="Puerto";
		textoEnvioPuertoOSC.align=\right;

	campoIPEnvio=TextField(ventanaOSC,Rect(xInOSC+(60*0),
		yInOSC +10+35,120,20)).background_(butColor).stringColor_(stringColor).align_(\center);
	campoIPEnvio.string=ipEnvio;
	campoIPEnvio.action={|val| ipEnvio=val.value;
		oscOpera=NetAddr(ipEnvio, puertoEnvio);
	};

	campoPuertoEnvio=TextField(ventanaOSC,Rect(xInOSC+5+(60*2),
		yInOSC +10+35,60,20)).background_(butColor).stringColor_(stringColor).align_(\center);
	campoPuertoEnvio.string=puertoEnvio;
	campoPuertoEnvio.action={|val| puertoEnvio=val.value;
		oscOpera=NetAddr(ipEnvio, puertoEnvio.asInteger);
	};



/*
// Correr este codigo para checar la comunicacion serial
~osc1=OSCresponder(nil, "/boton_0", {|...msg| msg.postln}).add;
~osc2=OSCresponder(nil, "/boton_1", {|...msg| msg.postln}).add;
~osc3=OSCresponder(nil, "/boton_2", {|...msg| msg.postln}).add;
~osc4=OSCresponder(nil, "/boton_3", {|...msg| msg.postln}).add;

*/


















/////////////////////////////////
//
//       SPOT
//
/////////////////////////////////

	offSetXSpot=170;
	offSetYSpot=100;
	spotSize=35;
	d=7;
	dSpots=spotSize+d;
	alargamiento=35;
	spotButSize = (dSpots*2 +d +(alargamiento*2))/4;



	ventanaSPOT=Window("SPOT", Rect(Window.screenBounds.width -1300 , Window.screenBounds.height -(dSpots*2 +d), 555, dSpots*2 +d + 400)).front;
	ventanaSPOT.view.background_(background);
	ventanaSPOT.view.deleteOnClose=false;



			logo.value(ventanaSPOT);


	spotsColor=Color.black!8;

	fSpots={
		ventanaSPOT.drawFunc = {

			radioSPOT = ventanaSPOT.bounds.width/16;
			/*proporcionX = 2.05/3.15;
			proporcionY = 1.3/3.15;*/
			proporcionX = 1/1.9;
			proporcionY = proporcionX;

			// Circulo grande
			Pen.color = Color.grey;
			Pen.addWedge((ventanaSPOT.bounds.width/2)@((ventanaSPOT.bounds.height/2)),ventanaSPOT.bounds.width/4, 0, 2pi);
			Pen.perform(\fill);



			// Circulo 1
			Pen.color = spotsColor[0];
			Pen.addWedge((ventanaSPOT.bounds.width/2)@((ventanaSPOT.bounds.height/2) - ((ventanaSPOT.bounds.width/4) - radioSPOT)), radioSPOT, 0, 2pi);
			Pen.perform(\fill);

			// Circulo 2
			Pen.color = spotsColor[1];
			Pen.addWedge(((ventanaSPOT.bounds.width/2) + ((ventanaSPOT.bounds.width/4)*(proporcionX)))@((ventanaSPOT.bounds.height/2) - ((ventanaSPOT.bounds.width/4)*(proporcionY))), radioSPOT, 0, 2pi);
			Pen.perform(\fill);

			// Circulo 3
			Pen.color = spotsColor[2];
			Pen.addWedge(((ventanaSPOT.bounds.width/2) + (ventanaSPOT.bounds.width/4) - radioSPOT)@((ventanaSPOT.bounds.height/2)), radioSPOT, 0, 2pi);
			Pen.perform(\fill);


			// Circulo 4
			Pen.color = spotsColor[3];
			Pen.addWedge(((ventanaSPOT.bounds.width/2) + ((ventanaSPOT.bounds.width/4)*(proporcionX)))@((ventanaSPOT.bounds.height/2) + ((ventanaSPOT.bounds.width/4)*(proporcionY))), radioSPOT, 0, 2pi);
			Pen.perform(\fill);


			// Circulo 5
			Pen.color = spotsColor[4];
			Pen.addWedge((ventanaSPOT.bounds.width/2)@((ventanaSPOT.bounds.height/2) + ((ventanaSPOT.bounds.width/4) - radioSPOT)), radioSPOT, 0, 2pi);
			Pen.perform(\fill);

			// Circulo 6
			Pen.color = spotsColor[5];
			Pen.addWedge(((ventanaSPOT.bounds.width/2) - ((ventanaSPOT.bounds.width/4)*(proporcionX)))@((ventanaSPOT.bounds.height/2) + ((ventanaSPOT.bounds.width/4)*(proporcionY))), radioSPOT, 0, 2pi);
			Pen.perform(\fill);

			// Circulo 7
			Pen.color = spotsColor[6];
			Pen.addWedge(((ventanaSPOT.bounds.width/2) - (ventanaSPOT.bounds.width/4) + radioSPOT)@((ventanaSPOT.bounds.height/2)), radioSPOT, 0, 2pi);
			Pen.perform(\fill);

			// Circulo 8
			Pen.color = spotsColor[7];
			Pen.addWedge(((ventanaSPOT.bounds.width/2) - ((ventanaSPOT.bounds.width/4)*(proporcionX)))@((ventanaSPOT.bounds.height/2) - ((ventanaSPOT.bounds.width/4)*(proporcionY))), radioSPOT, 0, 2pi);
			Pen.perform(\fill);


};

		ventanaSPOT.refresh;

	};
	fSpots.value;


	// BOTONES
	curva=((0..7)**1.5)/100;
	calibracion = 0.55;
botonesSpot=nil!8;
botonesSpot.size.do{|i|
		botonesSpot[i]=Button(ventanaSPOT, Rect(10, offSetYSpot +   (spotButSize*i) , spotButSize, spotButSize)).states=[[i+1, stringColor, butColor],[i+1, stringColor, Color.red]];
		botonesSpot[i].action={|val|
			if(val.value==1,{spotsColor[i]=Color.white},{spotsColor[i]=Color.black}); fSpots.value;
		}
	};





	textSpot=StaticText(ventanaSPOT, Rect(85,50,80,50)).stringColor_(stringColor);
	textSpot.string="SP  T";
	textSpot.font=Font("Bradley Hand",30, italic: true);


	textSpot2=StaticText(ventanaSPOT, Rect(85,48,60,50)).stringColor_(stringColor);
	textSpot2.string=   "  R" ;
	textSpot2.font=Font("Heydings Controls",30);

})
)




// =====================================================================
//
//                         Hardware Yurián Zerón
//                         Software Ernesto Romero
//
// =====================================================================

/*
Solucion de diferentes errores


////////////////////////////////////////////

Si sale el error

*** ERROR: API Version Mismatch:

Solucionarlo asi:

abrir en gedit el docuemto sources.list con la siguiente linea de codigo en una terminal:

$ sudo gedit /etc/apt/sources.list


Una vez con el documento abierto pegar al final las siguientes lineas y salvar :

deb http://ppa.launchpad.net/supercollider/ppa/ubuntu trusty main
deb-src http://ppa.launchpad.net/supercollider/ppa/ubuntu trusty main

////////////////////////////////////////////

Si al encender el servidor en SuperCollider comienza con sample Rate de 48000 ir al menù de Aplicaciones (esquina superior izq) y en Audio Production escoger la aplicacion QjackCtl

Ahi meterse a configuracion (setup) y cambiar la frecuencia de muestreo a 44100 y salvar. Reiniciar la chompu.




//////////////////

Si al iniciar el Opera aparece el error

SerialPort Error: Permiso denegadoERROR: Primitive '_SerialPort_Open' failed.
Failed.

escribir en la terminal:

sudo chmod 777 /dev/ttyUSB0
*/
