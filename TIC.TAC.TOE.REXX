/* REXX
   Tic Tac Toe by Attila Kocis 11.11.2022
*/

/* Variablen und Texte vorab definieren */
A1="";A2="";A3="";B1="";B2="";B3="";C1="";C2="";C3=""
G1="";G2="";G3=""
ENDETEXT=""
ENDE="YES"
ABFRAGE="Bitte beide Spielernamen eingeben und mit ENTER bestaetigen:"
CHOOSETX=""
HINWEIS=""

/* Spielernamen definieren - beide muessen gefuellt und nicht identisch sein */
do until START="YES"
   address ispexec "display PANEL(TTT)"
   if NAME1^="" & NAME2^="" & NAME1^=NAME2 then START="YES"
   else do
      zedsmsg="Namenseingabe pruefen!"
      "ispexec setmsg msg(isrz001)"
   end
end

/* CHOOSE ist nur Pflichteingabe im aktiven Spiel, wenn ENDE^="YES" */
ENDE=""

NAME.1 = NAME1
NAME.2 = NAME2
SYM.1 = "X"
SYM.2 = "O"

/* Gueltige Eingabewerte fuer CHOOSE */
EINGABE="A1 A2 A3 B1 B2 B3 C1 C2 C3"

/* Beginnenden Spieler zufaellig auswaehlen */
SPIELER=random(1,2)

/* Anzuzeigende Paneltexte nach Namensvergabe neu definieren */
ABFRAGE=""
CHOOSETX="Bitte ein Spielfeld (z.B. A1) waehlen"
HINWEIS="EXIT eingeben, um das Spiel vorzeitig zu beenden."

/* Spieldurchlauf in Schleife bis ENDE erreicht wurde */
do until ENDE = "YES"
   PLAYER=NAME.SPIELER
   /* Aufruf Panel Feldauswahl */
   address ispexec "display PANEL(TTT)"
   /* Auswertung Eingabe */
   if CHOOSE="EXIT" then exit /* Manueller Spielabbruch */
   /* Eingabe verarbeiten */
   if wordpos(CHOOSE,EINGABE)>0 then do /* Wenn gueltige Eingabe, dann ... */

      if length(value(CHOOSE))>0 then do /* Pruefung auf Feldbelegung */
         zedsmsg="Feld bereits belegt"
         "ispexec setmsg msg(isrz001)"
      end
      else do /* Wenn Feld frei... */
         interpret CHOOSE'='SYM.SPIELER /* Spielersymbol setzen */
         /* Gewinnpruefung */
         S=SYM.SPIELER
         select
            when A1=S & A2=S & A3=S then do
                 G1="A1";G2="A2";G3="A3"
                 call GEWONNEN
                 end
            when B1=S & B2=S & B3=S then do
                 G1="B1";G2="B2";G3="B3"
                 call GEWONNEN
                 end
            when C1=S & C2=S & C3=S then do
                 G1="C1";G2="C2";G3="C3"
                 call GEWONNEN
                 end
            when A1=S & B1=S & C1=S then do
                 G1="A1";G2="B1";G3="C1"
                 call GEWONNEN
                 end
            when A2=S & B2=S & C2=S then do
                 G1="A2";G2="B2";G3="C2"
                 call GEWONNEN
                 end
            when A3=S & B3=S & C3=S then do
                 G1="A3";G2="B3";G3="C3"
                 call GEWONNEN
                 end
            when A1=S & B2=S & C3=S then do
                 G1="A1";G2="B2";G3="C3"
                 call GEWONNEN
                 end
            when A3=S & B2=S & C1=S then do
                 G1="A3";G2="B2";G3="C1"
                 call GEWONNEN
                 end
            otherwise nop
         end
         /* Spielerwechsel */
         if SPIELER="1" then SPIELER="2"
         else SPIELER="1"
      end
   end
   /* Bei ungueltiger Eingabe Vorgang wiederholen */
   else do
       zedsmsg="Eingabe ungueltig!"
       "ispexec setmsg msg(isrz001)"
   end

    /* Pruefen ob bereits alle Felder belegt sind => Unentschieden */
   do i = 1 to words(EINGABE)
      if value(word(EINGABE,i))="" then leave
      if i=9 & STATUS^="GEWONNEN" then call UNENTSCHIEDEN
   end
end

"ispexec display panel(TTT)"

exit

UNENTSCHIEDEN:
STATUS="UNENTSCHIEDEN"
ENDE="YES"
ENDETEXT="Druecken Sie die Eingabetaste um das Spiel zu beenden"
HINWEIS=""
CHOOSETX="Schade, leider unentschieden."
return

GEWONNEN:
STATUS="GEWONNEN"
ENDE = "YES"
ENDETEXT="Druecken Sie die Eingabetaste um das Spiel zu beenden"
HINWEIS=""
CHOOSETX="Der Gewinner der Partie heisst:"
return
