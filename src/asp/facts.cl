%% Professors

prof("Muzzetto").
prof("Pozzato").
prof("Gena").
prof("Tomatis").
prof("Micalizio").
prof("Terranova").
prof("Mazzei").
prof("Giordani").
prof("Zanchetta").
prof("Vargiu").
prof("Boniolo").
prof("Damiano").
prof("Suppini").
prof("Valle").
prof("Ghidelli").
prof("Gabardi").
prof("Santangelo").
prof("Taddeo").
prof("Gribaudo").
prof("Schifanella").
prof("Lombardo").
prof("Travostino").

%% Subjects (Subject name, professor, hours)

subject("Introduzione al Master", "", 2).
subject("Recupero", "", 4).

subject("Project Management","Muzzetto",14).
subject("Fondamenti di ICT e Paradigmi di Programmazione","Pozzato",14).
subject("Linguaggi di markup","Gena",20).
subject("La gestione della qualità","Tomatis",10).
subject("Ambienti di sviluppo e linguaggi client-side per il web","Micalizio",20).
subject("Progettazione grafica e design di interfacce","Terranova",10).
subject("Progettazione di basi di dati","Mazzei",20).
subject("Strumenti e metodi di interazione nei Social media","Giordani",14).
subject("Acquisizione ed elaborazione di immagini statiche - grafica","Zanchetta",14).
subject("Accessibilità e usabilità nella progettazione multimediale","Gena",14).
subject("Marketing digitale","Muzzetto", 10).
subject("Elementi di fotografia digitale","Vargiu",10).
subject("Risorse digitali per il progetto: collaborazione e documentazione","Boniolo",10).
subject("Tecnologie server-side per il web","Damiano", 20).
subject("Tecniche e strumenti di Marketing digitale","Zanchetta", 10).
subject("Introduzione al social media management","Suppini", 14).
subject("Acquisizione ed elaborazione del suono","Valle", 10).
subject("Acquisizione ed elaborazione di sequenze di immagini digitali","Ghidelli", 20).
subject("Comunicazione pubblicitaria e comunicazione pubblica","Gabardi", 14).
subject("Semiologia e multimedialità","Santangelo", 10).
subject("Crossmedia: articolazione delle scritture multimediali","Taddeo", 20).
subject("Grafica 3D","Gribaudo", 20).
subject("Progettazione e sviluppo di applicazioni web su dispositivi mobile I","Pozzato", 10).
subject("Progettazione e sviluppo di applicazioni web su dispositivi mobile II","Schifanella", 10).
subject("La gestione delle risorse umane","Lombardo", 10).
subject("I vincoli giuridici del progetto: diritto dei media","Travostino", 10).

%% Subjects pre-requisites (propaeudeutic(A,B) => subject A is a pre-requisite of subject B)

propaedeutic("Fondamenti di ICT e Paradigmi di Programmazione", "Ambienti di sviluppo e linguaggi client-side per il web").
propaedeutic("Ambienti di sviluppo e linguaggi client-side per il web", "Progettazione e sviluppo di applicazioni web su dispositivi mobile I").
propaedeutic("Progettazione e sviluppo di applicazioni web su dispositivi mobile I", "Progettazione e sviluppo di applicazioni web su dispositivi mobile II").
propaedeutic("Progettazione di basi di dati","Tecnologie server-side per il web").
propaedeutic("Linguaggi di markup", "Ambienti di sviluppo e linguaggi client-side per ilweb").
propaedeutic("Project Management", "Marketing digitale").
propaedeutic("Marketing digitale", "Tecniche e strumenti di Marketing digitale").
propaedeutic("Project Management", "Strumenti e metodi di interazione nei Social media").
propaedeutic("Project Management", "Progettazione grafica e design di interfacce").
propaedeutic("Acquisizione ed elaborazione di immagini statiche - grafica", "Elementi di fotografia digitale").
propaedeutic("Elementi di fotografia digitale", "Acquisizione ed elaborazione di sequenze di immagini digitali").
propaedeutic("Acquisizione ed elaborazione di immagini statiche - grafica", "Grafica 3D").

%% Vincolo auspicabile 3

propaedeuticSoft("Fondamenti di ICT e Paradigmi di Programmazione", "Progettazione di basi di dati").
propaedeuticSoft("Tecniche e strumenti di Marketing digitale", "Introduzione al social media management").
propaedeuticSoft("Comunicazione pubblicitaria e comunicazione pubblica", "La gestione delle risorse umane").
propaedeuticSoft("Tecnologie server-side per il web", "Progettazione e sviluppo di applicazioni web su dispositivi mobile I").
