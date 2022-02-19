# Windows Profile Autoremover

## :warning: Používanie na vlastné riziko! :warning:

PowerShell skript určený na mazanie starých lokálnych užívateľských profilov na počítači s OS Windows 10 a novším.

Vhodné pre zdieľané počítače, kde sa strieda niekoľko užívateľov, ktorí sa prihlasujú vlastnými prihlasovacími údajmi (napr. cez Azure AD), kedy sa v počítači vytvorí ich lokálny profil. Pri veľkom počte užívateľov môžu tieto profily zaberať veľké množstvo miesta na disku.

Skript nemaže iba priečinky profilov na disku, ale tiež záznam z Registrov, čím predchádza možnej chybe pri opätovnom prihlásení už zmazaného profilu užívateľa.

Profily je možné mazať na základe doby od posledného prihlásenia, ktorá sa definuje zadaním počtu dní v skripte. Je možné pridať zoznam profilov, ktoré budú z tohto mazania vyňaté, bez ohľadu na počet dní od posledného prihlásenia. 

Skript na mazanie profilov je možné spustiť manuálne užívateľom s oprávneniami správcu alebo automaticky pomocou Plánovača úloh pri spustení počítača. 

## Príprava

1. Vytvoriť priečinok *Scripts* na Lokálnom disku C
2. Nakopírovať *wpa.ps1* do *C:\Scripts*
3. Otvoriť Poznámkový blok
4. Stlačiť *CTRL + O*
5. Prejsť do *C:\Scripts*
6. Vpravo dole zmeniť *Textové dokumenty (*.txt)* na *Všetky súbory* a otvoriť *wpa.ps1*
7. Nastaviť premenné podľa potreby:  
`$olderThan = 7` - profily staršie ako zadaný počet dní budú skriptom zmazané\
`$exludeUsers = "administrator|Public|Ctx_StreamingSvc|NetworkService|Localservice|systemprofile"` - zoznam užívateľských mien profilov, ktoré budú vyňaté z mazania, bez ohľadu na to, kedy bol užívateľ naposledy prihlásený, užívateľské mená sa oddeľujú pípou | (AltGr + W)\
8. Uložiť - CTRL + S

## Nastavenie automatického spúšťania

1. WIN + R  
2. Zadať *taskschd.msc*
3. OK
4. Pravý klik na *Task Scheduler Library*
5. Klik na *Create Task*
6. Vyplniť  
\
**General**  
Name: *Windows Profile Autoremover*  
Vybrať *Run whether user is logged on or not*  
Zaškrtnúť *Run with highest privileges*  
\
**Trigers**  
Klik na *New...*  
Begin the task: At startup  
Klik na OK  
\
**Actions**  
Klik na *New...*  
Action: Start a program  
Pogram/script: *Powershell*  
Add arguments: *-ExecutionPolicy Bypass -File "C:\Scripts\wpa.ps1"*  
Start in: *C:\Windows\System32\WindowsPowerShell\v1.0*  
Klik na OK  
7. Potvrdiť kliknutím OK, pri výzve na zadanie hesla užívateľa s administrátorskými právami, zadať heslo a potvrdiť.
