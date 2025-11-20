PROGRAM TP_n3; //ALVAREZ,Agustin Xavier - DIDOLI,Martin Angel C-111

USES crt;

TYPE 

a = array[1..2] of string;
b = array[1..2] of integer;
c = array[1..2] of boolean;

REmpresa_constructora=record
	COD_EMP:string[40];
	nombre,mail,direccion:string[40];
	tel,consultas_en_empresas:integer;
	COD_ciudad:string[3]
	end;
RCiudades=record
	COD_ciudad:string[3];
	nom_ciu:string[25];
	consultas_en_ciudad:integer
	end;
RClientes=record
	dni:integer;
	nya, mail:string[40]
	end;
RProyectos= record 
	Cod_Pry,COD_Emp:string[40];
	etapa,tipo:Char;
	COD_ciudad:string[3];
	cantidades:array [1..3] of integer
	end;	
RProductos=record
	Cod_prod,Cod_Pry:string[40];
	precio:integer;
	estado:Char;
	Detalle: string [50]
	end;

Empresa_constructora=file of REmpresa_constructora;
Ciudades=file of RCiudades;
Clientes=file of RClientes;
Proyectos=file of RProyectos;
Productos=file of RProductos;



VAR 
	contrasenha,bandera_programa:boolean;
	opcion:integer;
	clave: a;
	contador: b;
	banderas: c;
	R_emp:REmpresa_constructora;
	auxR_emp:REmpresa_constructora; 
	l_emp:Empresa_constructora;
	R_ciu:RCiudades;
	auxR_ciu: RCiudades;
	l_ciu:Ciudades;
	R_cli:RClientes;
	auxR_cli:RClientes;
	l_cli:Clientes;
	R_proy:RProyectos;
	auxR_proy:RProyectos;
	l_proy:Proyectos;
	R_prod:RProductos;
	auxR_prod:RProductos;
	l_prod:Productos;

FUNCTION mayuscula(s:String):String;
var
	i:integer;
begin
	for i:=1 to length(s) do s[i]:=Upcase(s[i]);
	mayuscula := s;
end;

FUNCTION chequeo_cod_pry(s:string):integer;

begin
	if filesize(l_proy)=0 then
	begin
	chequeo_cod_pry:=0;
	end
	else
	begin
	seek(l_proy,0);
	repeat
		read(l_proy,r_proy);
	until(s=r_proy.cod_pry)or(EOF(l_proy)=true);
	if (EOF(l_proy)=true) then chequeo_cod_pry:=filepos(l_proy);
	if (s=r_proy.cod_pry) then chequeo_cod_pry:=filepos(l_proy)-1;
	end;
end;

FUNCTION Chequeo_ciu(s:string[3]):integer; 

begin
	if filesize(l_ciu)=0 then
	begin
	chequeo_ciu:=0;
	end
	else
	begin
	seek(l_ciu,0);
	repeat 
		read(l_ciu,R_ciu);
	until(s=R_ciu.COD_ciudad) or (EOF(l_ciu)=true);
	if (EOF(l_ciu)=true) then chequeo_ciu:=filesize(l_ciu);
	if (s=R_ciu.COD_ciudad) then chequeo_ciu:=filepos(l_ciu)-1;
	end;
end;	

Function Chequeo_cod_prod(s:string):integer;

begin
	if filesize(l_prod)=0 then
	begin
	chequeo_cod_prod:=0;
	end
	else
	begin
	seek(l_prod,0);
	repeat
		read(l_prod,r_prod);
	until (s=r_prod.COD_prod) or (EOF(l_prod)=true);
	if (EOF(l_prod)=true) then Chequeo_cod_prod:=filepos(l_prod);
	if (s=r_prod.COD_prod) then Chequeo_cod_prod:=filepos(l_prod)-1;
	end;
end;

Function Chequeo_cod_emp(s:string):integer;

begin
	if filesize(l_emp)=0 then
	begin
	chequeo_cod_emp:=0;
	end
	else
	begin
	seek(l_emp,0);
	repeat
		read(l_emp,r_emp);
	until (s=R_emp.COD_EMP) or (EOF(l_emp)=true);
	if (EOF(l_emp)=true) then Chequeo_cod_emp:=filepos(l_emp);
	if (s=R_emp.COD_EMP) then Chequeo_cod_emp:=filepos(l_emp)-1;
	end;
end;

function Chequear_direc_emp(s:string):integer;

begin
	if filesize(l_emp)=0 then
	begin
	chequear_direc_emp:=0;
	end
	else
	begin
	seek(l_emp,0);
	repeat
		read(l_emp,r_emp);
	until (s=R_emp.direccion) or (EOF(l_emp)=true);
	if (EOF(l_emp)=true) then chequear_direc_emp:=filepos(l_emp);
	if (s=R_emp.direccion) then chequear_direc_emp:=filepos(l_emp)-1;
	end;
end;

function Chequeo_mail(s:string):integer;

begin
	if filesize(l_emp)=0 then
	begin
	chequeo_mail:=0;
	end
	else
	begin
	seek(l_emp,0);
	repeat
		read(l_emp,r_emp);
	until (s=R_emp.mail) or (EOF(l_emp)=true);
	if (EOF(l_emp)=true) then chequeo_mail:=filepos(l_emp);
	if (s=R_emp.mail) then chequeo_mail:=filepos(l_emp)-1;
	end;
end;

function Chequeo_tel(s:integer):integer;

begin
	if filesize(l_emp)=0 then
	begin
	chequeo_tel:=0;
	end
	else
	begin
	seek(l_emp,0);
	repeat
		read(l_emp,r_emp);
	until (s=R_emp.tel) or (EOF(l_emp)=true);
	if (EOF(l_emp)=true) then chequeo_tel:=filepos(l_emp);
	if (s=R_emp.tel) then chequeo_tel:=filepos(l_emp)-1;
	end;
end;

Procedure alta_CIUDADES;

var 
	opcion,puntero:integer;
	auxmayus,auxciu:string[3];
begin	
	writeln('-- Alta de CIUDADES --');
	repeat
		writeln('Ingrese el COD de Ciudad(3 letras):');
		readln(auxciu);
		repeat
		auxmayus:=mayuscula(auxciu);
		puntero:=chequeo_ciu(auxmayus);
		if puntero = filesize(l_ciu) then
			begin
			seek(l_ciu,filesize(l_ciu));
			R_ciu.COD_ciudad:=auxmayus;
			end
			else
			begin
			writeln('El codigo de ciudad ingresado ya existe. Ingrese otro: ');
			readln(auxciu);
			end;
		until(puntero = filesize(l_ciu));
		writeln('Ingrese el nombre de la ciudad:');
		readln(R_ciu.nom_ciu);
		r_ciu.consultas_en_ciudad:=0;
		write(l_ciu,R_ciu);
		writeln('Desea agregar una ciudad mas? 1.Si 0.No: ');
		readln(opcion);
		if opcion = 1 then clrscr;
		while (opcion > 1) and (opcion < 0) do
			begin
			writeln('Caracter invalido, desea agregar una ciudad mas? 1.Si 0.No: ');
			readln(opcion);
			if opcion = 1 then clrscr;
			end;	
	until (opcion = 0);
end;

Procedure EMPRESA;

VAR 
	puntero,opcion:integer;
	auxmayus:string;

begin
	if (filesize(l_ciu)=0) then
	begin
	writeln('Necesita cargar al menos una ciudad para dar de alta una empresa.');
	end
	else 
	begin
		writeln('-- Alta de EMPRESA --');
		repeat 
			writeln('Ingrese el COD de la Empresa :');
			readln(auxR_emp.COD_EMP);
			repeat
			puntero:=Chequeo_cod_emp(auxR_emp.COD_EMP);
			if puntero <> filesize(l_emp) then
				begin
				writeln('El codigo de empresa ingresado ya existe. Ingrese otro: ');
				readln(auxR_emp.COD_EMP);
				end;
			until (puntero = filesize(l_emp));
			writeln('Ingrese el nombre de la Empresa:');
			readln(auxR_emp.nombre);
			writeln('Ingrese la direccion de la Empresa:');
			readln(auxR_emp.direccion);
			repeat
			puntero:=chequear_direc_emp(auxr_emp.direccion);
			if puntero <> filesize(l_emp) then
				begin
				writeln('La direccion de empresa ingresada ya existe. Ingrese otra: ');
				readln(auxR_emp.direccion);
				end;
			until (puntero = filesize(l_emp));		
			writeln('Ingrese el mail de la empresa:');
			readln(auxR_emp.mail);
			repeat
			puntero:=Chequeo_mail(auxR_emp.mail);
			if puntero <> filesize(l_emp) then
				begin
				writeln('El mail de empresa ingresado ya existe. Ingrese otro: ');
				readln(auxR_emp.mail);
				end;
			until (puntero = filesize(l_emp));
			writeln('Ingrese el telefono de la Empresa: ');
			readln(auxR_emp.tel);
			repeat
			puntero:=Chequeo_tel(auxR_emp.tel);
			if puntero <> filesize(l_emp) then
				begin
				writeln('El telefono de empresa ingresado ya existe. Ingrese otro: ');
				readln(auxR_emp.tel);
				end;
			until (puntero = filesize(l_emp));
			writeln('ingrese el COD de ciudad:');
			readln(auxmayus);
			repeat
				auxr_emp.Cod_ciudad:=mayuscula(auxmayus);
				puntero:=Chequeo_ciu(auxR_emp.cod_ciudad);
				if puntero = filesize(l_ciu) then
					begin
					writeln('El codigo de ciudad ingresado no existe. Ingrese otro: ');
					readln(auxmayus);
					end;	
			until (puntero <> filesize(l_ciu));
			seek(l_emp,filesize(l_emp));
			r_emp.COD_emp:=auxR_emp.COD_EMP;
			r_emp.nombre:=auxR_emp.nombre;
			r_emp.direccion:=auxR_emp.direccion;
			r_emp.mail:=auxR_emp.mail;
			r_emp.tel:=auxR_emp.tel;
			r_emp.COD_ciudad:=auxR_emp.COD_ciudad;
			r_emp.consultas_en_empresas:=0;
			write(l_emp, r_emp);
			writeln('Desea agregar una Empresa mas? 1.Si 0.No ');
			readln(opcion);
			if opcion = 1 then clrscr;
			while (opcion > 1) and (opcion < 0) do
				begin
				writeln('Caracter invalido, desea agregar una empresa mas? 1.Si 0.No: ');
				readln(opcion);
				if opcion = 1 then clrscr;
				end;	
		until (opcion = 0);
	end;	
end;

PROCEDURE alta_Proyectos;

var
	opcion,puntero: integer;
	auxmayus:string;

begin
	if (filesize(l_emp)=0) then
	writeln('Necesita cargar al menos una empresa para dar de alta un proyecto.') 
	else
	begin
		writeln('-- Alta de PROYECTOS --');
		repeat
			writeln('Ingrese el codigo del proyecto: ');
			readln(auxr_proy.cod_pry);
			repeat
			puntero:=chequeo_cod_pry(auxr_proy.cod_pry);
			if puntero <> filesize(l_proy) then
				begin
				writeln('El codigo de proyecto ya existe. Ingrese otro: ');
				readln(auxr_proy.cod_pry);
				end;
			until (puntero = filesize(l_proy));
			writeln('Ingrese el codigo de la empresa del proyecto: ');
			readln(auxr_proy.cod_Emp);
			repeat
			puntero:=Chequeo_cod_emp(auxR_proy.COD_EMP);
			if puntero = filesize(l_emp) then
				begin
				writeln('El codigo de empresa ingresado no existe. Ingrese otro: ');
				readln(auxR_proy.COD_EMP);
				end;
			until (puntero <> filesize(l_emp));
			writeln('Ingrese la etapa del proyecto');
			writeln('P - O - T (preventa - obra - terminado ): ');
			readln(auxr_proy.etapa);
			while (auxr_proy.etapa <> 'P') and (auxr_proy.etapa <> 'O') and (auxr_proy.etapa <> 'T') do
			begin
				writeln('Ha ingresado un caracter erroneo. Por favor, ingrese uno nuevamente');
				writeln('P - O - T (preventa - obra - terminado ): ');
				readln(auxr_proy.etapa);
			end;
			writeln('Ingrese el tipo de proyecto');
			writeln(' C - D - O - L (casa - edificio departamento - edificio oficina - loteos ): ');
			readln(auxr_proy.tipo);
			while (auxr_proy.tipo <> 'C') and (auxr_proy.tipo <> 'D') and (auxr_proy.tipo <> 'O') and (auxr_proy.tipo <> 'L') do
			begin
				writeln('Ha ingresado un tipo erronea, Por favor indique un tipo correcto:');
				writeln(' C - D - O - L (casa - edificio departamento - edificio oficina - loteos ):');
				readln(auxr_proy.tipo);
			end;
			writeln('Ingrese el codigo de ciudad del proyecto');
			readln(auxmayus);
			repeat
				auxr_proy.Cod_ciudad:=mayuscula(auxmayus);
				puntero:=Chequeo_ciu(auxR_proy.cod_ciudad);
				if puntero = filesize(l_ciu) then
					begin
						writeln('El codigo de ciudad ingresado no existe. Ingrese otro: ');
						readln(auxmayus);
					end;	
			until (puntero <> filesize(l_ciu));
			writeln('Ingrese la cantidad de productos que posee el proyecto: ');
			readln(auxr_proy.cantidades[1]);
			while auxr_proy.cantidades[1] = 0 do
				begin
				writeln('La cantidad de productos que debe poseer el proyecto debe ser mayor a 0. Ingrese otra cantidad: ');
				readln(auxr_proy.cantidades[1]);
				end;
			auxr_proy.cantidades[2]:=0;
			auxr_proy.cantidades[3]:=0;
			seek(l_proy,filesize(l_proy));
			r_proy.Cod_Pry:=auxR_proy.COD_pry;
			r_proy.cod_Emp:=auxR_proy.cod_Emp;
			r_proy.etapa:=auxR_proy.etapa;
			r_proy.tipo:=auxR_proy.tipo;
			r_proy.COD_ciudad:=auxR_proy.COD_ciudad;
			r_proy.cantidades:=auxR_proy.cantidades;
			write(l_proy, r_proy);
			writeln('Desea agregar un proyecto mas? 1.Si 0.No ');
			readln(opcion);
			if opcion = 1 then clrscr;
			while (opcion > 1) and (opcion < 0) do
				begin
				writeln('Caracter invalido, desea agregar un proyecto mas? 1.Si 0.No: ');
				readln(opcion);
				if opcion = 1 then clrscr;
				end;
		until (opcion = 0);
	end;	
end;

FUNCTION busq_prod(s:string):integer;

begin
	if filesize(l_prod)=0 then
	begin
	busq_prod:=0;
	end
	else
	begin
	busq_prod:=0;
	seek(l_prod,0);
	repeat 
		read(l_prod,r_prod);
		if s=r_prod.cod_pry then
			begin
			busq_prod:=busq_prod+1;
			end;
	until (EOF(l_prod)=true);
	end;
end;


PROCEDURE alta_PRODUCTOS;

var
	opcion,puntero,limite,cant_actual: integer;

begin
	if (filesize(l_proy)=0) then
	begin
	writeln('Necesita cargar al menos un proyecto, para dar de alta un producto.');
	end
	else
	begin 
	writeln('-- Alta de PRODUCTOS --');
	repeat
		writeln('Ingrese el codigo del producto: ');
		readln(auxr_prod.cod_prod);
		repeat
			puntero:=chequeo_cod_prod(auxr_prod.cod_prod);
			if puntero <> filesize(l_prod) then
			begin
				writeln('El codigo de producto ya existe. Ingrese otro valido: ');
				readln(auxr_prod.cod_prod);
			end;
		until (puntero = filesize(l_prod));
		writeln('Ingrese el codigo del proyecto: ');
		readln(auxr_prod.cod_pry);
		repeat
			puntero:=chequeo_cod_pry(auxr_prod.cod_pry);
			if puntero = filesize(l_proy) then
			begin
				writeln('El codigo de proyecto no existe. Ingrese otro valido: ');
				readln(auxr_prod.cod_pry);
			end;
			if puntero <> filesize(l_proy) then
				begin
				seek(l_proy,puntero);
				read(l_proy,r_proy);
				limite:= r_proy.cantidades[1];
				cant_actual:=busq_prod(r_proy.cod_pry);
				if cant_actual = limite then
					begin
					writeln('Ha alcanzado el limite de productos para este proyecto.');
					end;
				end;
		until (puntero <> filesize(l_proy));
		if limite <> cant_actual then
			begin
			writeln('Ingrese el Precio del producto: ');
			readln(auxr_prod.precio);
			auxr_prod.estado:='N';
			writeln('Ingrese el Detalle del producto: ');
			readln(auxr_prod.detalle);
			r_prod.cod_prod:=auxr_prod.cod_prod;
			r_prod.cod_pry:=auxr_prod.cod_pry;
			r_prod.precio:=auxr_prod.precio;
			r_prod.estado:=auxr_prod.estado;
			r_prod.detalle:=auxr_prod.detalle;
			seek(l_prod,filesize(l_prod));
			write(l_prod,r_prod);
			end;
		writeln('Desea agregar un producto mas? 1.Si 0.No: ');
			readln(opcion);
			if opcion = 1 then clrscr;
			while (opcion > 1) and (opcion < 0) do
				begin
				writeln('Caracter invalido, desea agregar un producto mas? 1.Si 0.No: ');
				readln(opcion);
				if opcion = 1 then clrscr;
				end;
	until (opcion = 0);	
	end;
end;

function chequeo_mas_emp():string;

var
i,conta,mayor: integer;
auxcodciu,mayorciu: string[3];

begin
	mayor:=0;
	for i:= 0 to filesize(l_ciu)-1 do
		begin
		conta:=0;
		seek(l_ciu,i);
		read(l_ciu,r_ciu);
		auxcodciu:=r_ciu.cod_ciudad;
		seek(l_emp,0);
		repeat
		read(l_emp,r_emp);
		if auxcodciu=r_emp.cod_ciudad then
			conta:= conta+1;
		until(eof(l_emp)=true);
		if conta > mayor then
			begin
			mayor:=conta;
			mayorciu:=auxcodciu;
			end;
		end;
	chequeo_mas_emp:=mayorciu;
end;

PROCEDURE ordenar_ciudades;

var
	i,j:integer;
begin
	for i:= 0 to filesize(l_ciu)-2 do
		for j:=(i + 1) to filesize(l_ciu)-1 do
			begin
			seek(l_ciu,i);
			read(l_ciu,r_ciu);
			seek(l_ciu,j);
			read(l_ciu,auxR_ciu);
			if(r_ciu.COD_ciudad > auxR_ciu.COD_ciudad) then
			begin
				seek(l_ciu,i);
				write(l_ciu,auxr_ciu);
				seek(l_ciu,j);
				write(l_ciu, r_ciu);
			end;
			end;
end;

PROCEDURE ESTADISTICA;

var
i,j: integer;
mayor,ciud: string;

begin
	if filesize(l_emp) = 0 then 
	begin
	writeln('No se han cargado empresas todavia.');
	end
	else
	begin
	writeln('Las empresas cuyas consultas fueron mayores a 10 son: ');
	seek(l_emp,0);
	i:=0;
	repeat
	read(l_emp,r_emp);
	if r_emp.consultas_en_empresas > 10 then
		writeln(r_emp.nombre);
		i:=i+1;
	until (eof(l_emp)=true);
	if i = 0 then writeln('No hay empresas con mas de 10 consultas.');
	end;
	if filesize(l_ciu)=0 then
		begin
		writeln('No se han cargado ciudades todavia.');
		end
		else
		begin
		writeln('La ciudad con mas consultas de proyectos es: ');
		seek(l_ciu,0);
		i:=0;
		repeat
		read(l_ciu,r_ciu);
			if r_ciu.consultas_en_ciudad > i then
				begin
				i:= r_ciu.consultas_en_ciudad;
				mayor:= r_ciu.nom_ciu;
				ciud:= r_ciu.cod_ciudad;
				end;
		until(eof(l_ciu)=true);
		if i <> 0 then
			begin
			writeln(mayor,' de codigo ',ciud,' con ',i,' consultas.');
			end
			else
			begin
			writeln('Todavia no se han realizado consultas.');
			end;
		end;
	if filesize(l_proy)=0 then
		begin
		writeln('Todavia no se han cargado proyectos.');
		end
		else
		begin
		writeln('Los proyectos con todas las unidades vendidas son: ');
		j:=0;
		for i:= 0 to filesize(l_proy)-1 do
			begin
			seek(l_proy,i);
			read(l_proy,r_proy);
			if r_proy.cantidades[3] = r_proy.cantidades[1] then
				begin
				j:= j+1;
				writeln(r_proy.cod_pry);
				end;
			end;
		if j = 0 then writeln('No se han encontrado proyectos con todas las unidades vendidas.');
		end;
		writeln('presione cualquier tecla para Salir de ESTADISTICAS');
		ReadKey();
end;

procedure menuempresa ();

var

mas_empresas:string[3];
opcion:integer;

begin
	repeat
	clrscr;
		writeln('');
		writeln('MENU EMPRESAS DESARROLLADORAS');
		writeln('1.Alta de CIUDADES');
		writeln('2.Alta de EMPRESAS');
		writeln('3.Alta de PROYECTOS');
		writeln('4.Alta de PRODUCTOS');
		writeln('5.ESTADISTICA');
		writeln('0.Volver al menu principal');
		readln(opcion);
		while (opcion < 0) or (opcion > 5) do
		begin
			writeln('Ingrese una opcion valida: ');
			readln(opcion);
		end;
		if (opcion = 1) then alta_CIUDADES;
		if (opcion = 2) then EMPRESA;
		if (opcion = 3) then alta_PROYECTOS;
		if (opcion = 4) then alta_PRODUCTOS;
		if (opcion = 5) then ESTADISTICA; //te tira 10 proyectos de una empresa = 1 consulta para esa empresa
	until (opcion = 0);
	if filesize(l_ciu) > 0 then ordenar_ciudades;
	if filesize(l_emp) > 0 then 
		begin
		mas_empresas:=chequeo_mas_emp();
		writeln('El codigo de la ciudad con mas empresas registradas es ',mas_empresas);
		end;

end;


procedure consulta_proyectos();

Var
tipo_consulta: Char;
conta,n_ciu,n_emp,puntero: integer;
proy_ver: string[40];

begin
	if filesize(l_proy) = 0 then
	begin
	writeln('No hay ningun proyecto cargado todavia.');
	end
	else
	begin
	conta:= 0;
	writeln('Que tipo de proyecto desea conocer?(C-D-O-L): ');
	readln(tipo_consulta);
	while (tipo_consulta <> 'C') and (tipo_consulta <> 'D') and (tipo_consulta <> 'O') and (tipo_consulta <> 'L') do
		begin
		writeln('El tipo de proyecto ingresado no corresponde. Ingrese uno de vuelta (C-D-O-L): ');
		readln(tipo_consulta);
		end;
	seek(l_proy,0);
	while not (eof(l_proy)) do
		begin
		read(l_proy,r_proy);
		if (tipo_consulta = r_proy.tipo) and (r_proy.cantidades[1] <> r_proy.cantidades[3]) then
			begin
			conta:= conta+1;
			writeln('');
			writeln('Proyecto: ', r_proy.cod_pry); 
			case r_proy.tipo of
				'P': writeln('Etapa: Preventa');
				'O': writeln('Etapa: Obra');
				'T': writeln('Etapa: Terminado');
				end;
			seek(l_emp,0);
			repeat
			read(l_emp,r_emp);
			until (r_emp.cod_emp = r_proy.cod_emp);
			writeln('Pertenece a la empresa: ', r_emp.nombre);
			seek(l_ciu,0);
			repeat
			read(l_ciu,r_ciu);
			until (r_ciu.cod_ciudad = r_proy.cod_ciudad);
			writeln('Se encuentra en la ciudad: ',r_ciu.nom_ciu );
			end;
		end;
	if conta = 0 then
		begin
		writeln('No se han encontrado proyectos de ese tipo');
		end
		else
		begin
		writeln('Ingrese el codigo del proyecto que desea ver: ');
		readln(proy_ver);
		repeat
		puntero:=chequeo_cod_pry(proy_ver);
		if puntero = filesize(l_proy) then
			begin
			writeln('El codigo de proyecto ingresado no existe. Ingrese otro: ');
			readln(proy_ver);
			end;
		until (puntero <> filesize(l_proy));
		seek(l_proy,puntero);
		read(l_proy,r_proy);
		r_proy.cantidades[2]:=r_proy.cantidades[2] + 1;
		n_ciu:=chequeo_ciu(r_proy.cod_ciudad);
		seek(l_ciu,n_ciu);
		read(l_ciu,r_ciu);
		r_ciu.consultas_en_ciudad:= r_ciu.consultas_en_ciudad+1;
		n_emp:=chequeo_cod_emp(r_proy.cod_emp);
		seek(l_emp,n_emp);
		read(l_emp,r_emp);
		r_emp.consultas_en_empresas:=r_emp.consultas_en_empresas+1;
		seek(l_proy,puntero);
		seek(l_ciu,n_ciu);
		seek(l_emp,n_emp);
		write(l_emp,r_emp);
		write(l_ciu,r_ciu);
		write(l_proy,r_proy);
		seek(l_prod,0);
		while not(eof(l_prod)=true) do
			begin
			read(l_prod,r_prod);
			if (r_prod.cod_pry = proy_ver) and (r_prod.estado = 'N') then
				begin
				writeln('');
				writeln('Codigo de producto: ',r_prod.cod_prod);
				writeln('Precio: ',r_prod.precio);
				writeln('Detalle: ',r_prod.detalle);
				end;
			end;
		end;
	writeln('Quiere consultar mas proyectos? 1.Si 0.No: ');
	readln(conta);
	if conta = 1 then clrscr;
	while (conta > 1) and (conta < 0) do
		begin
			writeln('Caracter invalido, desea agregar un producto mas? 1.Si 0.No: ');
			readln(conta);
			if conta = 1 then clrscr;
		end;
	clrscr;
	if conta = 1 then consulta_proyectos;
	end;
end;

Procedure Compra_prod();

VAR
	opc,puntero:integer;
	aux_cod:string[40];

begin
	if filesize(l_prod)=0 then
	begin
	writeln('No hay productos cargados');
	readkey();
	end
	else
	begin
	writeln('Ingrese el codigo del producto que desea comprar: ');
	readln(aux_cod);
	repeat
		puntero:=chequeo_cod_prod(aux_cod);
		if puntero = filesize(l_prod) then
		begin
			writeln('El codigo ingresado no corresponde a ningun producto. Ingrese otro valido: ');
			readln(aux_cod);
		end;
	until (puntero <> filesize(l_prod));
	seek(l_prod,puntero);
	read(l_prod,r_prod);
	if (r_prod.estado='N') then 
	begin
		writeln('El precio del producto ',aux_cod,' es: ',r_prod.precio);
		writeln('Quiere Confirmar la compra? "S". Si "N". No: ');
		readln(r_prod.estado);
		while (r_prod.estado <> 'S') and (r_prod.estado <> 'N')do
			begin
			writeln('El caracter ingresado no corresponde. Ingrese otro valido: ');
			readln(r_prod.estado);
			end; 
		seek(l_prod,puntero);
		write(l_prod,r_prod);
		if (r_prod.estado='S') then
		begin
			writeln('La venta le llegara al mail:',auxr_cli.mail);
			seek(l_proy,0);
			repeat
				read(l_proy,r_proy);
			until(r_proy.cod_pry=r_prod.cod_pry);
			r_proy.cantidades[3]:=r_proy.cantidades[3]+1;
			seek(l_proy,filepos(l_proy)-1);
			write(l_proy,r_proy);
		end;	 
	end
	else
	begin
		writeln('El producto con el codigo:',aux_cod,'ya fue vendido.');
	end;
	writeln('Desea comprar otro producto? 1.Si 0.No: ');
	readln(opc);
	if opc = 1 then clrscr;
	while (opc > 1) and (opc < 0) do
		begin
			writeln('Caracter invalido, desea agregar un producto mas? 1.Si 0.No: ');
			readln(opc);
			if opc = 1 then clrscr;
		end;
	if (opc=1) then compra_prod;
	end;
end;

function Chequeo_doc(s:integer):integer;

begin
	if filesize(l_cli)=0 then
		begin
		chequeo_doc:=0;
		end
		else
		begin
		seek(l_cli,0);
		repeat
			read(l_cli,r_cli);
		until (s=r_cli.dni) or (EOF(l_cli)=true);
		if (EOF(l_cli)=true) then chequeo_doc:=filepos(l_cli);
		if (s=r_cli.dni) then chequeo_doc:=filepos(l_cli)-1;
		end;
end;

function Chequeo_mail_CLI(s:string):integer;

begin
	if filesize(l_cli)=0 then
		begin
		chequeo_mail_CLI:=0;
		end
		else
		begin
		seek(l_cli,0);
		repeat
			read(l_cli,r_cli);
		until (s=R_cli.mail) or (EOF(l_cli)=true);
		if (EOF(l_cli)=true) then chequeo_mail_cli:=filepos(l_cli);
		if (s=R_cli.mail) then chequeo_mail_cli:=filepos(l_cli)-1;
		end;
end;


Procedure alta_Clientes;

var 
	puntero,puntero2, opc:integer;
	mailconf:string[40];

begin
	writeln('Bienvenido al Alta de cliente:');
	if filesize(l_cli) > 0 then
		begin 
		writeln('Si ya esta Dado de alta ingrese "1", de lo contrario ingrese "0": ');
		readln(opc);
		end
		else
		begin
		opc:=0;
		end;
	if (opc = 0) then
	begin
		writeln('--Ingrese los datos para el Alta--');
		repeat
			writeln('Ingrese el Dni: ');
			readln(auxR_cli.Dni);
			repeat
				puntero:=chequeo_doc(auxR_cli.Dni);
				if puntero <> filesize(l_cli) then
				begin
					writeln('El Dni ingresado ya pertenece a otro cliente. Ingrese otro valido: ');
					readln(auxR_cli.Dni);
				end;
			until (puntero = filesize(l_cli));
			writeln('Ingrese Nombre y Apellido: ');
			readln(auxr_cli.nya);	
			writeln('Ingrese su mail: ');
			readln(auxr_cli.mail);
			repeat
				puntero:=Chequeo_mail_CLI(auxr_cli.mail);
				if puntero <> filesize(l_cli) then
				begin
					writeln('El mail ingresado ya pertenece a otro cliente. Ingrese otro valido: ');
					readln(auxR_cli.mail);
				end;
			until (puntero = filesize(l_cli));
			writeln('Confirme el mail: ');
			readln(mailconf);
			while (auxr_cli.mail <> mailconf) do
			begin
				writeln('El mail ingresado no coincide');
				writeln('Ingreselo nuevamente:');
				readln(mailconf);
			end;
			clrscr;
			R_cli.Dni:=auxr_cli.dni;
			R_cli.nya:=auxr_cli.nya;
			r_cli.mail:=auxr_cli.mail;
			seek(l_cli,filesize(l_cli));
			write(l_cli,r_cli);
			writeln('Desea agregar un cliente mas? 1.Si 0.No: ');
			readln(opcion);
			if opcion = 1 then clrscr;
			if (opcion > 1) or (opcion < 0) then
			begin
				repeat
					writeln('Caracter invalido, desea agregar un cliente mas? 1.Si 0.No: ');
					readln(opcion);
					if opcion = 1 then clrscr;
				until (opcion = 0) or (opcion = 1);
			end;
		until(opcion = 0 );
		writeln('Quiere iniciar sesion de clientes? 1.Si 0.No: ');
		readln(opc);
		if opc = 1 then clrscr;
		if (opc>1) or (opc<0) then
			begin
				repeat
				writeln('Caracter invalido, ingrese un caracter valido 1.Si 0.No: ');
				readln(opc);
				if opcion = 1 then clrscr;
				until(opc=1) or (opc=0);
			end;
	end;
	if (opc = 1) then
	begin
		writeln('Ingrese el Dni:');
		readln(auxr_cli.dni);
		repeat
			puntero:=chequeo_doc(auxR_cli.Dni);
			if puntero = filesize(l_cli) then
			begin
				writeln('El Dni ingresado no pertenece a ningun cliente. Ingrese otro valido: ');
				readln(auxR_cli.Dni);
			end;
		until (puntero <> filesize(l_cli));
		writeln('Ingrese el Mail:');
		readln(auxr_cli.mail);
		repeat
			puntero2:=Chequeo_mail_CLI(auxr_cli.mail);
			if puntero2 <> puntero then
			begin
				writeln('El mail ingresado no corresponde la DNI. Pruebe de nuevo: ');
				readln(auxR_cli.mail);
			end;
		until (puntero = puntero2);
		seek(l_cli,puntero);
		read(l_cli,r_cli);
		repeat
			clrscr;
			writeln('Bienvenido ',r_cli.nya);
			writeln('1.Consulta Proyecto');
			writeln('2.Comprar producto');
			writeln('0.Salir');
			readln(opcion);
			while (opcion < 0) or (opcion > 2) do
			begin
				writeln('Ingrese una opcion valida:');
				readln(opcion);
			end;
			if (opcion = 1) then Consulta_proyectos;
			if (opcion = 2) then Compra_prod;
		until (opcion = 0);
	end; 
end;

procedure menucliente ();

begin
	repeat
	clrscr;
		writeln('');
		writeln('MENU CLIENTES');
		writeln('1.Alta De Clientes');
		writeln('0.Volver al menu principal');
		readln(opcion);
		while (opcion < 0) or (opcion > 1) do
		begin
			writeln('Ingrese una opcion valida:');
			readln(opcion);
		end;
		if (opcion = 1) then alta_CLIENTES;
	until (opcion = 0);
end;

PROCEDURE Validar_contrasenha();
var
	Asterisco: char;
	contra: string;
BEGIN
    clave[1]:='Clave123';
    clave[2]:='Clave321';
    contador[1]:=0;
    contador[2]:=0;
	if banderas[1] = true then
		if banderas[2] <> true then
			begin
			while (opcion <> 2) and (opcion <> 0) do
				begin
				writeln('Ha excedido el numero de intentos en Empresas, pruebe 2.Clientes o 0.Salir:');
				readln(opcion);
				end;
			end	
			else
			begin
			writeln('Ha excedido el numero de intentos en Empresas y en Clientes, El programa se cerrara');
			bandera_programa:= true;
			opcion := 4;
			banderas[1] := false;
			banderas[2] := false;
			end;
	if banderas[2] = True then
		while (opcion <> 1) and (opcion <> 0) do
			begin
			writeln('Ha excedido el numero de intentos en Clientes, pruebe 1.Empresas o 0.Salir:');
			readln(opcion);
			end;	
	if opcion = 1 then writeln('Ingrese la Contrasena de Empresas:');
	if opcion = 2 then writeln('Ingrese la Contrasena de Clientes:');
	if opcion = 0 then bandera_programa := true;
	if bandera_programa = false then
		begin
		write('');
		contra := '';
		Repeat
			Asterisco := ReadKey;
			If Asterisco <> #13 then
				begin
			    Write ('*');
			    contra:= contra + Asterisco;
				end;
		Until Asterisco = #13;
		if contra <> clave[opcion] then
			begin 
			while contador[opcion] <> 3 do
				begin
				contador[opcion]:=contador[opcion] + 1;
			    writeln('');
				writeln('Clave incorrecta. Ingrese otra: ');
				contra:= '';
				Repeat
					Asterisco:= ReadKey;
					If Asterisco <> #13 then
					Begin
					   Write ('*');
					   contra:=contra + Asterisco;
			  	   end;
				Until Asterisco = #13;
				if contra = clave[opcion] then
		        	begin
					contador[opcion]:=3;
	            	writeln('');
	            	writeln('Contrasena correcta');   
	            	writeln('');           
	            	contrasenha:=true;
		        	end;
				end;
			end
			else
			begin
			contrasenha:=true;
			end;
		if (contador[opcion] = 3) and (contra <> clave[opcion]) then
			begin
	        writeln('');
	        if opcion = 1 then
	        	begin
	        	writeln('Se ha excedido el limite de intentos para la contrasena de Empresa');
	        	writeln('');
	        	end;
	        if opcion = 2 then
	        	begin
	        	writeln('Se ha excedido el limite de intentos para la contrasena de Clientes');
	        	writeln('');
	        	end;
	        banderas[opcion] := true;
			end;
		end;
END;



PROCEDURE Menu(var opcion:integer);	
BEGIN
	writeln('MENU PRINCIPAL');
    writeln('');
	writeln('1.Empresa');
	writeln('2.Clientes');
	writeln('0.Salir');
    writeln('');
    write('Ingrese el numero de la opcion a la cual quiere ingresar: ');
	readln(opcion);
	while (opcion < 0) or (opcion > 2) do
		begin
		write('Ingrese una opcion valida:');
		write('');
		readln(opcion);
		end;
	writeln('');

END;

PROCEDURE asignar_global();

BEGIN
	assign(l_emp,'c:\TP3\EMPRESAS-CONSTRUCTORAS.DAT');
	{$i-}
	reset(l_emp);
	if ioresult=2 then rewrite (l_emp);
	{$i+}	
	assign(l_ciu,'c:\TP3\CIUDADES.DAT');
	{$i-}
	reset(l_ciu);
	if ioresult=2 then rewrite (l_ciu);
	{$i+}	
	assign(l_cli,'c:\TP3\CLIENTES.DAT');
	{$i-}
	reset(l_cli);
	if ioresult=2 then rewrite (l_cli);
	{$i+}	
	assign(l_proy,'c:\TP3\PROYECTOS.DAT');
	{$i-}
	reset(l_proy);
	if ioresult=2 then rewrite (l_proy);
	{$i+}	
	assign(l_prod,'c:\TP3\PRODUCTOS.DAT');
	{$i-}
	reset(l_prod);
	if ioresult=2 then rewrite (l_prod);
	{$i+}	
END;

Procedure cerrar();

begin
    close(l_ciu);
    close(l_emp);
    close(l_cli);
    close(l_proy);
    close(l_prod);
end;


BEGIN
	asignar_global();
	bandera_programa := false;
	banderas[1] := false;
	banderas[2] := false;
	contrasenha := false;
	writeln('Bienvenido');
    writeln('');
	while bandera_programa = false do 
		begin
		Menu(opcion);
		clrscr;
		if opcion = 0 then bandera_programa:=true;
		clrscr;
        if (bandera_programa = false) and (opcion >= 1) and (opcion <= 2) then Validar_contrasenha;
		if (opcion = 1) and (contrasenha = true) and (banderas[1]=false) then menuempresa;
		if (opcion = 2) and  (contrasenha = true) and (banderas[2]=false)  then  menucliente;
		end;
	writeln('El programa se va a cerrar, presione cualquier tecla para finalizar.');	
	cerrar();
	readkey();
END.			
