## Travail collaboratif

### L'équipe (Groupe 5)

| Membre | Rôle |
|---|---|
| Enzo Brusaud | Chef de projet : création de l'équipe Teams, du dépôt GitHub et du projet Jira ; V1, V2, V3 ; rédaction du README |
| Wael Saffiedine | Variantes ; relecture du code des versions de base |
| Ilias Bariol-Alaoui | Tests des scripts sur la sortie réelle de wttr.in ; V3 corrigée (option d'historique, correctifs) et variante 3 (gestion des erreurs et des logs) sur la branche `feature/variante3` ; rédaction de la partie travail collaboratif / gestion de projet |
| Matteo Lubat | Membre de l'équipe |
| Mohamed Amine Khadraoui | Membre de l'équipe |

Enseignants ajoutés à l'équipe Teams : M. Bilal Chebaro et M. Cédric Teyssié.

### Outils utilisés

- **Microsoft Teams** : équipe « toulouse-12-26-27 Groupe 5 Projet Configuration d'un poste de travail », avec deux canaux :
  - *Discussion avec les enseignants pour le projet* : échanges avec les enseignants ;
  - *Organisation et avancement du projet* : coordination de l'équipe, partage du code de chaque version, relectures et répartition des tâches.

  L'onglet *Partagé* regroupe le sujet, le dossier attendu et la procédure d'intégration Jira Cloud.
- **Git / GitHub** : dépôt `projet_Extraction_de_donn-es`, créé le 28/10 ; tous les membres y sont ajoutés pour suivre l'avancement à chaque commit. Conventions :
  - une branche par version (`feature/v2`, `feature/v3`, `feature/variante3`…), fusionnée ensuite dans `main` ;
  - un commit par fonctionnalité ajoutée ou à chaque interruption de travail ;
  - les tags `v1`, `v2` et `v3` pour les versions de base, et `Variante1`, `Variante2` et `Variante3` pour les variantes. Cette convention a été décidée le 04/11 pour éviter les erreurs de tags.
- **Jira Cloud** : chaque membre crée son compte, puis le chef de projet invite les membres dans le projet Jira.

### Relecture croisée

Les versions publiées dans Teams sont relues par un autre membre de l'équipe :

- **V1 / V2** : Wael a repéré une parenthèse en trop dans le format de l'heure (`date "+%H:%M)"`), qu'Enzo a corrigée le 04/11.
- **V3** : Wael a signalé que `rm -f` ne fait pas partie des commandes autorisées et a posé une question sur le nom du fichier d'historique.
- **Tests sur données réelles** : Ilias a exécuté la V1/V2 sur la sortie réelle de wttr.in le 05/11. Les colonnes du tableau de prévisions sont séparées par le caractère `│` (trait de tableau) et non par `|`. Le `cut -d"|"` ne découpait donc rien, et le script renvoyait la température du matin au lieu de celle de midi. Ilias a proposé un correctif, testé sur Toulouse et sur Yakutsk pour les températures négatives. Il a aussi corrigé dans la V3 le `$` manquant devant `fichier_historique` (les relevés partaient dans un fichier nommé « fichier_historique ») et ajouté l'option d'archivage demandée par le sujet.

## Gestion de projet

### Approche

Nous avons suivi une démarche **incrémentale**, en suivant le découpage du sujet :

1. **Une version à la fois** : V1 → V2 → V3 → variantes. Chaque version est fonctionnelle avant de passer à la suivante.
2. **Une version = un cycle court** : développement, publication du code dans Teams, relecture par un autre membre, correction, puis commit et tag Git.
3. **Répartition par blocs** : les versions de base sont confiées à un membre et les variantes à un autre, pour avancer en parallèle. Les autres membres se chargent des tests et de la rédaction du dossier.
4. **Suivi** : Teams sert de point de coordination quotidien, GitHub d'historique technique (commits, tags), et Jira de suivi des tâches.

### Chronologie

| Date | Étape |
|---|---|
| 15/10 | Création de l'équipe Teams par le chef de projet (canaux, ajout du bot Jira) |
| 19/10 | Invitation des membres dans l'équipe Teams (comptes MIAGE) |
| 20/10 | Message de lancement : objectif (dossier complet), échéance du 06/11, Git comme espace de travail ; lecture du sujet et recueil des disponibilités pour une réunion de lancement |
| 28/10 | Création du dépôt GitHub et partage du lien |
| 02/11 | Création des comptes Jira, invitation sur le projet Jira et sur le dépôt GitHub |
| 03/11 | V1 terminée ; tentative d'intégration Jira–Teams, bloquée par les droits d'administration, et mail à M. Chebaro |
| 04/11 | M. Chebaro transmet la demande à M. Teyssié (administrateur) ; V1, V2 et explication de cron partagées et relues ; répartition V3 / variantes / rapport ; convention de tags |
| 05/11 | Tests sur la sortie réelle de wttr.in et correctif de l'extraction de la prévision ; branche `feature/variante3` : V3 corrigée puis variante 3 ; variantes 1 et 2 en cours |
| 06/11 | Rendu du dossier |

### Difficultés rencontrées et solutions

| Difficulté | Solution |
|---|---|
| L'intégration Jira–Teams demande des droits que le chef de projet n'a pas | Demande à M. Chebaro, transmise à M. Teyssié (administrateur) ; en attendant, le suivi se fait dans le canal Teams |
| Blocage du campus : certains membres ne peuvent pas venir à la fac | Coordination entièrement à distance via Teams, code partagé dans les publications et sur GitHub |
| Commandes limitées (`grep`, `head`, `tail`, `tr`, `cut`, `rev`, `xargs`, `echo`) | Suppression de `rm -f`, inutile puisque `>` écrase le fichier brut à chaque exécution ; usage de `date` à confirmer auprès des enseignants |
| Format du tableau wttr.in (séparateur `│`) | Extraction par motif `grep -o -E` sur les températures au lieu d'un découpage par colonnes |

## Solution implémentée : V3 corrigée et variante 3 (Ilias Bariol-Alaoui)

Code sur la branche `feature/variante3`, fichier `Extracteur_Meteo.sh`.

### Utilisation

```bash
./Extracteur_Meteo.sh                 # Toulouse par défaut (V2)
./Extracteur_Meteo.sh Paris           # ville passée en argument
./Extracteur_Meteo.sh -h Paris        # V3 : archive aussi le relevé dans meteo_AAAAMMJJ.txt
```

### Extraction des températures (correctif des versions de base)

La sortie texte de wttr.in contient d'abord un bloc « conditions actuelles », puis trois tableaux : aujourd'hui, demain et après-demain. Chaque tableau a une ligne de températures découpée en 4 colonnes (matin, midi, soir, nuit), séparées par le caractère `│`.

- **Température actuelle** : `grep "°C" | head -1` isole la première ligne contenant `°C`, celle des conditions actuelles. `grep -o -E "[-+]?[0-9°]+" | head -1` garde le premier nombre signé, et `tr -d "+"` retire le signe `+`.
- **Prévision du lendemain** : `grep "°C" | head -3 | tail -1` isole la 3e ligne contenant `°C`, celle de demain. Ensuite :
  1. `grep -o -E "[-+]?[0-9]+(\([-+]?[0-9]+\))? °C"` extrait les 4 températures de la ligne, par exemple `+8(9) °C`, `+14(15) °C`, `+12(11) °C` et `10 °C` ;
  2. `head -2 | tail -1` garde la 2e, celle de midi : `+14(15) °C` ;
  3. `cut -d"(" -f1 | cut -d" " -f1 | tr -d "+"` retire la température ressentie, l'unité et le signe : `14`.

Cette méthode ne dépend pas du séparateur `│`, que `cut` ne sait pas utiliser car c'est un caractère sur plusieurs octets. Elle fonctionne aussi avec les températures négatives (`-18(-23) °C` donne `-18`).

### V3 : gestion de l'historique

- L'option `-h` est lue en premier argument. `shift` la retire pour que la ville reste dans `$1`.
- Le nom du fichier du jour est construit avec `meteo_$(date "+%Y%m%d").txt`. Chaque exécution ajoute sa ligne au fichier avec `>>` : on obtient un fichier par jour.
- `meteo.txt` continue de recevoir chaque relevé, comme en V1 et V2.
- Correctifs apportés à la V3 initiale :
  - le `$` manquait devant `fichier_historique`, donc la ligne partait dans un fichier nommé « fichier_historique » ;
  - une parenthèse en trop apparaissait dans l'heure ;
  - `rm -f` a été retiré, car il n'est pas autorisé et inutile : `>` écrase déjà `meteo_brut.txt`.

### Variante 3 : gestion des erreurs et des logs

- La fonction `erreur` ajoute une ligne `[AAAA-MM-JJ HH:MM:SS] ERREUR (ville) : message` à `meteo_error.log`, affiche l'erreur et arrête le script (`exit 1`). Elle ne pollue donc pas `meteo.txt` avec une ligne vide.
- Trois cas sont détectés :
  1. **wttr.in injoignable ou ville inconnue** : avec `curl -s -f`, curl échoue sur une erreur HTTP (wttr.in renvoie une erreur 500 pour une ville inconnue) comme sur une absence de connexion ;
  2. **réponse vide ou sans température** : `grep -q "°C"` ne trouve rien ;
  3. **températures introuvables** : l'une des deux variables est vide après l'extraction.

### Tests réalisés (05/11)

| Cas testé | Commande | Résultat obtenu |
|---|---|---|
| Ville par défaut | `./Extracteur_Meteo.sh` | `2026-11-05 - 09:43 - Toulouse : 7°C - 14°C` |
| Températures négatives | `./Extracteur_Meteo.sh Yakutsk` | `2026-11-05 - 09:43 - Yakutsk : -15°C - -18°C` |
| Ville avec espace + historique | `./Extracteur_Meteo.sh -h "Saint Petersburg"` | ligne ajoutée à `meteo.txt` et à `meteo_20261105.txt` |
| Ville inconnue | `./Extracteur_Meteo.sh Zzqxwvlk` | `[2026-11-05 09:43:11] ERREUR (Zzqxwvlk) : impossible de récupérer la météo depuis wttr.in (connexion impossible ou ville inconnue)` dans `meteo_error.log`, code de sortie 1 |
| Serveur injoignable | hôte volontairement invalide | même message horodaté dans `meteo_error.log`, code de sortie 1 |

Commandes de traitement utilisées : `grep`, `head`, `tail`, `tr`, `cut` et `echo`, plus `curl` pour la récupération et `date` pour l'horodatage (usage de `date` à confirmer avec les enseignants).
