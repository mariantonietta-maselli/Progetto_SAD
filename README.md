# Analisi Statistica dei domini all'interno degli URL di Phishing
Questo repository contiene tutti gli artefatti prodotti per l'analisi statistica ed è stato organizzato come segue:
- **Script**: Nella cartella principale del repository sono contenuti tutti gli script realizzati:
    * **ScriptUniVar.R**: Questo script permette di calcolare le principali statistiche descrittive univariate per le feature considerate;
    * **ScriptBiVar.R**: Questo script analizza le correlazioni tra le feature principali e un modello di regressione lineare;
    * **ScriptPlot.R**: Questo script permette di visualizzare i grafici delle frequenze delle feature (barplot e istogrammi) e alcuni boxplot;
    * **ScriptDSClean.R**: Questo script si occupa di ripulire il dataset dalle feature inutilizzate e della rimozione degli outlier per le feature principali;
    * **ScriptChiQuadEnt.R**: Questo script realizza il test del chi-quadrato rispetto a un sample dell'1% della partizione Phishing del dataset, relativamente alla variabile di entropia del dominio;
    * **ScriptStime.R**: Questo script permette di calcolare le stime puntuali e intervallari della popolazione, per la variabile studiata con il test del chi-quadrato;
    * **ScriptRDup.R**: Questo script si occupa di rimuovere i duplicati dal sample sintetico generato;
- **Datasets**: Nella directory datasets/ sono contenute tutte le versioni del dataset ottenute, in seguito a diverse operazioni e trasformazioni:
    * **Dataset.csv**: La versione originale del dataset, recuperata dal seguente [link]([url](https://data.mendeley.com/datasets/6tm2d6sz7p/1));
    * **Datset_Phishing.csv**: La versione contenente solamente la partizione relativa alle osservazioni con Type = 1 (Phishing);
    * **Dataset_Legitimate.csv**: La versione contenente solamente la partizione relativa alle osservazioni con Type = 0 (Legitimate);
    * **Dataset_Clean.csv**: La versione contentente le feature che non sono state rimosse, in seguito al primo cleaning;
    * **Dataset_Clean_Phishing.csv**: La versione clean relativa alla partizione Phishing;
    * **Dataset_Clean_Phishing_Domain.csv**: La versione clean relativa alla partizione Phishing, contenente solamente le feature utili relative al dominio;
    * **Dataset_Clean_Phishing_Domain_Inlier.csv**: La versione clean relativa alla partizione Phishing, contenente solamente le feature utili relative al dominio e con gli outlier rimossi per le feature interessate;
    * **Dataset_Phishing_Sample1p.csv**: La versione sample della partizione Phishing, contenente l'1% di osservazioni selezionate in maniera randomica e utilizzata per la statistica inferenziale;
    * **Dataset_Phishing_Sample_Qwen.csv**: La versione sample dei dati sintetici, generata tramite l'LLM Qwen2.5-Plus;
    * **Dataset_Phishing_Sample_Qwen_NoDup.csv**: La versione sample dei dati sintetici, generata tramite l'LLM Qwen2.5-Plus e con i duplicati rimossi;
    * **Dataset_Phishing_Sample_Qwen_NoDup_1p.csv**: La versione sample dei dati sintetici, generata tramite l'LLM Qwen2.5-Plus e con i duplicati rimossi, con un numero di righe pari al sample reale;
- **Output**: Nella directory output/ sono contenuti i risultati delle analisi univariate su alcune versioni del dataset, in formato xlsx
