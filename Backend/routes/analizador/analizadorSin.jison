%lex
 %options case-insensitive
 %%
\s+                   {/**/}

"//".*                              // comentario simple línea
[/][*][^*]*[*]+([^/*][^*]*[*]+)*[/] // comentario multiple líneas

"int"                       {return 'int';}
"double"                    {return 'double';}
"boolean"                   {return 'boolean';}
"char"                      {return 'char';}
"string"                    {return 'string';}
"if"                        {return 'if';}
"else"                      {return 'else';}
"switch"                    {return 'switch';}
"case"                      {return 'case';}
"default"                   {return 'default';}
"print"                     {return 'print';}
"while"                     {return 'while';}
"for"                       {return 'for';}
"do"                        {return 'do';}
"break"                     {return 'break';}
"continue"                  {return 'continue';}
"return"                    {return 'return';}
"void"                      {return 'void';}
"true"                      {return 'true';}
"false"                     {return 'false';}
"new"                       {return 'new';}
"add"                       {return 'add';}
"list"                      {return 'list';}
"tolower"                   {return 'tolower';}
"toupper"                   {return 'toupper';}
"length"                    {return 'length';}
"truncate"                  {return 'truncate';}
"round"                     {return 'round';}
"typeof"                    {return 'typeof';}
"tostring"                  {return 'tostring';}
"tochararray"               {return 'tochararray';}
"exec"                      {return 'exec';}
"++"                        {return 'aumento';}
"--"                        {return 'decremento';}
"=="                        {return 'igualacion';}
"<="                        {return 'menorigual';}
">="                        {return 'mayorigual';}
"!="                        {return 'diferente';}
"<"                         {return 'menor';}
">"                         {return 'mayor';}
"+"                         {return 'mas';}
"-"                         {return 'menos';}
"*"                         {return 'mult';}
"/"                         {return 'division';}
"^"                         {return 'potencia';}
"%"                         {return 'mod';}
"="                         {return 'igual'}
"||"                        {return 'or';}
"&&"                        {return 'and';}
"!"                         {return 'not';}
"\\n"                       {return 'salto';}
"\\\\"                      {return 'barrainv';}
"\\\""                      {return 'comilladoble';}
"\\t"                        {return 'tabulacion';}
"\\'"                       {return 'comillasimple'}
","                         {return 'coma';}
";"                         {return 'pcoma';}
":"                         {return 'dpuntos';}
"?"                         {return 'interrogacion';}
"{"                         {return 'llavea';}
"}"                         {return 'llavec';}
"("                         {return 'parentesisa';}
")"                         {return 'parentisisc';}
"["                         {return 'corchetea';}
"]"                         {return 'corchetec';}
"."                         {return 'punto';}
\"[^\"]*\"                  { yytext = yytext.substr(1,yyleng-2); return 'cadena'; }
\'[^\"]?\'                  { yytext = yytext.substr(1,yyleng-2); return 'caracter'; }
[0-9]+("."[0-9]+)\b        {return 'decimal';}
[0-9]+\b                    {return 'entero';}
([a-zA-Z])[a-zA-Z0-9_]*     {return 'identificador';}
<<EOF>>                     {return 'EOF';}
/lex
%left 'or'
%left 'and'
%right 'not'
%left 'igualacion' 'diferente' 'menor' 'menorigual' 'mayor' 'mayorigual'
%left 'mas' 'menos'
%left 'mult' 'division' 'mod'
%left 'potencia'
%left UMINUS

%start INICIO

%% /* language grammar */


INICIO: PRINCIPAL EOF
;

PRINCIPAL: PRINCIPAL CUERPO
          |CUERPO
;

CUERPO: DECLARACION
           | ASIGNACION
           | IF
           | WHILE
           | DOWHILE
           | SWITCH
           | FOR
           | FUNCION
           | TRANSFERENCIA
           | METODOS
           | PRINT
           | EJECUTAR
           | LLAMADA pcoma
;

INSTRUCCIONES: INSTRUCCIONES INSTRUCCION
               |INSTRUCCION
;

INSTRUCCION: LLAMADA pcoma
           | DECLARACION
           | ASIGNACION
           | IF
           | WHILE
           | DOWHILE
           | SWITCH
           | FOR
           | FUNCION
           | TRANSFERENCIA
           | METODOS
           | PRINT
;

DECLARACION: TIPO identificador igual EXPRESION pcoma 
            | TIPO identificador pcoma 
            | TIPO corchetea corchetec identificador igual new TIPO corchetea EXPRESION corchetec pcoma
            | TIPO corchetea corchetec identificador igual llavea LISTAVALORES llavec pcoma
            | list menor TIPO mayor identificador igual new list menor TIPO mayor pcoma
; 

IF: if parentesisa EXPRESION parentisisc llavea INSTRUCCIONES llavec 
    | if parentesisa EXPRESION parentisisc llavea INSTRUCCIONES llavec else llavea INSTRUCCIONES llavec
    | if parentesisa EXPRESION parentisisc llavea INSTRUCCIONES llavec ELSEIF
    | if parentesisa EXPRESION parentisisc llavea INSTRUCCIONES llavec ELSEIF else llavea INSTRUCCIONES llavec
;

ELSEIF: ELSEIF CONELSEIF
        | CONELSEIF
;

CONELSEIF: else if parentesisa EXPRESION parentisisc llavea INSTRUCCIONES llavec

;

EJECUTAR: exec identificador parentesisa parentisisc pcoma
        | exec identificador parentesisa LISTAVALORES parentisisc pcoma
;

LLAMADA: identificador parentesisa parentisisc 
        | identificador parentesisa LISTAVALORES parentisisc 
;

LISTAVALORES: LISTAVALORES coma EXPRESION
             | EXPRESION
;

EXPRESION: EXPRESION mas EXPRESION
        | EXPRESION menos EXPRESION
        | EXPRESION mult EXPRESION
        | EXPRESION division EXPRESION
        | EXPRESION mod EXPRESION 
        | EXPRESION potencia EXPRESION
        | EXPRESION or EXPRESION 
        | EXPRESION and EXPRESION 
        | EXPRESION igualacion EXPRESION 
        | EXPRESION menor EXPRESION 
        | EXPRESION menorigual EXPRESION 
        | EXPRESION mayor EXPRESION 
        | EXPRESION mayorigual EXPRESION 
        | EXPRESION diferente EXPRESION 
        | not EXPRESION 
        | parentesisa EXPRESION parentisisc          
        | menos EXPRESION %prec UMINUS
        | identificador
        | identificador aumento
        | identificador decremento
        | identificador corchetea EXPRESION corchetec
        | identificador corchetea corchetea EXPRESION corchetec corchetec
        | cadena
        | decimal
        | entero
        | caracter
        | true
        | false
        | LLAMADA
; 

SWITCH: switch parentesisa EXPRESION parentisisc llavea  CASE DEFAULT llavec
      | switch parentesisa EXPRESION parentisisc llavea  CASE llavec
      | switch parentesisa EXPRESION parentisisc llavea  DEFAULT llavec
;

CASE: case EXPRESION dpuntos INSTRUCCIONES 
     | CASE case EXPRESION dpuntos INSTRUCCIONES
     | CASE case EXPRESION dpuntos 
;

DEFAULT: default dpuntos INSTRUCCIONES
;

DOWHILE: do llavea INSTRUCCIONES llavec while parentesisa EXPRESION parentisisc
;

WHILE: while parentesisa EXPRESION parentisisc llavea INSTRUCCIONES llavec
;

FOR: for parentesisa DECLARACION EXPRESION pcoma EXPRESION parentisisc llavea INSTRUCCIONES llavec
   | for parentesisa ASIGNACION EXPRESION pcoma EXPRESION parentisisc llavea INSTRUCCIONES llavec
;

FUNCION: TIPO identificador parentesisa PARAMETROS parentisisc llavea INSTRUCCIONES llavec
        | TIPO identificador parentesisa parentisisc llavea INSTRUCCIONES llavec
;

METODOS: void identificador parentesisa PARAMETROS parentisisc llavea INSTRUCCIONES llavec
       | void identificador parentesisa parentisisc llavea INSTRUCCIONES llavec
;

TRANSFERENCIA: break pcoma
             | continue pcoma
             | return pcoma
             | break EXPRESION pcoma
             
;

PARAMETROS: PARAMETROS coma TIPO identificador
          | TIPO identificador 
;

PRINT: print parentesisa EXPRESION parentisisc pcoma
;

TERNARIO: EXPRESION interrogacion EXPRESION dpuntos EXPRESION pcoma
;
 
ASIGNACION: identificador igual EXPRESION pcoma
            | identificador aumento pcoma
            | identificador decremento pcoma
            | identificador corchetea EXPRESION corchetec igual EXPRESION pcoma
            | identificador punto add parentesisa EXPRESION parentisisc pcoma   
            | identificador corchetea corchetea EXPRESION corchetec corchetec igual EXPRESION pcoma
;        

OTRAS_FUNCIONES: tolower parentesisa EXPRESION parentisisc 
                | toupper parentesisa EXPRESION parentisisc 
                | length parentesisa EXPRESION parentisisc 
                | truncate parentesisa EXPRESION parentisisc 
                | round parentesisa EXPRESION parentisisc
                | typeof parentesisa EXPRESION parentisisc
                | tostring parentesisa EXPRESION parentisisc
                | tochararray parentesisa EXPRESION parentisisc
;

TIPO: int
    | double
    | boolean
    | char  
    | string
;
